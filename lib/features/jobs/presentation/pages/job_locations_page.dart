import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_cubit.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_enums.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_state.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_circular_loader.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';

class JobLocationsPage extends StatefulWidget {

  const JobLocationsPage({Key? key,
  }) : super(key: key);

  @override
  State<JobLocationsPage> createState() => _JobLocationsPageState();
}

class _JobLocationsPageState extends State<JobLocationsPage> {

  @override
  void initState() {
    super.initState();
    context.read<JobsCubit>().fetchJobsFilters();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomInnerPageSliverAppBar(
            pageTitle: 'Job Locations',
            pinned: true,
          ),
          BlocBuilder<JobsCubit, JobsState>(
            buildWhen: (_, next) {
              return next.status == JobStatus.jobsFiltersFetchedSuccessful
                  || next.status == JobStatus.jobsFiltersFetchError
                  || next.status == JobStatus.jobsFiltersFetching;
            },
            builder: (context, jobsState) {
              if(jobsState.status == JobStatus.jobsFiltersFetching) {
                return const SliverFillRemaining(
                  child: Center(
                    child:  CustomCircularLoader(),
                  ),
                );
              }

              if(jobsState.status == JobStatus.jobsFiltersFetchError){
                return const SliverFillRemaining(
                  child: CustomEmptyContentWidget(title: "Sorry we couldn't fetch filters",),
                );
              }

              if(jobsState.status == JobStatus.jobsFiltersFetchedSuccessful && jobsState.jobFilters != null) {
                final locations = jobsState.jobFilters!.locations!;
                return SliverList(delegate: SliverChildListDelegate(
                              [
                      ...locations.map((skill) =>
                          BlocSelector<JobsCubit, JobsState, Map<String, dynamic>?>(
                            selector: (jobState) {
                              final mapIndex =  jobState.jobFilters!.locations!.indexWhere((element) => element["filter"] == skill["filter"]);
                              if(mapIndex >= 0){
                                final map = jobState.jobFilters!.locations![mapIndex];
                                return map;
                              }
                              return null;
                            },
                            builder: (context, filterItem) {
                              if(filterItem == null) return const SizedBox.shrink();
                              return CheckboxListTile(
                                  title: Text(
                                    filterItem["filter"] as String,
                                    style: TextStyle(
                                      color: theme.colorScheme.onBackground,
                                    ),
                                  ),
                                  value: (filterItem["selected"] as bool),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  activeColor: kAppBlue,
                                  checkColor: kAppWhite,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),

                                  onChanged: (value) {

                                    context.read<JobsCubit>().selectDeselectJobLocationFilter({
                                      "filter" : filterItem["filter"],
                                      "selected": value!
                                    });

                                  }
                              );
                            },
                          )
                      )

                    ]
                ));
              }

              return  const SliverToBoxAdapter(child: SizedBox.shrink(),);
            },
          )

        ],
      ),
    );
  }
}
