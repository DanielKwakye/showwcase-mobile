import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showwcase_v3/core/mix/form_mixin.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';


class AuthOptionsForm extends StatefulWidget {

  final Function() onContinueWithGithubTapped;
  final Function() onContinueWithGmailTapped;
  final Function() onContinueWithAppleTapped;
  final Function(String email) onContinueWithEmailTapped;

  const AuthOptionsForm({Key? key,
    required this.onContinueWithGithubTapped,
    required this.onContinueWithGmailTapped,
    required this.onContinueWithAppleTapped,
    required this.onContinueWithEmailTapped,
  }) : super(key: key);

  @override
  AuthOptionsFormController createState() => AuthOptionsFormController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _AuthOptionsFormView extends WidgetView<AuthOptionsForm, AuthOptionsFormController> {

  const _AuthOptionsFormView(AuthOptionsFormController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return AnimationConfiguration.synchronized(
      child: SlideAnimation(
        duration: const Duration(milliseconds: 800),
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Column(
              children: [
                CustomButtonWidget(
                  backgroundColor: theme.brightness == Brightness.dark ? const Color(0xff202021) : const Color(0xffF7F7F7),
                  text: 'Continue with Github', // make sure its 20 character long so it aligns
                  icon: SizedBox(width: 15, child: Image.asset(kGithubIcon, color: theme.colorScheme.onBackground,)),
                  expand: true, appearance: Appearance.clean,

                  onPressed: widget.onContinueWithGithubTapped,
                ),
                const SizedBox(height: 10,),
                CustomButtonWidget(
                  text: 'Continue with Gmail ', // make sure its 20 character long so it aligns
                  backgroundColor: theme.brightness == Brightness.dark ? const Color(0xff202021) : const Color(0xffF7F7F7),
                  icon: SizedBox(width: 15, child: Image.asset(kGoogleIcon)),
                  expand: true, appearance: Appearance.clean,
                  onPressed: widget.onContinueWithGmailTapped,
                ),

                if(Platform.isIOS) ... {
                  const SizedBox(height: 10,),
                  CustomButtonWidget(
                    backgroundColor: theme.brightness == Brightness.dark ? const Color(0xff202021) : const Color(0xffF7F7F7),
                    text: 'Continue with Apple ', // make sure its 20 character long so it aligns
                    icon: SizedBox(width: 15, child: SvgPicture.asset(kAppleIconSvg, width: 18, color: theme.colorScheme.onBackground,)),
                    expand: true, appearance: Appearance.clean,
                    onPressed: widget.onContinueWithAppleTapped,
                  )
                },
                const SizedBox(height: 10,),
                Form(
                  child: ValueListenableBuilder<bool>(valueListenable: state.emailActivated, builder: (ctx, activateEmail, __) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if(activateEmail) ... {
                          CustomTextFieldWidget(
                            label: 'Email',
                            controller: state.emailController,
                            inputType: TextInputType.emailAddress,
                            validator: state.isRequired,
                            placeHolder: 'yourname@example.com',
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        },
                        CustomButtonWidget(
                          text: 'Continue with Email ',
                          expand: true,
                          icon: SizedBox(width: 15, child: Icon(Icons.email, size: 18, color: activateEmail? kAppWhite : theme.colorScheme.onBackground,)),
                          appearance: activateEmail ? Appearance.primary : Appearance.secondary,
                          textColor: activateEmail? kAppWhite : null,
                          onPressed: () => !activateEmail ? state.activateEmail() : state.onContinueWithEmailTaped(ctx),
                        )
                      ],
                    );
                  }),
                ),



              ]),
        ),
      ),

    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class AuthOptionsFormController extends State<AuthOptionsForm> with FormMixin {

  ValueNotifier<bool> emailActivated = ValueNotifier(false);
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) => _AuthOptionsFormView(this);

  @override
  void initState() {
    super.initState();
  }

  void activateEmail() {
    emailActivated.value = true;
  }

  onContinueWithEmailTaped(BuildContext ctx) {
    FocusScope.of(context).unfocus();
    if(!validateAndSaveOnSubmit(ctx)){
      return;
    }

    widget.onContinueWithEmailTapped(emailController.text.trim());


  }


  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

}
