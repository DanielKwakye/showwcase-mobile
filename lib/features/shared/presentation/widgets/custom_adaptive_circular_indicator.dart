import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/theme.dart';

class CustomAdaptiveCircularIndicator extends StatelessWidget {
  const CustomAdaptiveCircularIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Platform.isIOS
        ? CupertinoActivityIndicator(color: theme.colorScheme.onBackground,)
        : const SizedBox(
          width: 20, height: 20,
          child: CircularProgressIndicator(color: kAppBlue, strokeWidth: 2),
        );
  }
}
