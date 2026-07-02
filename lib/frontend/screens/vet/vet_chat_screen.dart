import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import '../../../backend/repositories/profile_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/text_utils.dart';
import '../../core/constants/app_images.dart';
import '../../models/user_profile.dart';
import '../../models/veterinarian.dart';
import '../../widgets/remote_image.dart';

/// Veterinar bilan jonli suhbat oynasi.
class VetChatScreen extends StatefulWidget {
  final Veterinarian vet;
  const VetChatScreen({super.key, required this.vet});

  @override
  State<VetChatScreen> createState() => _VetChatScreenState();
}

class _VetChatScreenState extends State<VetChatScreen> {
  final List<_ChatMessage> _messages = [];
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  UserProfile? _user;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _messages.add(
      _ChatMessage(
        text: "Assalomu alaykum! Men ${widget.vet.name}. Hayvoningizda qanday bezovtaliklar bor? Yoki qanday yordam kerak?",
        isMe: false,
        time: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    );
  }

  Future<void> _loadUser() async {
    final p = await ProfileRepository().fetchCurrentProfile();
    setState(() => _user = p);
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
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

  void _sendMessage() {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    _input.clear();

    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        isMe: true,
        time: DateTime.now(),
      ));
    });
    _scrollToBottom();

    // Shifokor javobini simulyatsiya qilish
    setState(() => _isTyping = true);
    _scrollToBottom();

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(_ChatMessage(
          text: _generateReply(text),
          isMe: false,
          time: DateTime.now(),
        ));
      });
      _scrollToBottom();
    });
  }

  String _generateReply(String userMsg) {
    final msg = userMsg.toLowerCase();
    if (msg.contains('sigir') || msg.contains('buzoq') || msg.contains('mol')) {
      return "Qoramollarda bunday holat ko'pincha ozuqa o'zgarishi yoki hazm qilish tizimidagi buzilishlar tufayli yuz beradi. Iltimos, hayvonning haroratini o'lchab bera olasizmi va ozuqasiga nimalar qo'shayotganingizni yozib yuboring.";
    }
    if (msg.contains('it') || msg.contains('kuchuk') || msg.contains('mushuk')) {
      return "Kichik hayvonlarda ishtaha yo'qolishi va sustlik ko'pincha virusli infeksiya yoki parazitlar belgisi bo'lishi mumkin. Emlash pasporti bormi? Oxirgi marta qachon emlangani haqida ma'lumot bersangiz yaxshi bo'lardi.";
    }
    if (msg.contains('emlash') || msg.contains('privivka') || msg.contains('vaksina')) {
      return "Emlash tadbirlari hayvon turiga qarab individual rejalashtiriladi. Hozirda bizda barcha turdagi yuqori sifatli vaksinalar mavjud. Tafsilotlarni aniqlashtirish uchun emlash rejasini sizga yuborishim mumkin.";
    }
    if (msg.contains('dori') || msg.contains('retsept') || msg.contains('ukol')) {
      return "Tashxisni aniq qo'ymasdan turib biron-bir dori vositasini tavsiya etish xavfli bo'lishi mumkin. Hayvonning umumiy holati va harorati qanday?";
    }
    if (msg.contains('rahmat') || msg.contains('tashakkur') || msg.contains('ok')) {
      return "Sog' bo'ling! Agar qo'shimcha savollar tug'ilsa, istalgan vaqtda murojaat qilishingiz mumkin. Hayvoningizga shifo tilayman!";
    }
    return "Tushundim. Bu holat bo'yicha hayvonning umumiy ahvoli (ishtahasi, tana harorati va harakatchanligi) haqida batafsilroq ma'lumot bera olasizmi? Agar iloji bo'lsa, qisqa video yoki rasm yuklang.";
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            ClipOval(
              child: SizedBox(
                width: 36,
                height: 36,
                child: RemoteImage(
                  url: AppImages.avatar(widget.vet.name),
                  fallbackBuilder: (c) => Container(color: AppColors.primary, child: Center(child: Text(widget.vet.initials, style: const TextStyle(color: Colors.white)))),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.vet.name, style: AppTextStyles.title.copyWith(color: titleColor)),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text("Faol", style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${widget.vet.name} bilan aloqa bog'lanmoqda...")),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                return _MessageBubble(message: m, user: _user, vet: widget.vet);
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xs),
              child: Row(
                children: [
                  Text(
                    "${widget.vet.name} yozmoqda...",
                    style: AppTextStyles.caption.copyWith(fontStyle: FontStyle.italic, color: secondary),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_photo_alternate_outlined, color: AppColors.primary),
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Fayl biriktirish"),
                          content: const Text("Ushbu turdagi fayllarni biriktirishingiz mumkin: Rasm, Video, Hujjat."),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Yopish")),
                          ],
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: TextField(
                        controller: _input,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: const InputDecoration(
                          hintText: "Xabar yozing...",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  IconButton(
                    icon: const Icon(Icons.send, color: AppColors.primary),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;

  _ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  final UserProfile? user;
  final Veterinarian vet;

  const _MessageBubble({
    required this.message,
    required this.user,
    required this.vet,
  });

  @override
  Widget build(BuildContext context) {
    final alignment = message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = message.isMe
        ? AppColors.primary
        : (Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[850]
            : Colors.grey[100]);
    final textColor = message.isMe
        ? Colors.white
        : (Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black87);

    final avatarUrl = message.isMe ? user?.avatarUrl : null;
    final initials = message.isMe ? TextUtils.initials(user?.fullName ?? "F") : vet.initials;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe) ...[
            ClipOval(
              child: SizedBox(
                width: 28,
                height: 28,
                child: RemoteImage(
                  url: AppImages.avatar(vet.name),
                  fallbackBuilder: (c) => Container(color: AppColors.primaryLight, child: Center(child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 10)))),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: alignment,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(message.isMe ? 16 : 4),
                      bottomRight: Radius.circular(message.isMe ? 4 : 16),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: AppTextStyles.body.copyWith(color: textColor),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${message.time.hour.toString().padLeft(2, '0')}:${message.time.minute.toString().padLeft(2, '0')}",
                      style: AppTextStyles.caption.copyWith(color: AppColors.textMuted, fontSize: 10),
                    ),
                    if (message.isMe) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.done_all, size: 12, color: AppColors.primary),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (message.isMe) ...[
            const SizedBox(width: 8),
            ClipOval(
              child: SizedBox(
                width: 28,
                height: 28,
                child: (avatarUrl != null && avatarUrl.isNotEmpty)
                    ? (avatarUrl.startsWith('http')
                        ? Image.network(avatarUrl, width: 28, height: 28, fit: BoxFit.cover)
                        : Image.file(File(avatarUrl), width: 28, height: 28, fit: BoxFit.cover))
                    : Container(
                        color: AppColors.primary,
                        alignment: Alignment.center,
                        child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 10)),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
