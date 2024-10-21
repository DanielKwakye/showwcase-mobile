
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_job_preference_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_settings_model.dart';

class JobPreferenceSalary extends StatefulWidget {

  const JobPreferenceSalary({Key? key}) : super(key: key);

  @override
  JobPreferenceSalaryController createState() => JobPreferenceSalaryController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class JobPreferenceSalaryView extends WidgetView<JobPreferenceSalary, JobPreferenceSalaryController> {

  const JobPreferenceSalaryView(JobPreferenceSalaryController state, {super.key}) : super(state);

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
              'What is your preferred salary range?',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 15,
                color: theme.colorScheme.onBackground,),
            ),
            tilePadding: EdgeInsets.zero,
            collapsedIconColor: theme.colorScheme.onBackground,
            iconColor: theme.colorScheme.onBackground,
            children: <Widget>[
              ValueListenableBuilder<RangeValues>(valueListenable: state.salaryValues, builder: (_, values, __) {

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: theme.colorScheme.outline),
                    // color: theme.brightness == Brightness.dark ? const Color(0xff202021) : const Color(0xffF7F7F7)
                  ),
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Theme(
                    data: theme.copyWith(
                        sliderTheme: theme.sliderTheme.copyWith(
                            valueIndicatorColor: kAppBlue,
                            trackHeight: 2,

                            valueIndicatorTextStyle: const TextStyle(
                                backgroundColor: Colors.transparent
                            ))
                    ),
                    child: RangeSlider(
                      min: 0.0,
                      max: 500.0,
                      divisions: 250,
                      values: values,
                      onChanged: state._onSliderChanged,
                      activeColor: kAppBlue,
                      inactiveColor: theme.colorScheme.outline,
                      labels: RangeLabels("\$ ${values.start.toStringAsFixed(0)}K", "\$ ${values.end.toStringAsFixed(0)}K"),
                    ),
                  ),
                );

              }),
              const SizedBox(height: 8,),
              ValueListenableBuilder<RangeValues>(valueListenable: state.salaryValues, builder: (_, values, __) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$ ${values.start.toStringAsFixed(0)}K',
                      style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: defaultFontSize - 2),
                    ),
                    Text(
                      '\$ ${values.end.toStringAsFixed(0)}K',
                      style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: defaultFontSize - 2),
                    )
                  ],
                );
              }),
              const SizedBox(height: 15,),
            ],
          ),
        );
      },
    );
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class JobPreferenceSalaryController extends State<JobPreferenceSalary> {
  late AuthCubit authCubit;
  late ValueNotifier<RangeValues> salaryValues;

  @override
  Widget build(BuildContext context) => JobPreferenceSalaryView(this);

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
    final user = AppStorage.currentUserSession!;
    salaryValues = ValueNotifier(RangeValues( (user.settings?.jobPreferences?.salaryFrom ?? 0.0).toDouble(), (user.settings?.jobPreferences?.salaryTo ?? 500.0).toDouble()));
    _onSliderChanged(salaryValues.value);
  }

  void _onSliderChanged(RangeValues values) {
    salaryValues.value = values;
    final user = AppStorage.currentUserSession!;
    EasyDebounce.debounce(
        'salary-expectation-debouncer',                 // <-- An ID for this particular debouncer
        const Duration(milliseconds: 500),    // <-- The debounce duration
            () async {                             // <-- The target method
          updateSalaryExpectationSetting((values.start).toInt(), (values.end).toInt(), user.settings);
        }
    );
  }

  void updateSalaryExpectationSetting(int salaryFrom, int salaryTo, UserSettingsModel? settingsModel) {

    final updatedSettings = settingsModel?.copyWith(
        jobPreferences: (settingsModel.jobPreferences ?? const UserJobPreferenceModel()).copyWith(
            salaryFrom: salaryFrom,
            salaryTo: salaryTo
        ),
    );

    authCubit.updateAuthUserSetting(updatedSettings);


  }
}