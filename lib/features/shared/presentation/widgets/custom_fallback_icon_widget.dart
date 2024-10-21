import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/functions.dart';

class CustomFallbackIconWidget extends StatelessWidget {

  final double? width;
  final double? height;
  final String name;

  const CustomFallbackIconWidget({Key? key, this.width, this.height, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: width ?? 40,
      height: height ?? 40,
      decoration: BoxDecoration(
        // border: Border.all(color: theme.colorScheme.outline),
        // borderRadius: BorderRadius.circular(5),
          color: theme.colorScheme.outline),
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.only(top: 0),
      child: Center(
          child: Text(
            getInitials(name.toUpperCase()),
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          )),

      // ,
    );
  }

}
