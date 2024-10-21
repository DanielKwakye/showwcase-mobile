import 'dart:ui';

import 'package:flutter/material.dart';

class IOSBottomNavigationStyleWrapper extends StatelessWidget {

  final Widget bottomNavigation;
  const IOSBottomNavigationStyleWrapper({Key? key, required this.bottomNavigation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      //I'm using BackdropFilter for the blurring effect
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 5.0,
        ),
        child: bottomNavigation,
      ),
    );
  }
}
