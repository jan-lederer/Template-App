import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _ink = Color(0xffe7eff8);
const _muted = Color(0xff99acc2);
const _ion = Color(0xff19b8aa);
const _violet = Color(0xff8d78f6);
const _coral = Color(0xffe77860);
const _mint = Color(0xff2c9b76);
const _midnight = Color(0xff090e19);

Future<void> _loadRoboto() async {
  final loader = FontLoader('Roboto');
  for (final name in ['Roboto-Regular.ttf', 'Roboto-Bold.ttf']) {
    final bytes = await File('test/fonts/$name').readAsBytes();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

Future<Uint8List> _capture(int option) async {
  const size = Size(390, 844);
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 780, 1688));
  canvas.scale(2);
  _LoadingScreenPainter(option).paint(canvas, size);
  final image = await recorder.endRecording().toImage(780, 1688);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return data!.buffer.asUint8List();
}

void main() {
  testWidgets('renders eight loading screen concepts for selection', (
    tester,
  ) async {
    final output = Directory('screenshots/loading-options')
      ..createSync(recursive: true);
    const names = [
      'loading-option-01-orbital.png',
      'loading-option-02-horizon.png',
      'loading-option-03-focus.png',
      'loading-option-04-glass.png',
      'loading-option-05-beacon.png',
      'loading-option-06-daylight.png',
      'loading-option-07-signal.png',
      'loading-option-08-flux.png',
    ];
    final generated = await tester.runAsync(() async {
      await _loadRoboto();
      final rendered = <Uint8List>[];
      for (var option = 0; option < names.length; option++) {
        final bytes = await _capture(option);
        expect(bytes.length, greaterThan(10000));
        File('${output.path}/${names[option]}')
            .writeAsBytesSync(bytes, flush: true);
        rendered.add(bytes);
      }
      final firstOverview = _overview(0);
      final firstOverviewBytes = await firstOverview.toByteData(
        format: ui.ImageByteFormat.png,
      );
      File(
        '${output.path}/loading-options-overview.png',
      ).writeAsBytesSync(firstOverviewBytes!.buffer.asUint8List(), flush: true);
      firstOverview.dispose();
      final newOverview = _overview(4);
      final newOverviewBytes = await newOverview.toByteData(
        format: ui.ImageByteFormat.png,
      );
      File(
        '${output.path}/loading-options-overview-05-08.png',
      ).writeAsBytesSync(newOverviewBytes!.buffer.asUint8List(), flush: true);
      newOverview.dispose();
      return rendered;
    });
    expect(generated, hasLength(8));
  });
}

ui.Image _overview(int start) {
  const width = 920.0;
  const height = 1660.0;
  const thumbWidth = 330.0;
  const thumbHeight = 715.0;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, width, height));
  canvas.drawRect(
    const Rect.fromLTWH(0, 0, width, height),
    Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [_midnight, Color(0xff111b2b)],
      ).createShader(const Rect.fromLTWH(0, 0, width, height)),
  );
  _paintText(
    canvas,
    start == 0 ? 'Loading screen concepts' : 'More loading screen concepts',
    const Offset(52, 34),
    width: 816,
    size: 30,
    color: _ink,
    weight: FontWeight.bold,
  );
  _paintText(
    canvas,
    start == 0
        ? 'Pick a direction; the current splash stays as is.'
        : 'Four fresh directions. The active splash is unchanged.',
    const Offset(54, 76),
    width: 816,
    size: 17,
    color: _muted,
  );

  const xs = [54.0, 514.0, 54.0, 514.0];
  const ys = [128.0, 128.0, 876.0, 876.0];
  const labels = [
    'ORBITAL',
    'HORIZON',
    'FOCUS',
    'GLASS',
    'BEACON',
    'DAYLIGHT',
    'SIGNAL',
    'FLUX',
  ];
  for (var i = 0; i < 4; i++) {
    final destination = Rect.fromLTWH(xs[i], ys[i], thumbWidth, thumbHeight);
    final frame = RRect.fromRectAndRadius(
      destination.inflate(3),
      const Radius.circular(15),
    );
    canvas.drawRRect(frame, Paint()..color = const Color(0x3dffffff));
    canvas.save();
    canvas.clipRect(destination);
    canvas.translate(xs[i], ys[i]);
    canvas.scale(thumbWidth / 390, thumbHeight / 844);
    _LoadingScreenPainter(start + i).paint(canvas, const Size(390, 844));
    canvas.restore();
    _paintText(
      canvas,
      '${start + i + 1 < 10 ? '0' : ''}${start + i + 1}  ${labels[start + i]}',
      Offset(xs[i], ys[i] + thumbHeight + 13),
      width: thumbWidth,
      size: 17,
      color: _ink,
      weight: FontWeight.bold,
    );
  }
  return recorder.endRecording().toImageSync(width.toInt(), height.toInt());
}

