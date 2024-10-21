import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/mix/form_mixin.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/auth_email.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/auth_social.dart';
import 'package:showwcase_v3/features/auth/presentation/widgets/auth_options_form.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_default_logo.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_full_screen_sliver_app_bar.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_page_loading_indicator_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_terms_privacy_widget.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageController createState() => LoginPageController();

}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _LoginPageView extends WidgetView<LoginPage, LoginPageController> {

  const _LoginPageView(LoginPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        bloc: state._authCubit,
        builder: (context, authState) {
          return CustomPageLoadingIndicatorWidget(
            loading: authState.status == AuthStatus.loginInProgress || authState.status == AuthStatus.authenticateWithEmailInProgress || authState.status == AuthStatus.submitEmailForValidationInProgress ,
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                const CustomFullScreenDialogSliverAppBar(title: "Login"),
                SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20,),
                      const CustomDefaultLogoWidget(),
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text('Welcome to Showwcase!', textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text("You've been away too long...",
                          style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                            fontSize: 16
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Text("Login",
                        style: TextStyle(
                            color: theme.colorScheme.onBackground,
                            fontWeight: FontWeight.w600,
                          fontSize: 16
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: AuthOptionsForm(onContinueWithGithubTapped: state._onLoginWithGithubTapped,
                          onContinueWithGmailTapped: state._onLoginWithGmailTapped,
                          onContinueWithAppleTapped: state._onLoginWithAppleTapped,
                          onContinueWithEmailTapped: state._onLoginWithEmail,

                        ),
                      ),
                      const SizedBox(height: 20,),
                      GestureDetector(
                        onTap: state._onSwitchToSignUpTapped,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account ? ",
                              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary),
                              children: const <TextSpan>[
                                TextSpan(text: 'Sign Up', style: TextStyle(color: kAppBlue)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30,),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: CustomTermsPrivacyWidget(),
                      ),

                      const SizedBox(height: kToolbarHeight,),

                    ],
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

class LoginPageController extends State<LoginPage> with FormMixin {

  late AuthCubit _authCubit;
  String? email;
  late StreamSubscription<AuthState> authStateStreamSubscription;


  @override
  Widget build(BuildContext context) => _LoginPageView(this);

  @override
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>();
    authStateStreamSubscription = _authCubit.stream.listen((event) async {

      if(event.status == AuthStatus.loginSuccessful) {
        context.go("/");
      }

      if(event.status == AuthStatus.loginFailed) {
        context.showSnackBar(event.message, appearance: Appearance.error);
      }

      if(event.status == AuthStatus.submitEmailForValidationFailed) {
        context.showSnackBar(event.message, appearance: Appearance.error);
      }

      if(event.status == AuthStatus.submitEmailForValidationSuccessful)  {

        // email cannot be null
        if(email == null){ return;}

        final token = await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AuthEmail(email: email!)),) as String?;
        if(token != null && !token.isNullOrEmpty()){
          _authCubit.login(token: token);
        }
      }

    });
  }


  /// login with Github tapped
  void _onLoginWithGithubTapped() async {

    final token = await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const AuthSocial(loginType: "github")),) as String?;
    if(token != null && !token.isNullOrEmpty()){
      _authCubit.login(token: token);
    }

  }

  /// login with Gmail tapped
  void _onLoginWithGmailTapped() async {
    final token = await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const AuthSocial(loginType: "gmail"),)) as String?;
    if(token != null && !token.isNullOrEmpty()){
      _authCubit.login(token: token);
    }
  }
  /// login with apple tapped
  void _onLoginWithAppleTapped() async {
    final token = await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const AuthSocial(loginType: "apple"),)) as String?;
    if(token != null && !token.isNullOrEmpty()){
      _authCubit.login(token: token);
    }

  }

  /// login with Email tapped
  void _onLoginWithEmail(String email) {
    this.email = email;
    _authCubit.submitEmailForValidation(email: email);
  }

  /// on switchToSignup Tapped
  void _onSwitchToSignUpTapped(){
    context.push(signupPage);
  }

  @override
  void dispose() {
    super.dispose();
    authStateStreamSubscription.cancel();
  }

}