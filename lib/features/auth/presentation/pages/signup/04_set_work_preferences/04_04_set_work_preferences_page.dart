import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_time_zone_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_job_preference_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_profile_onboarding_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_settings_model.dart';

class SetWorkPreferencesPage04 extends StatefulWidget {

  final Function()? onCompleted;
  const SetWorkPreferencesPage04({Key? key, this.onCompleted}) : super(key: key);

  @override
  SetWorkPreferencesPage04Controller createState() => SetWorkPreferencesPage04Controller();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SetWorkPreferencesPage04View extends WidgetView<SetWorkPreferencesPage04, SetWorkPreferencesPage04Controller> {

  const _SetWorkPreferencesPage04View(SetWorkPreferencesPage04Controller state) : super(state);

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

            return   ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                const SizedBox(height: 15,),
                Text(
                  'Select your preferred time zone',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800, fontSize: 20),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Some developers like to work around their own time zone, however, if you don’t mind working for companies anywhere you can always choose “I can work in any time zone”. After all, the best companies today are all over the world.',
                  style: TextStyle(
                      fontSize: 14, color: theme.colorScheme.onPrimary, height: 1.4),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Note: Setting your time zone helps us order jobs more efficiently for you. We won’t hide jobs from you.',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w400, fontSize: 13),
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFieldWidget(
                  label: 'Timezone',
                  placeHolder: 'Tap to select',
                  readOnly: true,
                  onTap: () {
                    showTimeZonesBottomWidget(context, theme);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                if((user.settings?.jobPreferences?.timezone ?? []).isNotEmpty) ... {
                  Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    children: [
                      ...(user.settings?.jobPreferences?.timezone ?? []).map((timeZone) {
                        return GestureDetector(
                          onTap: () {
                            // remove time zone
                            final existingTimeZones = user.settings?.jobPreferences?.timezone ?? [];
                            existingTimeZones.remove(timeZone);
                            state.updateTimeZoneSetting(existingTimeZones, user.settings, user.settings?.jobPreferences?.allTimeZone ?? false);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                //color: backgroundColor,
                                border:  Border.all(color: theme.colorScheme.outline)
                            ),
                            padding: const EdgeInsets.only(left: 14, top: 10, bottom: 10, right: 14),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                               children: [
                                 Expanded(child: Text(timeZone.label ?? '',
                                   maxLines: 1,
                                   overflow: TextOverflow.ellipsis,
                                   style: TextStyle(
                                     color: theme.colorScheme.onPrimary,
                                     fontSize: (defaultFontSize - 2)),),),
                                 const SizedBox(width: 10,),
                                 Icon(Icons.close, size: 15,color: theme.colorScheme.onPrimary,)
                               ],
                            ),
                          ),
                        );
                      }).toList(),

                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                },

                canWorkAllTimeZoneWidget(theme, user, displayText: "I can work in any time zone", value: user.settings?.jobPreferences?.allTimeZone ?? false),
              ],
            );
          },
        )
    );

  }

  void showTimeZonesBottomWidget(BuildContext context, ThemeData theme) {
    final mediaQuery = MediaQuery.of(context);
    final ch = BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (_, next) {
        return next.status == AuthStatus.updateAuthUserSettingSuccessful
            || next.status == AuthStatus.updateAuthUserSettingFailed;
      },
      builder: (context, authState) {
        final user  = AppStorage.currentUserSession!;

        return SizedBox(
          height: mediaQuery.size.height * 0.7,
          child: SingleChildScrollView(
            child: SeparatedColumn(separatorBuilder: (_, __){
              return const CustomBorderWidget();
            }, children: timeZones.map((timezone) => ListTile(
              title: Text(timezone.label ?? '', style: theme.textTheme.bodyMedium,),
              trailing: (user.settings?.jobPreferences?.timezone ?? []).contains(timezone) ? const Icon(Icons.check, size: 20,color: kAppGreen,) : null,
              onTap: () {
                final existingTimeZones = user.settings?.jobPreferences?.timezone ?? [];
                if(existingTimeZones.contains(timezone)){
                  existingTimeZones.remove(timezone);
                }else {
                  existingTimeZones.add(timezone);
                }
                state.updateTimeZoneSetting(existingTimeZones, user.settings, user.settings?.jobPreferences?.allTimeZone ?? false);
                pop(context);
              },
            )).toList(),),
          ),
        );
      },
    );

    showCustomBottomSheet(context, child: ch, showDragHandle: true);
  }

  Widget canWorkAllTimeZoneWidget(ThemeData theme, UserModel user, {required String displayText, required bool value}) {

    return GestureDetector(
      onTap: () => state.updateTimeZoneSetting(user.settings?.jobPreferences?.timezone ?? [], user.settings, !(user.settings?.jobPreferences?.allTimeZone ?? false)),
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
                    color: (user.settings?.jobPreferences?.allTimeZone ?? false) ? kAppBlue : Colors.transparent,
                    border:  (user.settings?.jobPreferences?.allTimeZone ?? false) ? null
                        : Border.all(color: theme.colorScheme.onBackground)
                ),
                width: 25,
                height: 25,
                child: Checkbox(
                  value: user.settings?.jobPreferences?.allTimeZone ?? false,
                  onChanged: (v) =>state.updateTimeZoneSetting(user.settings?.jobPreferences?.timezone ?? [], user.settings, !(user.settings?.jobPreferences?.allTimeZone ?? false)),
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

class SetWorkPreferencesPage04Controller extends State<SetWorkPreferencesPage04> {


  late AuthCubit authCubit;

  @override
  Widget build(BuildContext context) => _SetWorkPreferencesPage04View(this);

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
  }


  @override
  void dispose() {
    super.dispose();
  }

  void updateTimeZoneSetting(List<SharedTimeZoneModel> timeZones, UserSettingsModel? settingsModel, bool allTimeZones) {
    

    final updatedSettings = settingsModel?.copyWith(
        jobPreferences: (settingsModel.jobPreferences ?? const UserJobPreferenceModel()).copyWith(
          timezone: timeZones,
          allTimeZone: allTimeZones
        ),
        profileOnboarding: (settingsModel.profileOnboarding ?? const UserProfileOnboardingModel()).copyWith(
            positions: true
        )
    );

    authCubit.updateAuthUserSetting(updatedSettings);
    
  }
  
  
  

}