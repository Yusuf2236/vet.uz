import 'package:flutter/material.dart';

import '../../../backend/repositories/ai_repository.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/preferences_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_data.dart';
import '../../../backend/repositories/disease_repository.dart';
import '../../models/disease.dart';

/// VetAI — Simpson-tekshiruvchi va Gemini AI chat boti.
/// Kalit bo'lmaganda offline rejimda simptomlarni solishtiradi,
/// kalit bo'lganda Gemini AI orqali har qanday savolga javob beradi.
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
  final bool isLoading;
  const _AiMessage({
    required this.isUser,
    this.text = '',
    this.disease,
    this.noMatch = false,
    this.isLoading = false,
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

  Future<void> _send(String raw) async {
    final text = raw.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_AiMessage(isUser: true, text: text));
      _input.clear();
    });
    _scrollToBottom();

    final apiKey = PreferencesService.instance.geminiApiKey ?? '';
    if (apiKey.isEmpty) {
      // Offline mock match mode
      final match = _match(text);
      setState(() {
        _messages.add(
          match != null
              ? _AiMessage(isUser: false, disease: match)
              : const _AiMessage(isUser: false, noMatch: true),
        );
      });
      _scrollToBottom();
    } else {
      // Online Gemini API mode
      const loader = _AiMessage(isUser: false, isLoading: true);
      setState(() {
        _messages.add(loader);
      });
      _scrollToBottom();

      try {
        final history = _messages
            .where((m) => !m.isLoading && m.disease == null && !m.noMatch)
            .map((m) => {
                  'role': m.isUser ? 'user' : 'model',
                  'text': m.text,
                })
            .toList();

        final aiRepo = AiRepository();
        final response = await aiRepo.getAiResponse(history, apiKey);

        if (mounted) {
          setState(() {
            _messages.remove(loader);
            _messages.add(_AiMessage(isUser: false, text: response));
          });
          _scrollToBottom();
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _messages.remove(loader);
            _messages.add(_AiMessage(isUser: false, text: "Xatolik: $e"));
          });
          _scrollToBottom();
        }
      }
    }
  }

  void _scrollToBottom() {
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

  void _showApiKeyDialog(BuildContext context) {
    final controller = TextEditingController(text: PreferencesService.instance.geminiApiKey ?? '');
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Row(
          children: [
            const Icon(Icons.vpn_key_rounded, color: AppColors.amber),
            const SizedBox(width: AppSpacing.sm),
            Text("Gemini API Kaliti", style: AppTextStyles.h3),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ilova har qanday mavzuda to'liq va erkin javob berishi uchun shaxsiy Gemini API kalitingizni kiriting:",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'AIzaSy...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              obscureText: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            GestureDetector(
              onTap: () {
                // Open standard website info or instruction
              },
              child: const Text(
                "Kalitni bepul olish: aistudio.google.com",
                style: TextStyle(
                  color: AppColors.info,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Bekor qilish", style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () async {
              await PreferencesService.instance.setGeminiApiKey(controller.text.trim());
              if (mounted) setState(() {});
              if (context.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("API kaliti muvaffaqiyatli saqlandi!")),
                );
              }
            },
            child: const Text("Saqlash", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildApiKeyBanner() {
    final apiKey = PreferencesService.instance.geminiApiKey ?? '';
    if (apiKey.isNotEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      color: AppColors.amber.withValues(alpha: isDark ? 0.15 : 0.08),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.amber, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              "VetAI offline rejimda. Erkin mavzudagi savollarga javob olish uchun API kalitini kiriting.",
              style: AppTextStyles.caption.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          TextButton(
            onPressed: () => _showApiKeyDialog(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              backgroundColor: AppColors.amber.withValues(alpha: 0.12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
            ),
            child: const Text(
              "Kalit kiritish",
              style: TextStyle(
                color: AppColors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final apiKey = PreferencesService.instance.geminiApiKey ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.aiAssistant, style: AppTextStyles.h3),
        actions: [
          IconButton(
            icon: Icon(
              apiKey.isEmpty ? Icons.vpn_key_outlined : Icons.vpn_key_rounded,
              color: apiKey.isEmpty ? AppColors.amber : AppColors.primary,
            ),
            onPressed: () => _showApiKeyDialog(context),
            tooltip: 'Gemini API Kaliti',
          ),
        ],
      ),
      body: Column(
        children: [
          _AnimalSelector(
            animals: MockData.aiAnimals,
            selected: _animal,
            onSelected: (a) => setState(() => _animal = a),
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          _buildApiKeyBanner(),
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
    
    // Custom error message with tip to enter API key if no match offline
    String text = message.text;
    if (message.noMatch) {
      text = "${AppStrings.aiNoMatch}\n\n💡 Maslahat: Har qanday savollarga to'liq va erkin javob olish uchun yuqoridagi 🔑 tugmasi orqali shaxsiy Gemini API kalitingizni kiriting.";
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
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
        child: message.isLoading
            ? const SizedBox(
                height: 20,
                width: 45,
                child: Center(child: _TypingIndicator()),
              )
            : Text(
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

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final double value = (1.0 - ((_controller.value - delay) % 1.0).abs() * 2).clamp(0.0, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.3 + 0.7 * value),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}
