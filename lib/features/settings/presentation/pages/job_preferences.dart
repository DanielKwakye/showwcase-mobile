import 'package:flutter/material.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/utils/job_preferences_company_preference.dart';
import 'package:showwcase_v3/features/settings/presentation/widgets/job_preferences/job_preference_junior.dart';
import 'package:showwcase_v3/features/settings/presentation/widgets/job_preferences/job_preference_salary.dart';
import 'package:showwcase_v3/features/settings/presentation/widgets/job_preferences/job_preferences_industries.dart';
import 'package:showwcase_v3/features/settings/presentation/widgets/job_preferences/job_preferences_problem.dart';
import 'package:showwcase_v3/features/settings/presentation/widgets/job_preferences/job_preferences_role_attributes.dart';
import 'package:showwcase_v3/features/settings/presentation/widgets/job_preferences/job_preferences_status.dart';
import 'package:showwcase_v3/features/settings/presentation/widgets/job_preferences/job_preferences_teams.dart';
import 'package:showwcase_v3/features/settings/presentation/widgets/job_preferences/job_preferences_timezone.dart';
import 'package:showwcase_v3/features/settings/presentation/widgets/job_preferences/job_type.dart';
import 'package:showwcase_v3/features/settings/presentation/widgets/job_preferences/jobs_preference_role.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';

class JobPreferences extends StatefulWidget {
  const JobPreferences({super.key});

  @override
  State<JobPreferences> createState() => _JobPreferencesState();
}

class _JobPreferencesState extends State<JobPreferences> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return  [
              const CustomInnerPageSliverAppBar(pageTitle: "Job Preferences",)
            ] ;
          },
          body:  SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: SeparatedColumn(
              separatorBuilder: (BuildContext context, int index) {
                return const CustomBorderWidget();
              },
              children: const [
                Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: JobPreferencesStatus(),),
                Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: JobType(),),
                Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: JobsPreferenceRole(),),
                Padding(padding:  EdgeInsets.symmetric(horizontal: 20), child: JobPreferencesProblem(),),
                Padding(padding:  EdgeInsets.symmetric(horizontal: 20), child: JobPreferenceJunior(),),
                Padding(padding:  EdgeInsets.symmetric(horizontal: 20), child: JobPreferenceSalary(),),
                Padding(padding:  EdgeInsets.symmetric(horizontal: 20), child: JobPreferencesRoleAttribute(),),
                Padding(padding:  EdgeInsets.symmetric(horizontal: 20), child: JobPreferencesTimeZone(),),
                Padding(padding:  EdgeInsets.symmetric(horizontal: 20), child: JobPreferencesCompanyReference(),),
                Padding(padding:  EdgeInsets.symmetric(horizontal: 20), child: JobPreferenceIndustries(),),
                Padding(padding:  EdgeInsets.symmetric(horizontal: 20), child: JobPreferencesTeams(),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
