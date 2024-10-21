import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomVideoLoadingWidget extends StatelessWidget {
  const CustomVideoLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(0),
            border: Border.all(color: theme.colorScheme.outline)
        ),
        child: const Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}