class _LoadingScreenPainter extends CustomPainter {
  const _LoadingScreenPainter(this.option);
  final int option;

  @override
  void paint(Canvas canvas, Size size) {
    switch (option) {
      case 0:
        _orbital(canvas, size);
      case 1:
        _horizon(canvas, size);
      case 2:
        _focus(canvas, size);
      case 3:
        _glass(canvas, size);
      case 4:
        _beacon(canvas, size);
      case 5:
        _daylight(canvas, size);
      case 6:
        _signal(canvas, size);
      default:
        _flux(canvas, size);
    }
  }

  void _background(Canvas canvas, Size size, List<Color> colors) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ).createShader(rect),
    );
  }

  void _glow(Canvas canvas, Offset center, double radius, Color color) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawRect(
      Offset.zero & const Size(390, 844),
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

  void _mark(Canvas canvas, Offset center, double size, {bool light = false}) {
    final rect = Rect.fromCenter(center: center, width: size, height: size);
    final tile = RRect.fromRectAndRadius(rect, Radius.circular(size * .24));
    canvas.drawRRect(
      tile,
      Paint()
        ..color = light
            ? Colors.white.withValues(alpha: .88)
            : const Color(0xff131d2d),
    );
    canvas.drawRRect(
      tile,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = light ? const Color(0xffd4e0ee) : const Color(0xff35465c),
    );
    final block = size * .28;
    final gap = size * .08;
    final startX = center.dx - block - gap / 2;
    final startY = center.dy - block - gap / 2;
    final colors = [_coral, _ion, _violet, _mint];
    for (var i = 0; i < 4; i++) {
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
    final track = RRect.fromRectAndRadius(
      Rect.fromLTWH(origin.dx, origin.dy, width, 3),
      const Radius.circular(2),
    );
    canvas.drawRRect(
      track,
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
    TextAlign align = TextAlign.left,
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
      textAlign: align,
    )..layout(maxWidth: width);
    painter.paint(canvas, origin);
  }

  void _orbital(Canvas canvas, Size size) {
    _background(canvas, size, const [Color(0xff080d18), Color(0xff0d1727)]);
    _glow(canvas, const Offset(195, 344), 235, _ion);
    _glow(canvas, const Offset(282, 390), 185, _violet);
    final dot = Paint()..color = const Color(0x14c9d9eb);
    for (var x = 28.0; x < size.width; x += 26) {
      for (var y = 62.0; y < size.height; y += 26) {
        canvas.drawCircle(Offset(x, y), .7, dot);
      }
    }
    final ring = Rect.fromCircle(center: const Offset(195, 344), radius: 69);
    canvas.drawCircle(
      ring.center,
      ring.width / 2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = const Color(0x669eadd0),
    );
    canvas.drawCircle(const Offset(260, 323), 3.5, Paint()..color = _ion);
    canvas.drawCircle(const Offset(133, 373), 3, Paint()..color = _violet);
    _mark(canvas, const Offset(195, 344), 90);
    _text(
      canvas,
      'template',
      const Offset(36, 442),
      width: 318,
      size: 29,
      color: _ink,
      weight: FontWeight.bold,
      align: TextAlign.center,
    );
    _text(
      canvas,
      'A calm, capable start for your next app.',
      const Offset(22, 477),
      width: 346,
      size: 12,
      color: _muted,
      align: TextAlign.center,
    );
    _text(
      canvas,
      'PREPARING YOUR WORKSPACE',
      const Offset(24, 633),
      width: 342,
      size: 9,
      color: const Color(0xffa4bbcf),
      weight: FontWeight.bold,
      align: TextAlign.center,
      spacing: 1.5,
    );
    _progress(canvas, const Offset(123, 656), 144, .58, _ion);
  }

  void _horizon(Canvas canvas, Size size) {
    _background(canvas, size, const [Color(0xfffbfdff), Color(0xfff3f6fa)]);
    _glow(canvas, const Offset(195, 278), 250, const Color(0xff5aaee0));
    _glow(canvas, const Offset(242, 344), 175, _violet);
    final rings = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .8
      ..color = const Color(0x26365068);
    for (var radius = 92.0; radius < 220; radius += 32) {
      canvas.drawCircle(const Offset(195, 280), radius, rings);
    }
    _mark(canvas, const Offset(195, 280), 88, light: true);
    _text(
      canvas,
      'template',
      const Offset(30, 394),
      width: 330,
      size: 29,
      color: const Color(0xff0e1b2c),
      weight: FontWeight.bold,
      align: TextAlign.center,
    );
    _text(
      canvas,
      'A calm, capable start for your next app.',
      const Offset(22, 429),
      width: 346,
      size: 12,
      color: const Color(0xff54677d),
      align: TextAlign.center,
    );
    _text(
      canvas,
      'SETTING UP YOUR SPACE',
      const Offset(30, 588),
      width: 330,
      size: 9,
      color: const Color(0xff566e89),
      weight: FontWeight.bold,
      align: TextAlign.center,
      spacing: 1.5,
    );
    final track = RRect.fromRectAndRadius(
      const Rect.fromLTWH(95, 606, 200, 3),
      const Radius.circular(2),
    );
    canvas.drawRRect(track, Paint()..color = const Color(0xffa0b1c4));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(95, 606, 120, 3),
        const Radius.circular(2),
      ),
      Paint()
        ..shader = const LinearGradient(colors: [_ion, _violet])
            .createShader(const Rect.fromLTWH(95, 606, 120, 3)),
    );
    canvas.drawCircle(const Offset(215, 607.5), 3, Paint()..color = _ion);
    _text(
      canvas,
      'One moment while we get things ready',
      const Offset(25, 632),
      width: 340,
      size: 11,
      color: const Color(0xff697b91),
      align: TextAlign.center,
    );
  }

  void _focus(Canvas canvas, Size size) {
    _background(canvas, size, const [Color(0xff080d18), Color(0xff0d1625)]);
    _glow(canvas, const Offset(314, 202), 250, _violet);
    _glow(canvas, const Offset(86, 474), 235, _ion);
    for (var i = 0; i < 7; i++) {
      final paint = Paint()
        ..strokeWidth = .8
        ..color = const Color(0x246783a4);
      canvas.drawLine(
        Offset(326 + i * 11, 70),
        Offset(326 + i * 11, 148),
        paint,
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
    _text(
      canvas,
      '01 / 04',
      const Offset(295, 656),
      width: 50,
      size: 9,
      color: _muted,
      weight: FontWeight.bold,
      spacing: 1,
    );
    _progress(canvas, const Offset(46, 681), 298, .42, _ion);
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
  }

  void _glass(Canvas canvas, Size size) {
    _background(canvas, size, const [Color(0xff070c18), Color(0xff0d1224)]);
    _glow(canvas, const Offset(198, 345), 250, _violet);
    _glow(canvas, const Offset(234, 385), 195, _ion);
    final panel = RRect.fromRectAndRadius(
      const Rect.fromLTWH(54, 219, 282, 365),
      const Radius.circular(22),
    );
    canvas.drawRRect(
      panel,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xe6202f49), Color(0xd811192b)],
        ).createShader(const Rect.fromLTWH(54, 219, 282, 365)),
    );
    canvas.drawRRect(
      panel,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = const Color(0x3dffffff),
    );
    final arcRect = Rect.fromCircle(center: const Offset(195, 315), radius: 58);
    canvas.drawCircle(
      arcRect.center,
      arcRect.width / 2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = const Color(0x558d78f6),
    );
    canvas.drawArc(
      arcRect,
      -.5,
      2.2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = _ion,
    );
    _mark(canvas, const Offset(195, 315), 76);
    _text(
      canvas,
      'template',
      const Offset(65, 411),
      width: 260,
      size: 25,
      color: _ink,
      weight: FontWeight.bold,
      align: TextAlign.center,
    );
    _text(
      canvas,
      'Getting things ready',
      const Offset(65, 448),
      width: 260,
      size: 12,
      color: _muted,
      align: TextAlign.center,
    );
    for (var i = -1; i <= 1; i++) {
      canvas.drawCircle(
        Offset(195 + i * 12, 496),
        2.5,
        Paint()..color = i == 0 ? _ion : Colors.white.withValues(alpha: .28),
      );
    }
    _text(
      canvas,
      'LOADING',
      const Offset(90, 535),
      width: 210,
      size: 8,
      color: const Color(0xffa0b5cd),
      weight: FontWeight.bold,
      align: TextAlign.center,
      spacing: 2,
    );
    _text(
      canvas,
      'Your next idea is close.',
      const Offset(28, 690),
      width: 334,
      size: 11,
      color: const Color(0xff8eA0ba),
      align: TextAlign.center,
    );
  }

  void _beacon(Canvas canvas, Size size) {
    _background(canvas, size, const [Color(0xff0a0e1c), Color(0xff12132a)]);
    _glow(canvas, const Offset(195, 335), 235, _violet);
    _glow(canvas, const Offset(195, 335), 165, _ion);
    for (var i = 0; i < 12; i++) {
      final angle = i * 3.14159 / 6;
      final inner = Offset(
        195 + 87 * math.cos(angle),
        335 + 87 * math.sin(angle),
      );
      final outer = Offset(
        195 + 101 * math.cos(angle),
        335 + 101 * math.sin(angle),
      );
      canvas.drawLine(
        inner,
        outer,
        Paint()
          ..strokeWidth = i % 3 == 0 ? 1.5 : .7
          ..color = i % 3 == 0
              ? const Color(0x7291a2c4)
              : const Color(0x387b8aa9),
      );
    }
    final ring = Rect.fromCircle(center: const Offset(195, 335), radius: 75);
    canvas.drawCircle(
      ring.center,
      ring.width / 2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0x3dffffff),
    );
    canvas.drawArc(
      ring,
      -1.5708,
      4.1,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..shader = const SweepGradient(colors: [_ion, _violet, _coral])
            .createShader(ring),
    );
    canvas.drawCircle(const Offset(246, 279), 4, Paint()..color = _coral);
    _mark(canvas, const Offset(195, 335), 80);
    _text(
      canvas,
      'template',
      const Offset(35, 443),
      width: 320,
      size: 27,
      color: _ink,
      weight: FontWeight.bold,
      align: TextAlign.center,
    );
    _text(
      canvas,
      'Bringing your workspace online',
      const Offset(24, 480),
      width: 342,
      size: 12,
      color: _muted,
      align: TextAlign.center,
    );
    _text(
      canvas,
      'CALIBRATING YOUR SPACE',
      const Offset(25, 634),
      width: 340,
      size: 9,
      color: const Color(0xffb1b2d0),
      weight: FontWeight.bold,
      align: TextAlign.center,
      spacing: 1.4,
    );
    _progress(canvas, const Offset(95, 660), 200, .72, _violet);
  }

  void _daylight(Canvas canvas, Size size) {
    _background(canvas, size, const [Color(0xfffbfaf8), Color(0xfff4f2ee)]);
    _glow(canvas, const Offset(287, 480), 205, _coral);
    _glow(canvas, const Offset(310, 530), 175, _ion);
    _mark(canvas, const Offset(70, 79), 44, light: true);
    _text(
      canvas,
      'template',
      const Offset(104, 64),
      width: 150,
      size: 18,
      color: const Color(0xff172435),
      weight: FontWeight.bold,
    );
    _text(
      canvas,
      'A THOUGHTFUL START',
      const Offset(46, 270),
      width: 270,
      size: 9,
      color: const Color(0xffb15c49),
      weight: FontWeight.bold,
      spacing: 1.4,
    );
    _text(
      canvas,
      'A thoughtful\nspace is almost\nready.',
      const Offset(46, 300),
      width: 302,
      size: 31,
      color: const Color(0xff142236),
      weight: FontWeight.bold,
      height: 1.12,
    );
    final horizonPaint = Paint()
      ..shader = const LinearGradient(colors: [Color(0x00e77860), _coral, _ion])
          .createShader(const Rect.fromLTWH(46, 476, 298, 1));
    canvas.drawLine(
      const Offset(46, 476),
      const Offset(344, 476),
      horizonPaint..strokeWidth = 1.4,
    );
    canvas.drawCircle(
      const Offset(288, 476),
      29,
      Paint()..color = const Color(0x55e77860),
    );
    canvas.drawCircle(
      const Offset(288, 476),
      21,
      Paint()
        ..shader =
            const RadialGradient(colors: [Color(0xffffd5be), Color(0x00e77860)])
                .createShader(
                  Rect.fromCircle(center: const Offset(288, 476), radius: 21),
                ),
    );
    _text(
      canvas,
      'Preparing your workspace',
      const Offset(46, 546),
      width: 298,
      size: 13,
      color: const Color(0xff52657c),
    );
    _text(
      canvas,
      'STARTING UP',
      const Offset(46, 660),
      width: 150,
      size: 9,
      color: const Color(0xff7a6a68),
      weight: FontWeight.bold,
      spacing: 1.4,
    );
    _progress(canvas, const Offset(46, 686), 298, .64, _coral);
    _text(
      canvas,
      'A calm, capable start for your next app.',
      const Offset(46, 714),
      width: 298,
      size: 11,
      color: const Color(0xff687a8d),
    );
  }

  void _signal(Canvas canvas, Size size) {
    _background(canvas, size, const [Color(0xff07101b), Color(0xff0a1925)]);
    _glow(canvas, const Offset(195, 315), 250, _ion);
    for (var y = 60.0; y < size.height; y += 28) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        Paint()
          ..strokeWidth = .5
          ..color = const Color(0x0d8ed4da),
      );
    }
    _text(
      canvas,
      'TEMPLATE  /  SIGNAL',
      const Offset(30, 70),
      width: 330,
      size: 9,
      color: const Color(0xff9ab6c3),
      weight: FontWeight.bold,
      align: TextAlign.center,
      spacing: 1.8,
    );
    final scan = const Rect.fromLTWH(24, 300, 342, 1);
    canvas.drawRect(
      scan,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0x0019b8aa), Color(0xff19b8aa), Color(0x0019b8aa)],
        ).createShader(scan),
    );
    canvas.drawCircle(const Offset(195, 300), 4, Paint()..color = _ion);
    _mark(canvas, const Offset(195, 300), 76);
    _text(
      canvas,
      'template',
      const Offset(35, 400),
      width: 320,
      size: 27,
      color: _ink,
      weight: FontWeight.bold,
      align: TextAlign.center,
    );
    _text(
      canvas,
      'Bringing your workspace online',
      const Offset(24, 438),
      width: 342,
      size: 12,
      color: _muted,
      align: TextAlign.center,
    );
    _text(
      canvas,
      'CONNECTING',
      const Offset(24, 654),
      width: 342,
      size: 9,
      color: const Color(0xffa7c7ce),
      weight: FontWeight.bold,
      align: TextAlign.center,
      spacing: 1.8,
    );
    for (var i = 0; i < 6; i++) {
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(104 + i * 32, 682, 22, 4),
        const Radius.circular(3),
      );
      canvas.drawRRect(
        rect,
        Paint()
          ..color = i < 3
              ? (i == 2 ? _ion : const Color(0xff388d92))
              : const Color(0x3dffffff),
      );
    }
  }

  void _flux(Canvas canvas, Size size) {
    _background(canvas, size, const [Color(0xff0b0d1b), Color(0xff111327)]);
    _glow(canvas, const Offset(196, 330), 250, _violet);
    _glow(canvas, const Offset(242, 405), 180, _coral);
    final layers = [
      (Rect.fromLTWH(103, 265, 184, 150), const Color(0x3d8d78f6)),
      (Rect.fromLTWH(91, 250, 196, 150), const Color(0x3d19b8aa)),
      (Rect.fromLTWH(103, 236, 184, 150), const Color(0xd51a2235)),
    ];
    for (var i = 0; i < layers.length; i++) {
      final rect = layers[i].$1;
      final shape = RRect.fromRectAndRadius(rect, const Radius.circular(25));
      canvas.drawRRect(shape, Paint()..color = layers[i].$2);
      canvas.drawRRect(
        shape,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = i == 2 ? const Color(0x607c8ca8) : const Color(0x338d9fbe),
      );
    }
    _mark(canvas, const Offset(195, 311), 74);
    _text(
      canvas,
      'template',
      const Offset(35, 423),
      width: 320,
      size: 27,
      color: _ink,
      weight: FontWeight.bold,
      align: TextAlign.center,
    );
    _text(
      canvas,
      'Making room for your next idea',
      const Offset(24, 461),
      width: 342,
      size: 12,
      color: _muted,
      align: TextAlign.center,
    );
    for (var i = 0; i < 3; i++) {
      final x = 105 + i * 90;
      canvas.drawCircle(
        Offset(x.toDouble(), 550),
        5,
        Paint()
          ..color = i < 2 ? (i == 1 ? _violet : _ion) : const Color(0x5dffffff),
      );
      if (i < 2) {
        canvas.drawLine(
          Offset(x + 6, 550),
          Offset(x + 84, 550),
          Paint()
            ..strokeWidth = 1
            ..color = const Color(0x558d9aaf),
        );
      }
    }
    _text(
      canvas,
      'COLLECT  •  SHAPE  •  BEGIN',
      const Offset(24, 575),
      width: 342,
      size: 8,
      color: const Color(0xffa7abc2),
      weight: FontWeight.bold,
      align: TextAlign.center,
      spacing: 1.2,
    );
    _text(
      canvas,
      'PREPARING YOUR SPACE',
      const Offset(24, 666),
      width: 342,
      size: 9,
      color: const Color(0xffb8b4d2),
      weight: FontWeight.bold,
      align: TextAlign.center,
      spacing: 1.4,
    );
    _progress(canvas, const Offset(95, 691), 200, .76, _violet);
  }

  @override
  bool shouldRepaint(covariant _LoadingScreenPainter oldDelegate) =>
      oldDelegate.option != option;
}

void _paintText(
  Canvas canvas,
  String text,
  Offset origin, {
  required double width,
  required double size,
  required Color color,
  FontWeight weight = FontWeight.normal,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: size,
        fontWeight: weight,
        color: color,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: width);
  painter.paint(canvas, origin);
}
