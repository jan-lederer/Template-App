import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Flutter rendering of the same mark used by Android's `ic_launcher.xml`.
class AppBrandIcon extends StatelessWidget {
  const AppBrandIcon({this.size = 36, super.key});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: const CustomPaint(painter: _AppBrandPainter()),
  );
}

class _AppBrandPainter extends CustomPainter {
  const _AppBrandPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 48, size.height / 48);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(2, 2, 44, 44),
        const Radius.circular(8),
      ),
      Paint()..color = AppColors.brandMark,
    );
    final foreground = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(16.5, 24), 3.5, foreground);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(25, 22, 10, 4),
        const Radius.circular(2),
      ),
      foreground,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AppBrandPainter oldDelegate) => false;
}
