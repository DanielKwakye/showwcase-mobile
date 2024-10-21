import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/theme.dart';

class CustomCircularLoader extends StatelessWidget {
  final double size;
  const CustomCircularLoader({Key? key, this.size = 20}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: size,
      height: size,
      child: Platform.isIOS ? const CupertinoActivityIndicator() :
      const CircularProgressIndicator(color: kAppBlue, strokeWidth: 2, ),);

  }
}
