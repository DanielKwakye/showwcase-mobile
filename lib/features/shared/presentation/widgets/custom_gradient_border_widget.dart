import 'package:flutter/material.dart';

class CustomGradientBorderWidget extends StatelessWidget {

  CustomGradientBorderWidget({Key? key,
    required this.gradient,
    required this.child,
    this.strokeWidth = 4,
    this.borderRadius = 64,
    this.padding = 16

  }) : painter = GradientPainter(
      gradient: gradient, strokeWidth: strokeWidth, borderRadius: borderRadius
  ), super(key: key);

  final GradientPainter painter;
  final Widget child;
  final double strokeWidth;
  final Gradient gradient;
  final double borderRadius;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: painter,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: child,
        )
    );
  }
}

class GradientPainter extends CustomPainter {
  final Gradient gradient;
  final double strokeWidth;
  final double borderRadius;
  final Paint paintObject = Paint();
  GradientPainter({required this.gradient, required this.strokeWidth, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    Rect innerRect = Rect.fromLTRB(strokeWidth, strokeWidth, size.width - strokeWidth, size.height - strokeWidth);
    RRect innerRoundedRect = RRect.fromRectAndRadius(innerRect, Radius.circular(borderRadius));
    Rect outerRect = Offset.zero & size;
    RRect outerRoundedRect = RRect.fromRectAndRadius(outerRect, Radius.circular(borderRadius));
    paintObject.shader = gradient.createShader(outerRect);
    Path borderPath = _calculateBorderPath(outerRoundedRect, innerRoundedRect);
    canvas.drawPath(borderPath, paintObject);
  }
  Path _calculateBorderPath(RRect outerRRect, RRect innerRRect) {
    Path outerRectPath = Path()..addRRect(outerRRect);
    Path innerRectPath = Path()..addRRect(innerRRect);
    return Path.combine(PathOperation.difference, outerRectPath, innerRectPath);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}