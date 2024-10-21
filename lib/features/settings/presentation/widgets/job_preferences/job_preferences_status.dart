import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_job_preference_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_settings_model.dart';

class JobPreferencesStatus extends StatefulWidget {

  const JobPreferencesStatus({Key? key}) : super(key: key);

  @override
  JobPreferencesRoleAttributeController createState() =>
      JobPreferencesRoleAttributeController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class JobPreferencesRoleAttributeView extends WidgetView<JobPreferencesStatus,
    JobPreferencesRoleAttributeController> {
  const JobPreferencesRoleAttributeView(
      JobPreferencesRoleAttributeController state,
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
      builder: (context, authState) {
        final user = AppStorage.currentUserSession!;
        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent
          ),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(
              'Current Job Status',
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  color: theme.colorScheme.onBackground,),
            ),
            collapsedIconColor: theme.colorScheme.onBackground,
            iconColor: theme.colorScheme.onBackground,
            // trailing: const Icon(Icons.keyboard_arrow_right_sharp),
            children: <Widget>[
              ValueListenableBuilder(
                valueListenable: state.currentJobDropdown,
                builder: (BuildContext context, String? value, Widget? child) {
                  return Container(
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? const Color(0xff202021)
                          : const Color(0xffF7F7F7),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: theme.colorScheme.onPrimary.withOpacity(0.2),
                            shape: BoxShape.circle),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/svg/briefcase.svg',
                            color: state
                                .jobColor[state.jobStatuses.indexOf(value!)],
                          ),
                        ),
                      ),
                      title: Text(
                        value ?? '',
                        style: theme.textTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        state.jobSubtitle[
                        state.jobStatuses.indexOf(value)] ??
                            '',
                        style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      onTap: () {
                        showJobStatusBottomWidget(context, theme);
                      },
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

  void showJobStatusBottomWidget(BuildContext context, ThemeData theme) {
    final mediaQuery = MediaQuery.of(context);
    final ch = BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (_, next) {
        return next.status == AuthStatus.updateAuthUserSettingSuccessful ||
            next.status == AuthStatus.updateAuthUserSettingFailed;
      },
      builder: (context, authState) {
        final user = AppStorage.currentUserSession!;

        return ValueListenableBuilder(
          valueListenable: state.currentJobDropdown,
          builder: (BuildContext context, String? value, Widget? child) {
            return SizedBox(
              height: mediaQuery.size.height / 2.5,
              child: SingleChildScrollView(
                child: SeparatedColumn(
                  separatorBuilder: (_, __) {
                    return const CustomBorderWidget();
                  },
                  children: state.jobStatuses
                      .map((jobStatus) => ListTile(
                                contentPadding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                                leading: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: theme.colorScheme.onPrimary
                                          .withOpacity(0.2),
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/svg/briefcase.svg',
                                      color: state.jobColor[
                                          state.jobStatuses.indexOf(jobStatus)],
                                    ),
                                  ),
                                ),
                                title: Text(
                                  jobStatus ?? '',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                subtitle: Text(
                                  state.jobSubtitle[state.jobStatuses
                                          .indexOf(jobStatus)] ??
                                      '',
                                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimary),
                                ),
                                trailing: checksEqual(value!, jobStatus)
                                    ? const Icon(
                                        Icons.check,
                                        size: 20,
                                        color: kAppGreen,
                                      )
                                    : null,
                                onTap: () {
                                  state.currentJobDropdown.value = jobStatus;
                                  String status =
                                      jobStatus == state.jobStatuses[0]
                                          ? "open"
                                          : jobStatus == state.jobStatuses[1]
                                              ? 'active'
                                              : 'closed';
                                  state.updateStatusSettings(
                                      status, user.settings, false);
                                  pop(context);
                                },
                              )
                          )
                      .toList(),
                ),
              ),
            );
          },
        );
      },
    );

    showCustomBottomSheet(context, child: ch, showDragHandle: true);
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class JobPreferencesRoleAttributeController
    extends State<JobPreferencesStatus> {
  late AuthCubit authCubit;
  List<Color> jobColor = [kAppGreen, kAppBlue, kAppRed];
  List<String> jobStatuses = [
    'Open to offers',
    'Actively Looking',
    'Not Open to offers'
  ];
  List<String> jobSubtitle = [
    'Show recruiters and others that you’re Open to work',
    'Show recruiters and others that you’re Open to work',
    'You’re not looking and don’t want to hear about new opportunites. Your job profile will be hidden to companies'
  ];
  late ValueNotifier<String?> currentJobDropdown;

  @override
  void initState() {
    super.initState();
    currentJobDropdown = ValueNotifier(
        AppStorage.currentUserSession?.settings?.jobPreferences?.status ??
            jobStatuses[0]);
    authCubit = context.read<AuthCubit>();

    if (currentJobDropdown.value == 'open') {
      currentJobDropdown.value = jobStatuses[0];
    } else if (currentJobDropdown.value == 'active') {
      currentJobDropdown.value = jobStatuses[1];
    } else {
      currentJobDropdown.value = jobStatuses[2];
    }
  }

  @override
  Widget build(BuildContext context) => JobPreferencesRoleAttributeView(this);

  void updateStatusSettings(
      String status, UserSettingsModel? settingsModel, bool allTimeZones) {
    final updatedSettings = settingsModel?.copyWith(
      jobPreferences:
          (settingsModel.jobPreferences ?? const UserJobPreferenceModel())
              .copyWith(status: status.toLowerCase()),
    );

    authCubit.updateAuthUserSetting(updatedSettings);
  }
}
