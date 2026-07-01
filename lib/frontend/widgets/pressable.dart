import 'package:flutter/material.dart';

/// Bosish (tap) animatsiyasi — bosilganda element biroz kichrayadi va
/// xiralashadi, qo'yib yuborilganda asl holiga qaytadi.
/// Barcha bosiladigan kartalar/tugmalar shu widget bilan o'raladi.
class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final double pressedOpacity;
  final Duration duration;

  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.97,
    this.pressedOpacity = 0.92,
    this.duration = const Duration(milliseconds: 110),
  });

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  bool get _enabled => widget.onTap != null;

  void _setDown(bool value) {
    if (!_enabled || !mounted) return;
    setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: _enabled ? (_) => _setDown(true) : null,
      onTapUp: _enabled ? (_) => _setDown(false) : null,
      onTapCancel: _enabled ? () => _setDown(false) : null,
      child: AnimatedScale(
        scale: _down ? widget.pressedScale : 1.0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: _down ? widget.pressedOpacity : 1.0,
          duration: widget.duration,
          child: widget.child,
        ),
      ),
    );
  }
}
