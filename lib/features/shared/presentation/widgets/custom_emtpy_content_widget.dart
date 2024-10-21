import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:showwcase_v3/core/utils/constants.dart';

class CustomEmptyContentWidget extends StatelessWidget {

  final String? title;
  final String? subTitle;
  const CustomEmptyContentWidget({
    this.title,
    this.subTitle,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Lottie.asset(kEmptyContentJson, errorBuilder: (ctx, r, s) {
          return const SizedBox.shrink();
        },),
        const SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(title ?? 'The place looks empty...',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w800),),
        ),
        if(subTitle != null) ... {
          const SizedBox(height: 10,),
          Text(subTitle!,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.onPrimary),),
        }
      ],
    );
  }
}
