import 'package:flutter/material.dart';

/// Theme-colored dashboard mark shared with Android's multicolor launcher icon.
class AppBrandIcon extends StatelessWidget {
  const AppBrandIcon({this.size = 36, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox.square(
      dimension: size,
      child: Padding(
        padding: EdgeInsets.all(size * 2 / 48),
        child: DecoratedBox(
          key: const ValueKey('app-brand-icon-background'),
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(size * 8 / 48),
          ),
          child: CustomPaint(
            key: const ValueKey('app-brand-dashboard-mark'),
            painter: _AppBrandPainter(foreground: scheme.onPrimary),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class _AppBrandPainter extends CustomPainter {
  const _AppBrandPainter({required this.foreground});

  final Color foreground;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 44, size.height / 44);
    canvas.translate(-2, -2);
    final markPaint = Paint()..color = foreground;
    for (final tile in const [
      Rect.fromLTWH(13, 13, 9, 9),
      Rect.fromLTWH(26, 13, 9, 9),
      Rect.fromLTWH(13, 26, 9, 9),
      Rect.fromLTWH(26, 26, 9, 9),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(tile, const Radius.circular(2)),
        markPaint,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AppBrandPainter oldDelegate) =>
      oldDelegate.foreground != foreground;
}
