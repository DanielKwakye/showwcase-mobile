import 'package:flutter/material.dart';

class ImageNotFoundWidget extends StatelessWidget {
  const ImageNotFoundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 15,),
        const Icon(Icons.info_outline),
        const SizedBox(width: 10,),
        Text('Image not found', style: TextStyle(color: theme.colorScheme.onBackground),)
      ],
    );
  }
}
