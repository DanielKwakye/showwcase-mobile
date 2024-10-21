import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';

class CustomNoConnectionWidget extends StatelessWidget {

  final String? title;
  final String? subTitle;
  final bool? showRetryButton ;
  final Function()? onRetry;
  const CustomNoConnectionWidget({
    this.title,
    this.subTitle,
    Key? key, this.showRetryButton = false, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Lottie.asset(kNoConnectionJson, errorBuilder: (ctx, r, s) {
          return const SizedBox.shrink();
        },height:  size.height / 2),
        const SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(title ?? 'Check your connection ...',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w800),),
        ),
        if(subTitle != null) ... {
          const SizedBox(height: 15,),
          Text(subTitle!,
            textAlign: TextAlign.left,
            style: TextStyle(color: theme.colorScheme.onPrimary),),
        },
        if(showRetryButton! ) ... {
          const SizedBox(height: 15,),
          CustomButtonWidget(
            text: 'Retry',
            onPressed: onRetry,
          ),

        }
      ],
    );
  }
}
