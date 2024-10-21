import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_job_preference_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_settings_model.dart';

class JobsPreferenceRole extends StatefulWidget {

  const JobsPreferenceRole({Key? key}) : super(key: key);

  @override
  JobsPreferenceRoleController createState() => JobsPreferenceRoleController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class JobsPreferenceRoleView extends WidgetView<JobsPreferenceRole, JobsPreferenceRoleController> {

  const JobsPreferenceRoleView(JobsPreferenceRoleController state, {super.key}) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = AppStorage.currentUserSession!;
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: state._authCubit,
      buildWhen: (_, next) {
        return next.status == AuthStatus.updateAuthUserSettingSuccessful
            || next.status == AuthStatus.updateAuthUserSettingFailed;
      },
      builder: (context,  authState) {
        final user = AppStorage.currentUserSession!;

        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              'Role Type',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 15,
                color: theme.colorScheme.onBackground,),
            ),
            tilePadding: EdgeInsets.zero,
            collapsedIconColor: theme.colorScheme.onBackground,
            iconColor: theme.colorScheme.onBackground,
            children: <Widget>[
              SeparatedColumn(separatorBuilder: (_,__){
                return const  SizedBox(height: 16,);
              },children:
              state.roleTypes.map((roleType) {
                return jobRoleTypeItem(theme, user, displayText: roleType, value: roleType);
              }).toList()
                ,),
              const SizedBox(
                height: 15,
              ),
              // JopTypeItem(
              //   user: AppStorage.currentUserSession!,
              //   displayText: 'Full-time',
              //   value: 'full-time',
              //   onTap: () {
              //     updateJobTypeSetting('full-time', user.settings);
              //   },
              // ),

            ],
          ),
        );
      },

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

class JobsPreferenceRoleController extends State<JobsPreferenceRole> {
  late AuthCubit _authCubit;
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
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>();
  }

  @override
  Widget build(BuildContext context) => JobsPreferenceRoleView(this);

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
      ),);

    _authCubit.updateAuthUserSetting(updatedSettings);
  }
}
