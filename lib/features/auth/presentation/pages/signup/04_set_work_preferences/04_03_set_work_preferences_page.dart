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

class SetWorkPreferencesPage03 extends StatefulWidget {

  final Function()? onCompleted;
  const SetWorkPreferencesPage03({Key? key, this.onCompleted}) : super(key: key);

  @override
  SetWorkPreferencesPage03Controller createState() => SetWorkPreferencesPage03Controller();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SetWorkPreferencesPage03View extends WidgetView<SetWorkPreferencesPage03, SetWorkPreferencesPage03Controller> {

  const _SetWorkPreferencesPage03View(SetWorkPreferencesPage03Controller state) : super(state);

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
                  'Firstly, what kind of role are you looking for ?',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800, fontSize: 20),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text('If you are not sure, select a few that you may be interested in.',
                  style: TextStyle(fontSize: 14,color: theme.colorScheme.onPrimary,height: 1.4),
                ),
                const SizedBox(
                  height: 16,
                ),
                SeparatedColumn(separatorBuilder: (_,__){
                  return const  SizedBox(height: 16,);
                },children: state.roleTypes.map((roleType) {

                return jobRoleTypeItem(theme, user, displayText: roleType, value: roleType);

                }).toList()
              ,)


              ],
            );
          },
        )
    );

  }

  Widget jobRoleTypeItem(ThemeData theme, UserModel user, {required String displayText, required String value}) {

    return GestureDetector(
      onTap: () => state.updateJobTypeSetting(value, user.settings),
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
                    color: (user.settings?.jobPreferences?.roleType?.contains(value) ?? false) ? kAppBlue : Colors.transparent,
                    border:  (user.settings?.jobPreferences?.roleType?.contains(value) ?? false) ? null
                        : Border.all(color: theme.colorScheme.onBackground)
                ),
                width: 25,
                height: 25,
                child: Checkbox(
                  value: user.settings?.jobPreferences?.roleType?.contains(value) ?? false,
                  onChanged: (v) => state.updateJobTypeSetting(value, user.settings),
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

class SetWorkPreferencesPage03Controller extends State<SetWorkPreferencesPage03> {

  late AuthCubit authCubit;

  final List<String> roleTypes = [
    'Front End',
    'Back End',
    'Full Stack',
    'Machine Learning',
    'iOS Development',
    'Cross Platform Mobile',
    'Android Development',
    'Embedded Systems',
    'Deep Learning',
    'Computer Vision',
    'Data Science',
    'Data Engineering',
    'Data Analytics',
    'Blockchain',
    'Security Engineering',
    'Product Designer',
    'CTO',
    'Developer Advocate',
    'Community Manager',
    'Product Manager',
    'Content writer',
  ];

  @override
  Widget build(BuildContext context) => _SetWorkPreferencesPage03View(this);

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
  }


  @override
  void dispose() {
    super.dispose();
  }

  void updateJobTypeSetting(String type, UserSettingsModel? settingsModel) {

    final List<String> existingTypes = settingsModel?.jobPreferences?.roleType ?? [];
    // if the type is already added remove, else add it
    if(existingTypes.contains(type)){
      existingTypes.remove(type);
    }else {
      existingTypes.add(type);
    }

    final updatedSettings = settingsModel?.copyWith(
        jobPreferences: (settingsModel.jobPreferences ?? const UserJobPreferenceModel()).copyWith(
          roleType: existingTypes,
        ),
        profileOnboarding: (settingsModel.profileOnboarding ?? const UserProfileOnboardingModel()).copyWith(
            positions: true
        )
    );

    authCubit.updateAuthUserSetting(updatedSettings);


  }

}