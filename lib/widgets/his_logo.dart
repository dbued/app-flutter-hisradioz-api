import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class HisLogo extends StatelessWidget {
  final double size;
  const HisLogo({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: ZLogoPainter()),
    );
  }
}

class HisLogoCircle extends StatelessWidget {
  final double size;
  const HisLogoCircle({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: ClipOval(child: CustomPaint(painter: ZLogoPainter())),
    );
  }
}

class ZLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRect(Offset.zero & size, Paint()..color = kBlack);

    final rnd = math.Random(7);
    const xl = .08, xr = .92, y1 = .13, y2 = .40, y3 = .60, y4 = .87;
    const amp = .030;

    List<Offset> jag(Offset a, Offset b, int n, double mult) {
      final dx = b.dx - a.dx;
      final dy = b.dy - a.dy;
      final len = math.sqrt(dx * dx + dy * dy);
      final ux = -dy / len;
      final uy = dx / len;
      return List.generate(n + 1, (i) {
        final t = i / n;
        final off = (rnd.nextDouble() * 2 - 1) * amp * h * mult;
        return Offset.lerp(a, b, t)! + Offset(ux * off, uy * off);
      });
    }

    Offset P(double x, double y) => Offset(w * x, h * y);

    final segments = <List<Offset>>[
      jag(P(xl, y1), P(xr, y1), 10, 1.0),
      jag(P(xr, y1), P(xr, y2), 8, .8),
      jag(P(xr, y2), P(xl, y3), 16, 1.0),
      jag(P(xl, y3), P(xl, y4), 8, .8),
      jag(P(xl, y4), P(xr, y4), 10, 1.0),
      jag(P(xr, y4), P(xr, y3), 8, .8),
      jag(P(xr, y3), P(xl, y2), 16, .6),
      jag(P(xl, y2), P(xl, y1), 8, .6),
    ];

    final path = Path();
    var first = true;
    for (final seg in segments) {
      for (final p in seg) {
        if (first) {
          path.moveTo(p.dx, p.dy);
          first = false;
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = kYellow);

    _drawWordmark(canvas, size);
  }

  void _drawWordmark(Canvas canvas, Size size) {
    final fs = size.width * 0.105;
    final base = TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: fs,
      height: 1.0,
      letterSpacing: fs * 0.01,
    );

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = fs * 0.16
      ..color = kYellow;

    final ts = TextSpan(text: 'HIS radio', style: base.copyWith(foreground: stroke));
    final tf = TextSpan(text: 'HIS radio', style: base.copyWith(color: kBlack));

    final ps = TextPainter(
      text: ts,
      textDirection: TextDirection.ltr,
      textScaler: TextScaler.noScaling,
    )..layout();
    final pf = TextPainter(
      text: tf,
      textDirection: TextDirection.ltr,
      textScaler: TextScaler.noScaling,
    )..layout();

    final top = size.height * 0.41;
    final left = (size.width - pf.width) / 2;
    ps.paint(canvas, Offset(left, top));
    pf.paint(canvas, Offset(left, top));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
