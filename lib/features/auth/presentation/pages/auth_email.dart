import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:showwcase_v3/core/mix/form_mixin.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_full_screen_sliver_app_bar.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_page_loading_indicator_widget.dart';

import '../../../../core/utils/theme.dart';
import '../../../shared/presentation/widgets/custom_default_logo.dart';
import '../../../shared/presentation/widgets/custom_terms_privacy_widget.dart';
import '../../../shared/presentation/widgets/custom_text_field_widget.dart';
import '../../data/bloc/auth_state.dart';

class AuthEmail extends StatefulWidget {

  final String email;
  const AuthEmail({Key? key, required this.email}) : super(key: key);

  @override
  AuthEmailController createState() => AuthEmailController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _AuthEmailView extends WidgetView<AuthEmail, AuthEmailController> {

  const _AuthEmailView(AuthEmailController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        bloc: state._authCubit,
        builder: (context, authState) {
          return CustomPageLoadingIndicatorWidget(
            loading: authState.status == AuthStatus.submitEmailForValidationResendInProgress || authState.status == AuthStatus.authenticateWithEmailInProgress,
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                const CustomFullScreenDialogSliverAppBar(title: ""),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 30,),
                        const CustomDefaultLogoWidget(),
                        const SizedBox(height: 20,),
                        Column(
                          children: <Widget>[
                            Text('Welcome to Showwcase!', textAlign: TextAlign.center,
                              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),),
                            const SizedBox(height: 5,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Text("Enter code to continue",
                                style: TextStyle(
                                    color: theme.colorScheme.onPrimary,
                                    fontSize: 16
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Form(
                            child: AnimationConfiguration.synchronized(
                                child: SlideAnimation(
                                    duration: const Duration(milliseconds: 800),
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: Column(children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Please check your email inbox for a code we sent. Didn’t receive it? Click resend email below",
                                          style: TextStyle(
                                              color: theme
                                                  .colorScheme.onPrimary,
                                              height: 1.5),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        CustomTextFieldWidget(
                                          controller: state.verificationCodeController,
                                          label: 'Verification code',
                                          placeHolder: 'eg. 123456',
                                          inputType: TextInputType.number,
                                          validator: state.isRequired,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Builder(builder: (ctx) {
                                          return CustomButtonWidget(
                                            text: 'Verify',
                                            expand: true,
                                            appearance: Appearance.primary,
                                            onPressed: () => state._onSubmitVerificationCodeTapped(ctx),
                                          );
                                        }),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        GestureDetector(
                                          onTap: state
                                              ._onResendVerificationCodeTapped,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: RichText(
                                              text: TextSpan(
                                                text: 'Didn\'t get the code? ',
                                                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary),
                                                children: const <TextSpan>[
                                                  TextSpan(
                                                      text: 'Resend link',
                                                      style: TextStyle(
                                                          color: kAppBlue)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        const CustomTermsPrivacyWidget(),
                                      ]),
                                    ))),
                          ),
                        ),

                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class AuthEmailController extends State<AuthEmail> with FormMixin {

  final TextEditingController verificationCodeController = TextEditingController();
  late AuthCubit _authCubit;
  late StreamSubscription<AuthState> authStateStreamSubscription;

  @override
  Widget build(BuildContext context) => _AuthEmailView(this);

  @override
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>();
    authStateStreamSubscription = _authCubit.stream.listen((event) async {

      if(event.status == AuthStatus.submitEmailForValidationResendSuccessful)  {
        context.showSnackBar('Verification code sent!', appearance: Appearance.error);
      }

      if(event.status == AuthStatus.submitEmailForValidationResendFailed)  {
        context.showSnackBar(event.message, appearance: Appearance.error);
      }

      if(event.status == AuthStatus.authenticateWithEmailFailed)  {
        context.showSnackBar(event.message, appearance: Appearance.error);
      }

    });

  }

  // user enters the verification code received and submit
  void _onSubmitVerificationCodeTapped(BuildContext ctx) async {
    // email should not be null at this point
    if(!validateAndSaveOnSubmit(ctx)){
      return;
    }

    final String? token = await _authCubit.authenticateWithEmail(email: widget.email,  verificationCode: verificationCodeController.text.trim());
    if(token != null && mounted) {
      pop(context, token);
    }

  }

  ///   resend verification code link
  void _onResendVerificationCodeTapped(){
    _authCubit.submitEmailForValidation(email: widget.email, resend: true);
  }



  @override
  void dispose() {
    super.dispose();
    verificationCodeController.dispose();
  }

}