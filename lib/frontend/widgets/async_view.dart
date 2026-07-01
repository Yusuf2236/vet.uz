import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// `Future`/repository natijasini standart loading / xato / bo'sh / data
/// holatlari bilan ko'rsatuvchi qayta ishlatiladigan widget.
/// Butun ilovada izchil holat boshqaruvi uchun.
class AsyncView<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
  final bool Function(T data)? isEmpty;
  final VoidCallback? onRetry;
  final String emptyMessage;
  final EdgeInsetsGeometry padding;

  const AsyncView({
    super.key,
    required this.future,
    required this.builder,
    this.isEmpty,
    this.onRetry,
    this.emptyMessage = "Ma'lumot topilmadi",
    this.padding = const EdgeInsets.all(AppSpacing.xxxl),
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return _StateMessage(
            icon: Icons.cloud_off,
            message: "Ma'lumotni yuklab bo'lmadi",
            onRetry: onRetry,
            padding: padding,
          );
        }
        final data = snap.data as T;
        if (isEmpty != null && isEmpty!(data)) {
          return _StateMessage(
            icon: Icons.inbox_outlined,
            message: emptyMessage,
            onRetry: onRetry,
            padding: padding,
          );
        }
        return builder(context, data);
      },
    );
  }
}

class _StateMessage extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback? onRetry;
  final EdgeInsetsGeometry padding;

  const _StateMessage({
    required this.icon,
    required this.message,
    required this.padding,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.textMuted),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: secondary),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: onRetry,
                child: const Text('Qayta urinish'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
