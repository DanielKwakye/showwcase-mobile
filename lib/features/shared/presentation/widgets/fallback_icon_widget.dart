import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/functions.dart';

class FallBackIconWidget extends StatelessWidget {

  final String name;
  final double size;

  const FallBackIconWidget({
    required this.name,
    this.size = 40,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // border: Border.all(color: theme.colorScheme.outline),
        // borderRadius: BorderRadius.circular(5),
          color: theme.colorScheme.outline
      ),
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.only(top: 0),
      child: Center(child: Text(getInitials(name.toUpperCase()), style: TextStyle(color: Theme.of(context).colorScheme.onBackground),)),

      // ,
    );
  }
}
