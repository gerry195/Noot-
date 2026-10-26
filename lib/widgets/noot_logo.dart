import 'package:flutter/material.dart';

/// Logo Noot: kertas dengan sudut terlipat dan huruf N.
class NootLogo extends StatelessWidget {
  const NootLogo({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _NootLogoPainter()),
    );
  }
}

class _NootLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    Offset p(double x, double y) => Offset(x * s, y * s);

    final latar = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(s * 0.26),
    );
    canvas.drawRRect(
      latar,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B8CFF), Color(0xFF1448C9)],
        ).createShader(Offset.zero & size),
    );

    final kertas = Path()
      ..moveTo(p(0.30, 0.22).dx, p(0.30, 0.22).dy)
      ..lineTo(p(0.56, 0.22).dx, p(0.56, 0.22).dy)
      ..lineTo(p(0.72, 0.38).dx, p(0.72, 0.38).dy)
      ..lineTo(p(0.72, 0.78).dx, p(0.72, 0.78).dy)
      ..lineTo(p(0.30, 0.78).dx, p(0.30, 0.78).dy)
      ..close();
    final putih = Paint()..color = Colors.white;
    final tepiPutih = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.04
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(kertas, putih);
    canvas.drawPath(kertas, tepiPutih);

    final lipatan = Path()
      ..moveTo(p(0.56, 0.22).dx, p(0.56, 0.22).dy)
      ..lineTo(p(0.56, 0.38).dx, p(0.56, 0.38).dy)
      ..lineTo(p(0.72, 0.38).dx, p(0.72, 0.38).dy)
      ..close();
    canvas.drawPath(lipatan, Paint()..color = const Color(0xFFBFD6FF));
    canvas.drawPath(
      lipatan,
      Paint()
        ..color = const Color(0xFFBFD6FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.02
        ..strokeJoin = StrokeJoin.round,
    );

    final huruf = Path()
      ..moveTo(p(0.40, 0.68).dx, p(0.40, 0.68).dy)
      ..lineTo(p(0.40, 0.47).dx, p(0.40, 0.47).dy)
      ..lineTo(p(0.62, 0.68).dx, p(0.62, 0.68).dy)
      ..lineTo(p(0.62, 0.47).dx, p(0.62, 0.47).dy);
    canvas.drawPath(
      huruf,
      Paint()
        ..color = const Color(0xFF1F6FEB)
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.06
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
