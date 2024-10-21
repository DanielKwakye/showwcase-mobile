import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/network/api_config.dart';

class CustomTermsPrivacyWidget extends StatelessWidget{

  final Function()? onTap;
  const CustomTermsPrivacyWidget({this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap ?? () => _onReadTermsAndConditionsTapped(context),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'By clicking ',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimary.withOpacity(0.7,)) ,
          children: const <TextSpan>[
            TextSpan(text: '“Continue with Github/Email/Gmail/Apple” above, you acknowledge that you have read and understood, and agree to Showwcase’s '),
            TextSpan(text: 'Terms of Use ',style: TextStyle(
              decoration: TextDecoration.underline,
            ),),
            TextSpan(text: 'and '),
            TextSpan(text: 'Privacy policy', style: TextStyle(
              decoration: TextDecoration.underline,
            ),)
            // TextSpan(text: 'Continue', style: TextStyle(fontWeight: FontWeight.bold, color: kAppBlue)),
          ],
        ),
      ),
    );
  }


  /// when read terms and conditions tapped
  void _onReadTermsAndConditionsTapped(BuildContext context){
    context.push(browserPage, extra: ApiConfig.aboutUrl);
  }
}
