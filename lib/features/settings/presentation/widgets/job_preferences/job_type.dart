import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/jobs/presentation/widgets/job_type_item.dart';
import 'package:showwcase_v3/features/users/data/models/user_job_preference_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_settings_model.dart';

class JobType extends StatefulWidget {
  const JobType({Key? key}) : super(key: key);

  @override
  State<JobType> createState() => _JobTypeState();
}

class _JobTypeState extends State<JobType> {
  late AuthCubit _authCubit;
  late  UserModel user ;

  @override
  void initState() {
    _authCubit = context.read<AuthCubit>();
    user = AppStorage.currentUserSession!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthCubit, AuthState>(
      bloc: _authCubit,
      buildWhen: (_, next) {
        return next.status == AuthStatus.updateAuthUserSettingSuccessful
            || next.status == AuthStatus.updateAuthUserSettingFailed;
      },
      builder: (context, authState) {
        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              'Job Type',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 15,
                color: theme.colorScheme.onBackground,),
            ),
            tilePadding: EdgeInsets.zero,
            collapsedIconColor: theme.colorScheme.onBackground,
            iconColor: theme.colorScheme.onBackground,
            children: <Widget>[
              JopTypeItem(
                user: AppStorage.currentUserSession!,
                displayText: 'Full-time',
                value: 'full-time',
                onTap: () {
                  updateJobTypeSetting('full-time', user.settings);
                },
              ),
              const SizedBox(
                height: 16,
              ),
              JopTypeItem(
                user: AppStorage.currentUserSession!,
                displayText: 'Part-time',
                value: 'part-time',
                onTap: () {
                  updateJobTypeSetting('part-time', user.settings);
                },
              ),
              const SizedBox(
                height: 16,
              ),
              JopTypeItem(
                user: AppStorage.currentUserSession!,
                displayText: 'Contract',
                value: 'contract',
                onTap: () {
                  updateJobTypeSetting('contract', user.settings);
                },
              ),
              const SizedBox(
                height: 16,
              ),
              JopTypeItem(
                user: AppStorage.currentUserSession!,
                displayText: 'Freelance',
                value: 'freelance',
                onTap: () {
                  updateJobTypeSetting('freelance', user.settings);
                },
              ),
              const SizedBox(
                height: 16,
              ),
              JopTypeItem(
                user: AppStorage.currentUserSession!,
                displayText: 'Internship',
                value: 'internship',
                onTap: () {
                  updateJobTypeSetting('internship', user.settings);
                },
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ) ;
      },
    );
  }

  void updateJobTypeSetting(String type, UserSettingsModel? settingsModel) {
    final List<String> existingTypes = settingsModel?.jobPreferences?.types ?? [];
    // if the type is already added remove, else add it
    if (existingTypes.contains(type)) {
      existingTypes.remove(type);
    } else {
      existingTypes.add(type);
    }

    final updatedSettings = settingsModel?.copyWith(
      jobPreferences:
          (settingsModel.jobPreferences ?? const UserJobPreferenceModel())
              .copyWith(
        types: existingTypes,
      ),
    );

    _authCubit.updateAuthUserSetting(updatedSettings);
  }
}
