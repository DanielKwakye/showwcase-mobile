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

class JobPreferencesTeams extends StatefulWidget {

  const JobPreferencesTeams({Key? key}) : super(key: key);

  @override
  JobPreferencesTeamsController createState() => JobPreferencesTeamsController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class JobPreferencesTeamsView extends WidgetView<JobPreferencesTeams, JobPreferencesTeamsController> {

  const JobPreferencesTeamsView(JobPreferencesTeamsController state, {super.key}) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (_, next) {
        return next.status == AuthStatus.updateAuthUserSettingSuccessful ||
            next.status == AuthStatus.updateAuthUserSettingFailed;
      },
      builder: (context, authState) {
        final user = AppStorage.currentUserSession!;
        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              'Team and Company Values',
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
              },children: state.companyValues.map((companyValue) {

                return jobCompanyValuesWidget(theme, user, displayText: companyValue, value: companyValue);

              }).toList()
                ,),
              const SizedBox(height: 15,),
            ],
          ),
        );
      },
    );
  }

  Widget jobCompanyValuesWidget(ThemeData theme, UserModel user, {required String displayText, required String value}) {

    return GestureDetector(
      onTap: () {
        state.updateJobCompanyValuesSetting(value, user.settings);
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
                    color: (user.settings?.jobPreferences?.companyValues?.contains(value) ?? false) ? kAppBlue : Colors.transparent,
                    border:  (user.settings?.jobPreferences?.companyValues?.contains(value) ?? false) ? null : Border.all(color: theme.colorScheme.onBackground)
                ),
                width: 25,
                height: 25,
                child: Checkbox(
                  value: (user.settings?.jobPreferences?.companyValues?.contains(value) ?? false),
                  onChanged: (v) => state.updateJobCompanyValuesSetting(value, user.settings),
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

class JobPreferencesTeamsController extends State<JobPreferencesTeams> {
  late AuthCubit authCubit;

  final List<String> companyValues = [
    'Engage with community',
    'Collaboration oriented',
    'Risk-taking culture',
    'Single threaded leaders',
    'Contributes to open source projects',
    'Values diversity and inclusion',
    'Continuous feedback culture',
    'Opportunities for Growth',
    'Marketing',
    'Open communication',
    'Flat organisation',
    'To wear many hats',
    'Pair coding',
    'Micro manage',
    'Promotes end-to-end ownership',
  ];

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
  }

  @override
  Widget build(BuildContext context) => JobPreferencesTeamsView(this);


  void updateJobCompanyValuesSetting(String companyValue, UserSettingsModel? settingsModel) {

    final List<String> existingValues = settingsModel?.jobPreferences?.companyValues ?? [];
    // if the type is already added remove, else add it
    if(existingValues.contains(companyValue)){
      existingValues.remove(companyValue);
    }else {
      existingValues.add(companyValue);
    }

    final updatedSettings = settingsModel?.copyWith(
        jobPreferences: (settingsModel.jobPreferences ?? const UserJobPreferenceModel()).copyWith(
          companyValues: existingValues,
        ),
    );

    authCubit.updateAuthUserSetting(updatedSettings);


  }

}