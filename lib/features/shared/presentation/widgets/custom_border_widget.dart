import 'package:flutter/material.dart';


class CustomBorderWidget extends StatelessWidget {
  final String? centerText;
  final Color? color;
  final double top;
  final double bottom;
  final double left;
  final double right;
  final double height;
  const CustomBorderWidget({
    this.color,
    this.centerText,
    this.top = 0.0,
    this.bottom = 0.0,
    this.left = 0.0,
    this.right = 0.0,
    Key? key,  this.height = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding:  EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
      child: Row(
        children: [
          Expanded(child: Container(
            color: color ?? theme.colorScheme.outline,
            height: height,
          )),
          if(centerText != null) ...{
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(centerText!, style: TextStyle(color: color ?? theme.colorScheme.onPrimary),),
            )
          },
          Expanded(child: Container(
            color: color ?? Theme.of(context).colorScheme.outline,
            height: height,
          ))
        ],
      ),
    );
  }
}
