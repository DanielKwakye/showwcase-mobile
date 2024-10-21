import 'package:flutter/material.dart';

class HorizontalCurvedLinePainter extends CustomPainter {

  final Color color;
  HorizontalCurvedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..strokeWidth = 1
      ..color = color
      ..style = PaintingStyle.stroke;

    final startPoint = Offset(size.width * (0.0), size.height * 0.1);
    final midPoint = Offset(size.width * (0.5), size.height * 0.5);
    final endPoint = Offset(size.width, size.height / 2);

    final path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    // path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, endPoint.dx, endPoint.dy);
    // path.lineTo(midPoint.dx, midPoint.dy);
    path.arcToPoint(midPoint, radius: const Radius.circular(15), clockwise: false);
    path.lineTo(endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}