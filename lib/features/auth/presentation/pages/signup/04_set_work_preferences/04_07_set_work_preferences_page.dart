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
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_job_preference_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_profile_onboarding_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_settings_model.dart';

class SetWorkPreferencesPage07 extends StatefulWidget {

  final Function()? onCompleted;
  const SetWorkPreferencesPage07({Key? key, this.onCompleted}) : super(key: key);

  @override
  SetWorkPreferencesPage07Controller createState() => SetWorkPreferencesPage07Controller();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SetWorkPreferencesPage07View extends WidgetView<SetWorkPreferencesPage07, SetWorkPreferencesPage07Controller> {

  const _SetWorkPreferencesPage07View(SetWorkPreferencesPage07Controller state) : super(state);

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
            return   ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                const SizedBox(height: 15,),
                Text(
                  'What is your preferred salary range?',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800, fontSize: 20),
                ),
                const SizedBox(height: 16,),
                Text(
                  'We’ve set the currency to USD by default.',
                  style: TextStyle(
                      fontSize: 14, color: theme.colorScheme.onPrimary, height: 1.4),
                ),
                const SizedBox(height: 16,),

                const SizedBox(height: 20,),
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
                })

              ],
            );
          },
        )
    );

  }



}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SetWorkPreferencesPage07Controller extends State<SetWorkPreferencesPage07> {

  late AuthCubit authCubit;
  late ValueNotifier<RangeValues> salaryValues;

  @override
  Widget build(BuildContext context) => _SetWorkPreferencesPage07View(this);

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


  @override
  void dispose() {
    super.dispose();
  }

  void updateSalaryExpectationSetting(int salaryFrom, int salaryTo, UserSettingsModel? settingsModel) {

    final updatedSettings = settingsModel?.copyWith(
        jobPreferences: (settingsModel.jobPreferences ?? const UserJobPreferenceModel()).copyWith(
          salaryFrom: salaryFrom,
          salaryTo: salaryTo
        ),
        profileOnboarding: (settingsModel.profileOnboarding ?? const UserProfileOnboardingModel()).copyWith(
            positions: true
        )
    );

    authCubit.updateAuthUserSetting(updatedSettings);


  }

}