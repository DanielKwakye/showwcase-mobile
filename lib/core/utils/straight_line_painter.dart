import 'package:flutter/cupertino.dart';

class StraightLinePaint extends CustomPainter {

  final double startWidth;
  final double startHeight;
  final double endOffset;
  final double strokeWidth;
  final Color color;

  StraightLinePaint({
    this.startWidth = 0.5,
    this.startHeight = 0.0,
    this.endOffset = 0.0,
    this.strokeWidth = 1,
    required this.color
  });

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..color = color
      ..style = PaintingStyle.fill;

    final startPoint = Offset(size.width * (startWidth), startHeight);
    final endPoint = Offset(size.width * (startWidth), size.height - endOffset);
    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}