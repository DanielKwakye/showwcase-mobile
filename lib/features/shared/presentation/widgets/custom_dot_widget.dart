import 'package:flutter/material.dart';

class CustomDotWidget extends StatelessWidget {

  final Color? color;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;
  const CustomDotWidget({
    this.color,
    this.leftPadding = 0.0,
    this.rightPadding = 0.0,
    this.topPadding = 0.0,
    this.bottomPadding = 0.0,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding:  EdgeInsets.only(left: leftPadding, right: rightPadding, top: topPadding, bottom: bottomPadding),
      child: Container(
        width: 3, height: 3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: color ?? theme.colorScheme.onPrimary
        ),
      ),
    );
  }
}
