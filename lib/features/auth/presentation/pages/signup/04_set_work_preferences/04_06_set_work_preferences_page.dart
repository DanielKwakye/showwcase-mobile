import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_job_preference_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_profile_onboarding_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_settings_model.dart';

class SetWorkPreferencesPage06 extends StatefulWidget {

  final Function()? onCompleted;
  const SetWorkPreferencesPage06({Key? key, this.onCompleted}) : super(key: key);

  @override
  SetWorkPreferencesPage06Controller createState() => SetWorkPreferencesPage06Controller();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SetWorkPreferencesPage06View extends WidgetView<SetWorkPreferencesPage06, SetWorkPreferencesPage06Controller> {

  const _SetWorkPreferencesPage06View(SetWorkPreferencesPage06Controller state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
          child: CustomButtonWidget(
            expand: true,
            onPressed: (){
              widget.onCompleted?.call();
            }, text: 'Next',
          ),
        ),
        body:BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (_, next) {
            return next.status == AuthStatus.updateAuthUserSettingSuccessful
                || next.status == AuthStatus.updateAuthUserSettingFailed;
          },
          builder: (context, authState) {

            final user = AppStorage.currentUserSession!;

            return   ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                const SizedBox(height: 15,),
                Text(
                  'Would you consider yourself a junior engineer?',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800, fontSize: 20),
                ),
                const SizedBox(height: 16,),
                Text(
                  'A junior engineer is someone with less than 1 year of full time professional experience.',
                  style: TextStyle(
                      fontSize: 14, color: theme.colorScheme.onPrimary, height: 1.4),
                ),
                const SizedBox(height: 16,),
                jobJuniorEngWidget(theme, user, displayText: "Yes", value: true),
                const SizedBox(height: 16,),
                jobJuniorEngWidget(theme, user, displayText: "No", value: false),
              ],
            );
          },
        )
    );

  }

  Widget jobJuniorEngWidget(ThemeData theme, UserModel user, {required String displayText, required bool value}) {

    return GestureDetector(
      onTap: () {
        state.updateIsJuniorSetting(value, user.settings);
      },
      child: Container(
          decoration: BoxDecoration(
            // color: theme.brightness == Brightness.dark ? const Color(0xff202021) : const Color(0xffF7F7F7),
              borderRadius: BorderRadius.circular(4),
              border:  Border.all(color: theme.colorScheme.outline)
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0), // Adjust the value to control the corner radius
                    color: (user.settings?.jobPreferences?.isJunior == value) ? kAppBlue : Colors.transparent,
                    border:  (user.settings?.jobPreferences?.isJunior == value) ? null : Border.all(color: theme.colorScheme.onBackground)
                ),
                width: 25,
                height: 25,
                child: Checkbox(
                  value: user.settings?.jobPreferences?.isJunior == value,
                  onChanged: (v) => state.updateIsJuniorSetting(value, user.settings),
                  fillColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  side: MaterialStateBorderSide.resolveWith(
                        (states) => const BorderSide(width: 1.0, color: Colors.transparent),
                  ),
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0), // Adjust the value to match the parent container's corner radius
                  ),
                ),
              ),
              const SizedBox(width: 20,),
              Expanded(child: Text(displayText, style: theme.textTheme.bodyMedium,))
            ],
          )
      ),
    );
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SetWorkPreferencesPage06Controller extends State<SetWorkPreferencesPage06> {

  late AuthCubit authCubit;

  @override
  Widget build(BuildContext context) => _SetWorkPreferencesPage06View(this);

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
  }

  void updateIsJuniorSetting(bool isJunior, UserSettingsModel? settingsModel) {

    final updatedSettings = settingsModel?.copyWith(
        jobPreferences: (settingsModel.jobPreferences ?? const UserJobPreferenceModel()).copyWith(
          isJunior: isJunior,
        ),
        profileOnboarding: (settingsModel.profileOnboarding ?? const UserProfileOnboardingModel()).copyWith(
            positions: true
        )
    );

    authCubit.updateAuthUserSetting(updatedSettings);


  }

  @override
  void dispose() {
    super.dispose();
  }

}