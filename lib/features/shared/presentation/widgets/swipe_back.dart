import 'package:flutter/material.dart';

class SwipeBack extends StatelessWidget {
  final Widget child ;
  const SwipeBack({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
    // return GestureDetector(
    //   onHorizontalDragUpdate: (details) {
    //     // Note: Sensitivity is integer used when you don't want to mess up vertical drag
    //     int sensitivity = 8;
    //     if (details.delta.dx > sensitivity) {
    //       // Right Swipe
    //       Navigator.of(context).pop();
    //
    //     } else if (details.delta.dx < -sensitivity) {
    //       //Left Swipe
    //
    //     }
    //   },
    //   child: child,
    // );
  }
}


