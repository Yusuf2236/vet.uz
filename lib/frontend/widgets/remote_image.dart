import 'package:flutter/material.dart';

/// Tarmoq rasmi — yuklanayotganda silliq placeholder, xato/internetsiz holatda
/// [fallback] (ikonka/initial) ko'rsatiladi. Shu tufayli ilova doim ishlaydi.
class RemoteImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final WidgetBuilder fallbackBuilder;

  const RemoteImage({
    super.key,
    required this.url,
    required this.fallbackBuilder,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    // Bo'sh URL Image.network ichida sinxron exception beradi va errorBuilder'ni
    // chetlab o'tadi — shuning uchun darhol fallback ko'rsatamiz.
    if (url.isEmpty) return fallbackBuilder(context);
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: fit,
        errorBuilder: (context, error, stack) => fallbackBuilder(context),
      );
    }
    return Image.network(
      url,
      fit: fit,
      gaplessPlayback: true,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _Placeholder(child: fallbackBuilder(context));
      },
      errorBuilder: (context, error, stack) => fallbackBuilder(context),
    );
  }
}

/// Yuklanish paytidagi xira fon (fallback ustida).
class _Placeholder extends StatelessWidget {
  final Widget child;
  const _Placeholder({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ],
    );
  }
}
