import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/theme.dart';

class CustomPlayIcon extends StatelessWidget {

  final double border;
  final double? iconSize;
  const CustomPlayIcon({
    this.border = 4,
    this.iconSize,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            border: Border.all(color: kAppWhite, width: border),
            borderRadius: BorderRadius.circular(100),
            color: kAppBlue
        ),
        child: Center(child: Icon(Icons.play_arrow, color: kAppWhite, size: iconSize,),),
      ),
    );
  }
}
