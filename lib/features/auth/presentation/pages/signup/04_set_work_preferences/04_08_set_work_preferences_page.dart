import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
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

class SetWorkPreferencesPage08 extends StatefulWidget {

  final Function()? onCompleted;
  const SetWorkPreferencesPage08({Key? key, this.onCompleted}) : super(key: key);

  @override
  SetWorkPreferencesPage08Controller createState() => SetWorkPreferencesPage08Controller();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SetWorkPreferencesPage08View extends WidgetView<SetWorkPreferencesPage08, SetWorkPreferencesPage08Controller> {

  const _SetWorkPreferencesPage08View(SetWorkPreferencesPage08Controller state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
          child: CustomButtonWidget(
            expand: true,
            fontWeight: FontWeight.w700,
            onPressed: (){
              widget.onCompleted?.call();
            }, text: 'Next',
          ),
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (_, next) {
            return next.status == AuthStatus.updateAuthUserSettingSuccessful
                || next.status == AuthStatus.updateAuthUserSettingFailed;
          },
          builder: (context, authState) {

            final user = AppStorage.currentUserSession!;

            return  ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'What is most important to you in your next position?',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800, fontSize: 20),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text('We recommended selecting up to 3 but you’re more than welcome to select more.',
                  style: TextStyle(fontSize: 14,color: theme.colorScheme.onPrimary,height: 1.4),
                ),
                const SizedBox(
                  height: 16,
                ),
                SeparatedColumn(separatorBuilder: (_,__){
                  return const  SizedBox(height: 16,);
                },children: state.attributes.map((attribute) {

                  return jobAttributeWidget(theme, user, displayText: attribute, value: attribute);

                }).toList()
                  ,)

              ],
            );
          },
        )
    );

  }

  Widget jobAttributeWidget(ThemeData theme, UserModel user, {required String displayText, required String value}) {

    return GestureDetector(
      onTap: () {
        state.updateJobAttributeSetting(value, user.settings);
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
                    color: (user.settings?.jobPreferences?.attributes?.contains(value) ?? false) ? kAppBlue : Colors.transparent,
                    border:  (user.settings?.jobPreferences?.attributes?.contains(value) ?? false) ? null : Border.all(color: theme.colorScheme.onBackground)
                ),
                width: 25,
                height: 25,
                child: Checkbox(
                  value: (user.settings?.jobPreferences?.attributes?.contains(value) ?? false),
                  onChanged: (v) => state.updateJobAttributeSetting(value, user.settings),
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

class SetWorkPreferencesPage08Controller extends State<SetWorkPreferencesPage08> {

  late AuthCubit authCubit;
  final List<String> attributes = [
    'Autonomy',
    'Salary',
    'Mentorship',
    'Equity',
    'Impressive Team Members',
    'Highly Collaborative',
    'Company mission',
    'Opportunities for Growth',
    'To wear many hats',
  ];

  @override
  Widget build(BuildContext context) => _SetWorkPreferencesPage08View(this);

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
  }


  @override
  void dispose() {
    super.dispose();
  }

  void updateJobAttributeSetting(String attribute, UserSettingsModel? settingsModel) {

    final List<String> existingAttributes = settingsModel?.jobPreferences?.attributes ?? [];
    // if the type is already added remove, else add it
    if(existingAttributes.contains(attribute)){
      existingAttributes.remove(attribute);
    }else {
      existingAttributes.add(attribute);
    }

    final updatedSettings = settingsModel?.copyWith(
        jobPreferences: (settingsModel.jobPreferences ?? const UserJobPreferenceModel()).copyWith(
          attributes: existingAttributes,
        ),
        profileOnboarding: (settingsModel.profileOnboarding ?? const UserProfileOnboardingModel()).copyWith(
            positions: true
        )
    );

    authCubit.updateAuthUserSetting(updatedSettings);


  }

}