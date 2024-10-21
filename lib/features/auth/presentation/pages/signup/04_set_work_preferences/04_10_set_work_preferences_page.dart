import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/companies/data/bloc/company_cubit.dart';
import 'package:showwcase_v3/features/companies/data/bloc/company_state.dart';
import 'package:showwcase_v3/features/companies/data/models/company_industry_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_job_preference_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_profile_onboarding_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_settings_model.dart';


class SetWorkPreferencesPage10 extends StatefulWidget {

  final Function()? onCompleted;
  const SetWorkPreferencesPage10({Key? key, this.onCompleted}) : super(key: key);

  @override
  SetWorkPreferencesPage10Controller createState() => SetWorkPreferencesPage10Controller();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SetWorkPreferencesPage10View extends WidgetView<SetWorkPreferencesPage10, SetWorkPreferencesPage10Controller> {

  const _SetWorkPreferencesPage10View(SetWorkPreferencesPage10Controller state) : super(state);

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
        body: BlocBuilder<CompanyCubit, CompanyState>(
          builder: (context, companyState) {

            return BlocBuilder<AuthCubit, AuthState>(
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
                    'What are your preferred industries?',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text('We recommend selecting up to 3 but you’re more than welcome to select more.',
                      style: TextStyle(fontSize: 14,color: theme.colorScheme.onPrimary,height: 1.4),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SeparatedColumn(separatorBuilder: (_,__){
                      return const  SizedBox(height: 16,);
                    },children: companyState.companyIndustries.map((industry) {

                      return jobIndustryWidget(theme, user, displayText: industry.name ?? '', value: industry);

                    }).toList(),)

                  ],
                );
              },
            );
          },
        )
    );

  }


  Widget jobIndustryWidget(ThemeData theme, UserModel user, {required String displayText, required CompanyIndustryModel value}) {

    return GestureDetector(
      onTap: () {
        state.updateJobCompanyIndustriesSetting(value, user.settings);
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
                    color: (user.settings?.jobPreferences?.industries?.contains(value.name) ?? false) ? kAppBlue : Colors.transparent,
                    border:  (user.settings?.jobPreferences?.industries?.contains(value.name) ?? false) ? null : Border.all(color: theme.colorScheme.onBackground)
                ),
                width: 25,
                height: 25,
                child: Checkbox(
                  value: (user.settings?.jobPreferences?.industries?.contains(value.name) ?? false),
                  onChanged: (v) => state.updateJobCompanyIndustriesSetting(value, user.settings),
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
              Expanded(child: Text(displayText, style: theme.textTheme.bodyMedium,)),
            ],
          )
      ),
    );
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SetWorkPreferencesPage10Controller extends State<SetWorkPreferencesPage10> {

  late AuthCubit authCubit;
  late CompanyCubit companyCubit;

  @override
  Widget build(BuildContext context) => _SetWorkPreferencesPage10View(this);

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
    companyCubit = context.read<CompanyCubit>();
    companyCubit.getCompanyIndustries();
  }


  void updateJobCompanyIndustriesSetting(CompanyIndustryModel industryModel, UserSettingsModel? settingsModel) {

    final List<String> existingCompanyIndustries= settingsModel?.jobPreferences?.industries ?? [];
    // if the type is already added remove, else add it
    if(existingCompanyIndustries.contains(industryModel.name)){
      existingCompanyIndustries.remove(industryModel.name);
    }else {
      existingCompanyIndustries.add(industryModel.name ?? '');
    }

    final updatedSettings = settingsModel?.copyWith(
        jobPreferences: (settingsModel.jobPreferences ?? const UserJobPreferenceModel()).copyWith(
          industries: existingCompanyIndustries,
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