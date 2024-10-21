import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_job_preference_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_settings_model.dart';

class JobPreferencesProblem extends StatefulWidget {
  const JobPreferencesProblem({Key? key}) : super(key: key);

  @override
  JobPreferencesProblemController createState() =>
      JobPreferencesProblemController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class JobPreferencesProblemView
    extends WidgetView<JobPreferencesProblem, JobPreferencesProblemController> {
  const JobPreferencesProblemView(JobPreferencesProblemController state,
      {super.key})
      : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (_, next) {
        return next.status == AuthStatus.updateAuthUserSettingSuccessful ||
            next.status == AuthStatus.updateAuthUserSettingFailed;
      },
      builder: (context, state) {
        final user = AppStorage.currentUserSession!;
        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              'Which of the following is larger problem for you?',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 15,
                color: theme.colorScheme.onBackground,),
            ),
            tilePadding: EdgeInsets.zero,
            collapsedIconColor: theme.colorScheme.onBackground,
            iconColor: theme.colorScheme.onBackground,
            children: <Widget>[
              jobProblemWidget(theme, user,
                  displayText: "Finding companies who are interested in me",
                  value: "will_interview"),
              const SizedBox(
                height: 16,
              ),
              jobProblemWidget(theme, user,
                  displayText: "Finding companies that I want to join",
                  value: "can_join"),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget jobProblemWidget(ThemeData theme, UserModel user,
      {required String displayText, required String value}) {
    return GestureDetector(
      onTap: () {
        state.updateJobProblemSetting(value, user.settings);
      },
      child: Container(
          decoration: BoxDecoration(
              // color: theme.brightness == Brightness.dark ? const Color(0xff202021) : const Color(0xffF7F7F7),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: theme.colorScheme.outline)),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    // Adjust the value to control the corner radius
                    color: (user.settings?.jobPreferences?.problem == value)
                        ? kAppBlue
                        : Colors.transparent,
                    border: (user.settings?.jobPreferences?.problem == value)
                        ? null
                        : Border.all(color: theme.colorScheme.onBackground)),
                width: 25,
                height: 25,
                child: Checkbox(
                  value: user.settings?.jobPreferences?.problem == value,
                  onChanged: (v) =>
                      state.updateJobProblemSetting(value, user.settings),
                  fillColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  side: MaterialStateBorderSide.resolveWith(
                        (states) => const BorderSide(width: 1.0, color: Colors.transparent),
                  ),
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        4.0), // Adjust the value to match the parent container's corner radius
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Text(
                displayText,
                style: theme.textTheme.bodyMedium,
              ))
            ],
          )),
    );
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class JobPreferencesProblemController extends State<JobPreferencesProblem> {
  late AuthCubit authCubit;

  @override
  Widget build(BuildContext context) => JobPreferencesProblemView(this);

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
  }

  void updateJobProblemSetting(
      String problem, UserSettingsModel? settingsModel) {
    final updatedSettings = settingsModel?.copyWith(
        jobPreferences:
            (settingsModel.jobPreferences ?? const UserJobPreferenceModel())
                .copyWith(
      problem: problem,
    ));

    authCubit.updateAuthUserSetting(updatedSettings);
  }
}
