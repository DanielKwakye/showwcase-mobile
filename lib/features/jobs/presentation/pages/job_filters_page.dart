import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_cubit.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_enums.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_state.dart';
import 'package:showwcase_v3/features/jobs/presentation/widgets/salary_filter_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_circular_loader.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import '../../../../core/utils/widget_view.dart';

class JobFiltersPage extends StatefulWidget {

  const JobFiltersPage({Key? key}) : super(key: key);

  @override
  JobFiltersPageController createState() => JobFiltersPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _JobFiltersPageView extends WidgetView<JobFiltersPage, JobFiltersPageController> {

  const _JobFiltersPageView(JobFiltersPageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context).size ;

    return SizedBox(
      height: mediaQuery.height - 130,
      child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text('Filters', style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w600, fontSize: 14),),
              iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(1),
                child: CustomBorderWidget(),
              ),
            ),
            body: SafeArea(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  // Fetch Job Filters
                  BlocBuilder<JobsCubit, JobsState>(
                    buildWhen: (_, next) {
                      return next.status == JobStatus.jobsFiltersFetchedSuccessful
                          || next.status == JobStatus.jobsFiltersFetchError
                          || next.status == JobStatus.jobsFiltersFetching;
                    },
                    builder: (context, jobsState) {

                      if(jobsState.status == JobStatus.jobsFiltersFetching) {
                        return const SizedBox(
                          width: double.maxFinite,
                          height: 100,
                          child: Center(
                            child: CustomCircularLoader(),
                          ),
                        );
                      }

                      if(jobsState.status == JobStatus.jobsFiltersFetchError){
                        return const CustomEmptyContentWidget(title: "Sorry we couldn't fetch filters try again",);
                      }

                      // fetch was successful

                      if(jobsState.status == JobStatus.jobsFiltersFetchedSuccessful && jobsState.jobFilters != null){

                        return Column(
                          children: <Widget>[
                            /// positions filters
                            if(jobsState.jobFilters?.positions != null) ... {
                              ListTile(
                                minLeadingWidth : 10,
                                title: Text(
                                  'Positions',
                                  style: TextStyle(
                                      color: theme.colorScheme.onBackground,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                trailing: const Icon(Icons.keyboard_arrow_down),
                                onTap: () {
                                  context.push(context.generateRoutePath(subLocation: jobsPositionPage),);
                                },
                                subtitle: BlocBuilder<JobsCubit, JobsState>(
                                  builder: (context, jobsState) {

                                    final positions = jobsState.jobFilters!.positions!;
                                    final selectedCount = positions.where((element) => element['selected'] == true).length;

                                    if(selectedCount <= 0){
                                      return  Text(
                                        'No filters selected',
                                        style: TextStyle(
                                            color: theme.colorScheme.onPrimary,
                                            fontSize: defaultFontSize - 2),
                                      );
                                    }

                                    return Text(
                                      '$selectedCount filter(s) selected',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: defaultFontSize - 2),
                                    );
                                  },
                                  buildWhen: (_, next) {
                                    return next.status == JobStatus.jobsFilterToggled;
                                  },
                                ),
                              ),

                              const CustomBorderWidget()
                              // return JobPositionsPage(positions: jobsState.jobFilters!.positions!,);
                            },
                            /// locations filters
                            if(jobsState.jobFilters?.locations != null) ... {
                              ListTile(
                                minLeadingWidth : 10,
                                title: Text(
                                  'Locations',
                                  style: TextStyle(
                                      color: theme.colorScheme.onBackground,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                trailing: const Icon(Icons.keyboard_arrow_down),
                                onTap: () {
                                  context.push(context.generateRoutePath(subLocation: jobsLocationPage));
                                },
                                subtitle: BlocBuilder<JobsCubit, JobsState>(
                                  builder: (context, jobsState) {

                                    final locations = jobsState.jobFilters!.locations!;
                                    final selectedCount = locations.where((element) => element['selected'] == true).length;

                                    if(selectedCount <= 0){
                                      return  Text(
                                        'No filters selected',
                                        style: TextStyle(
                                            color: theme.colorScheme.onPrimary,
                                            fontSize: defaultFontSize - 2),
                                      );
                                    }

                                    return Text(
                                      '$selectedCount filter(s) selected',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: defaultFontSize - 2),
                                    );
                                  },
                                  buildWhen: (_, next) {
                                    return next.status == JobStatus.jobsFilterToggled;
                                  },
                                ),
                              ),

                              const CustomBorderWidget()
                              // return JobPositionsPage(positions: jobsState.jobFilters!.positions!,);
                            },
                            /// Types filters
                            if(jobsState.jobFilters?.types != null) ... {
                              ListTile(
                                minLeadingWidth : 10,
                                title: Text(
                                  'Job type',
                                  style: TextStyle(
                                      color: theme.colorScheme.onBackground,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                trailing: const Icon(Icons.keyboard_arrow_down),
                                onTap: () {
                                  // Navigator.of(context).push(MaterialPageRoute(builder: (_)
                                  // => JobTypesPage(jobTypes: jobsState.jobFilters!.types!),settings: const RouteSettings(arguments: {'page_title':'jobs_type'}),
                                  // ));
                                  context.push(context.generateRoutePath(subLocation: jobsTypesPage));
                                },
                                subtitle: BlocBuilder<JobsCubit, JobsState>(
                                  builder: (context, jobsState) {

                                    final types = jobsState.jobFilters!.types!;
                                    final selectedCount = types.where((element) => element['selected'] == true).length;

                                    if(selectedCount <= 0){
                                      return  Text(
                                        'No filters selected',
                                        style: TextStyle(
                                            color: theme.colorScheme.onPrimary,
                                            fontSize: defaultFontSize - 2),
                                      );
                                    }

                                    return Text(
                                      '$selectedCount filter(s) selected',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: defaultFontSize - 2),
                                    );
                                  },
                                  buildWhen: (_, next) {
                                    return next.status == JobStatus.jobsFilterToggled;
                                  },
                                ),
                              ),

                              const CustomBorderWidget()
                              // return JobPositionsPage(positions: jobsState.jobFilters!.positions!,);
                            },
                            /// Stacks filters
                            if(jobsState.jobFilters?.stacks != null) ... {
                              ListTile(
                                minLeadingWidth : 10,
                                title: Text(
                                  'Tech Stack',
                                  style: TextStyle(
                                      color: theme.colorScheme.onBackground,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                trailing: const Icon(Icons.keyboard_arrow_down),
                                onTap: () {
                                  // Navigator.of(context).push(MaterialPageRoute(builder: (_)
                                  // => JobStacksPage(jobStacks: jobsState.jobFilters!.stacks!),settings: const RouteSettings(arguments: {'page_title':'jobs_stacks'}),
                                  // ));
                                  context.push(context.generateRoutePath(subLocation: jobsTechStackPage));
                                },
                                subtitle: BlocBuilder<JobsCubit, JobsState>(
                                  builder: (context, jobsState) {

                                    final stacks = jobsState.jobFilters!.stacks!;
                                    final selectedCount = stacks.where((element) => element['selected'] == true).length;

                                    if(selectedCount <= 0){
                                      return Text(
                                        'No filters selected',
                                        style: TextStyle(
                                            color: theme.colorScheme.onPrimary,
                                            fontSize: defaultFontSize - 2),
                                      );
                                    }

                                    return Text(
                                      '$selectedCount filter(s) selected',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: defaultFontSize - 2),
                                    );
                                  },
                                  buildWhen: (_, next) {
                                    return next.status == JobStatus.jobsFilterToggled;
                                  },
                                ),

                              ),

                              const CustomBorderWidget()
                            },

                            /// Salary filter
                            const SalaryFilterWidget()

                          ],
                        );

                      }

                      return const SizedBox.shrink();

                    },
                  ),

                ],
              ),
            ),
          ),
    );
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class JobFiltersPageController extends State<JobFiltersPage> {

  late JobsCubit jobsCubit;

  @override
  initState(){
    super.initState();
    jobsCubit = context.read<JobsCubit>();
    jobsCubit.fetchJobsFilters();
  }

  @override
  Widget build(BuildContext context) => _JobFiltersPageView(this);

}