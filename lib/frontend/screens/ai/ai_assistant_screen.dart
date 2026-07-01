import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_data.dart';
import '../../../backend/repositories/disease_repository.dart';
import '../../models/disease.dart';

/// VetAI — oddiy qoidaga asoslangan simptom-tekshiruvchi.
/// Tanlangan hayvon bo'yicha kiritilgan belgilarni kasalliklar bilan
/// solishtirib, ehtimoliy holat va tavsiyani qaytaradi (research datasi).
class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiMessage {
  final bool isUser;
  final String text;
  final Disease? disease;
  final bool noMatch;
  const _AiMessage({
    required this.isUser,
    this.text = '',
    this.disease,
    this.noMatch = false,
  });
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  String _animal = MockData.aiAnimals.first;
  final List<_AiMessage> _messages = [
    const _AiMessage(isUser: false, text: AppStrings.aiGreeting),
  ];

  final DiseaseRepository _repo = DiseaseRepository();
  List<Disease> _diseases = const [];

  @override
  void initState() {
    super.initState();
    _repo.fetchDiseases().then((data) {
      if (mounted) setState(() => _diseases = data);
    });
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  List<Disease> get _animalDiseases =>
      _diseases.where((d) => d.animal == _animal).toList();

  /// Tanlangan hayvon kasalliklaridan tavsiya etiladigan belgilar (chiplar).
  List<String> get _suggestedSymptoms {
    final out = <String>[];
    for (final d in _animalDiseases) {
      if (d.symptoms.isNotEmpty) out.add(d.symptoms.first);
    }
    return out.take(4).toList();
  }

  Disease? _match(String input) {
    final words = input
        .toLowerCase()
        .split(RegExp(r'[^0-9a-zA-Zа-яёʻ’Ѐ-ӿ]+'))
        .where((w) => w.length >= 4)
        .toSet();
    if (words.isEmpty) return null;

    Disease? best;
    var bestScore = 0;
    for (final d in _animalDiseases) {
      var score = 0;
      final nameLower = d.name.toLowerCase();
      if (words.any(nameLower.contains)) score += 2;
      for (final s in d.symptoms) {
        final sl = s.toLowerCase();
        if (words.any(sl.contains)) score++;
      }
      if (score > bestScore) {
        bestScore = score;
        best = d;
      }
    }
    return bestScore > 0 ? best : null;
  }

  void _send(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return;
    final match = _match(text);
    setState(() {
      _messages.add(_AiMessage(isUser: true, text: text));
      _messages.add(
        match != null
            ? _AiMessage(isUser: false, disease: match)
            : const _AiMessage(isUser: false, noMatch: true),
      );
      _input.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.aiAssistant, style: AppTextStyles.h3),
      ),
      body: Column(
        children: [
          _AnimalSelector(
            animals: MockData.aiAnimals,
            selected: _animal,
            onSelected: (a) => setState(() => _animal = a),
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(AppSpacing.screenH),
              itemCount: _messages.length,
              itemBuilder: (context, i) =>
                  _MessageBubble(message: _messages[i]),
            ),
          ),
          _SuggestedChips(symptoms: _suggestedSymptoms, onTap: _send),
          _InputBar(controller: _input, onSend: () => _send(_input.text)),
        ],
      ),
    );
  }
}

class _AnimalSelector extends StatelessWidget {
  final List<String> animals;
  final String selected;
  final ValueChanged<String> onSelected;

  const _AnimalSelector({
    required this.animals,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenH,
          vertical: AppSpacing.sm,
        ),
        itemCount: animals.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final active = animals[i] == selected;
          return GestureDetector(
            onTap: () => onSelected(animals[i]),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: active
                      ? AppColors.primary
                      : Theme.of(context).dividerColor,
                ),
              ),
              child: Text(
                animals[i],
                style: AppTextStyles.bodyStrong.copyWith(
                  color: active
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _AiMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.disease != null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: _DiseaseCard(disease: message.disease!),
      );
    }

    final isUser = message.isUser;
    final text = message.noMatch ? AppStrings.aiNoMatch : message.text;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: isUser
              ? null
              : Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Text(
          text,
          style: AppTextStyles.body.copyWith(
            color: isUser
                ? Colors.white
                : Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }
}

class _DiseaseCard extends StatelessWidget {
  final Disease disease;
  const _DiseaseCard({required this.disease});

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.85,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: disease.urgent
              ? AppColors.danger.withValues(alpha: 0.5)
              : Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppStrings.aiPossible,
                style: AppTextStyles.label.copyWith(color: secondary),
              ),
              const Spacer(),
              if (disease.urgent)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    AppStrings.aiUrgentTag,
                    style: AppTextStyles.label.copyWith(color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            disease.name,
            style: AppTextStyles.h3.copyWith(color: titleColor),
          ),
          const SizedBox(height: AppSpacing.md),
          ...disease.symptoms
              .take(4)
              .map(
                (s) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(
                        child: Text(
                          s,
                          style: AppTextStyles.caption.copyWith(
                            color: secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Text(
              disease.advice,
              style: AppTextStyles.body.copyWith(color: titleColor),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.aiDisclaimer,
            style: AppTextStyles.label.copyWith(color: secondary),
          ),
        ],
      ),
    );
  }
}

class _SuggestedChips extends StatelessWidget {
  final List<String> symptoms;
  final ValueChanged<String> onTap;

  const _SuggestedChips({required this.symptoms, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (symptoms.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
        itemCount: symptoms.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) => ActionChip(
          label: Text(
            symptoms[i].length > 28
                ? '${symptoms[i].substring(0, 28)}…'
                : symptoms[i],
            style: AppTextStyles.label,
          ),
          onPressed: () => onTap(symptoms[i]),
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.sm,
        AppSpacing.screenH,
        AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: const InputDecoration(
                  hintText: AppStrings.aiInputHint,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Material(
              color: AppColors.primary,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onSend,
                child: const SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(Icons.send_rounded, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
