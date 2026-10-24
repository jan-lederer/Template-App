import 'dart:math' as math;

import 'package:flutter/material.dart';

class FocusLoadingScreen extends StatefulWidget {
  const FocusLoadingScreen({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<FocusLoadingScreen> createState() => _FocusLoadingScreenState();
}

class _FocusLoadingScreenState extends State<FocusLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1200),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) widget.onFinished();
        });
    _progress = Tween<double>(begin: .42, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xff080d18),
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => AnimatedBuilder(
          animation: _progress,
          builder: (context, child) => Semantics(
            key: const ValueKey('focus-launch-screen'),
            label: 'Ideas deserve a clear start. Opening your workspace.',
            child: CustomPaint(
              size: constraints.biggest,
              painter: _FocusLoadingPainter(progress: _progress.value),
              child: child,
            ),
          ),
          child: const SizedBox.expand(),
        ),
      ),
    ),
  );
}

class _FocusLoadingPainter extends CustomPainter {
  const _FocusLoadingPainter({required this.progress});

  final double progress;

  static const _ink = Color(0xffe7eff8);
  static const _muted = Color(0xff99acc2);
  static const _ion = Color(0xff19b8aa);
  static const _violet = Color(0xff8d78f6);
  static const _coral = Color(0xffe77860);
  static const _mint = Color(0xff2c9b76);

  @override
  void paint(Canvas canvas, Size size) {
    final background = Offset.zero & size;
    canvas.drawRect(
      background,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff080d18), Color(0xff0d1625)],
        ).createShader(background),
    );

    final scale = math.min(size.width / 390, size.height / 844);
    if (scale <= 0) return;
    canvas.save();
    canvas.translate(
      (size.width - 390 * scale) / 2,
      (size.height - 844 * scale) / 2,
    );
    canvas.scale(scale);

    _glow(canvas, const Offset(314, 202), 250, _violet);
    _glow(canvas, const Offset(86, 474), 235, _ion);
    for (var i = 0; i < 7; i++) {
      canvas.drawLine(
        Offset(326 + i * 11, 70),
        Offset(326 + i * 11, 148),
        Paint()
          ..strokeWidth = .8
          ..color = const Color(0x246783a4),
      );
    }
    _text(
      canvas,
      'TEMPLATE / STUDIO',
      const Offset(46, 68),
      width: 260,
      size: 9,
      color: _muted,
      weight: FontWeight.bold,
      spacing: 1.5,
    );
    canvas.drawCircle(const Offset(320, 77), 3, Paint()..color = _ion);
    _mark(canvas, const Offset(94, 306), 72);
    _text(
      canvas,
      'A BETTER PLACE TO BEGIN',
      const Offset(46, 416),
      width: 298,
      size: 9,
      color: _ion,
      weight: FontWeight.bold,
      spacing: 1.2,
    );
    _text(
      canvas,
      'Ideas deserve\na clear start.',
      const Offset(46, 455),
      width: 310,
      size: 30,
      color: _ink,
      weight: FontWeight.bold,
      height: 1.12,
    );
    _text(
      canvas,
      'Opening your workspace',
      const Offset(46, 539),
      width: 300,
      size: 13,
      color: _muted,
    );
    _text(
      canvas,
      'INITIALIZING',
      const Offset(46, 656),
      width: 135,
      size: 9,
      color: _muted,
      weight: FontWeight.bold,
      spacing: 1.4,
    );
    final stage = progress < .56
        ? 1
        : progress < .72
        ? 2
        : progress < .9
        ? 3
        : 4;
    _text(
      canvas,
      '${stage.toString().padLeft(2, '0')} / 04',
      const Offset(295, 656),
      width: 50,
      size: 9,
      color: _muted,
      weight: FontWeight.bold,
      spacing: 1,
    );
    _progress(canvas, const Offset(46, 681), 298, progress, _ion);
    canvas.drawLine(
      const Offset(46, 735),
      const Offset(344, 735),
      Paint()
        ..strokeWidth = .7
        ..color = const Color(0x5070859f),
    );
    _text(
      canvas,
      'TEMPLATE',
      const Offset(46, 750),
      width: 150,
      size: 8,
      color: const Color(0xff8b9fb9),
      weight: FontWeight.bold,
      spacing: 1.5,
    );
    canvas.restore();
  }

  void _glow(Canvas canvas, Offset center, double radius, Color color) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 390, 844),
      Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: .23),
            color.withValues(alpha: .08),
            Colors.transparent,
          ],
          stops: const [0, .52, 1],
        ).createShader(rect),
    );
  }

  void _mark(Canvas canvas, Offset center, double size) {
    final rect = Rect.fromCenter(center: center, width: size, height: size);
    final tile = RRect.fromRectAndRadius(rect, Radius.circular(size * .24));
    canvas.drawRRect(tile, Paint()..color = const Color(0xff131d2d));
    canvas.drawRRect(
      tile,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = const Color(0xff35465c),
    );
    final block = size * .28;
    final gap = size * .08;
    final startX = center.dx - block - gap / 2;
    final startY = center.dy - block - gap / 2;
    const colors = [_coral, _ion, _violet, _mint];
    for (var i = 0; i < colors.length; i++) {
      final x = startX + (i % 2) * (block + gap);
      final y = startY + (i ~/ 2) * (block + gap);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, block, block),
          Radius.circular(block * .28),
        ),
        Paint()..color = colors[i],
      );
    }
  }

  void _progress(
    Canvas canvas,
    Offset origin,
    double width,
    double amount,
    Color color,
  ) {
    final trackRect = Rect.fromLTWH(origin.dx, origin.dy, width, 3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, const Radius.circular(2)),
      Paint()..color = Colors.white.withValues(alpha: .16),
    );
    final fill = Rect.fromLTWH(origin.dx, origin.dy, width * amount, 3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(fill, const Radius.circular(2)),
      Paint()
        ..shader = LinearGradient(colors: [color, _violet]).createShader(fill),
    );
    canvas.drawCircle(
      Offset(origin.dx + width * amount, origin.dy + 1.5),
      3,
      Paint()..color = Colors.white,
    );
  }

  void _text(
    Canvas canvas,
    String text,
    Offset origin, {
    required double width,
    required double size,
    required Color color,
    FontWeight weight = FontWeight.normal,
    double spacing = 0,
    double height = 1.2,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontFamily: 'Roboto',
          fontSize: size,
          fontWeight: weight,
          letterSpacing: spacing,
          height: height,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: width);
    painter.paint(canvas, origin);
  }

  @override
  bool shouldRepaint(covariant _FocusLoadingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
