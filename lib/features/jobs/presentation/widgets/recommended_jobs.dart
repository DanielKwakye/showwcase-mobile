import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_cubit.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_enums.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_state.dart';
import 'package:showwcase_v3/features/jobs/presentation/widgets/job_item_widget.dart';

class RecommendedJobs extends StatefulWidget {
  const RecommendedJobs({super.key});

  @override
  State<RecommendedJobs> createState() => _RecommendedJobsState();
}

class _RecommendedJobsState extends State<RecommendedJobs> with AutomaticKeepAliveClientMixin{
  late JobsCubit jobsCubit ;
  @override
  void initState() {
  jobsCubit  = context.read<JobsCubit>();
  // jobsCubit.fetchRecommendedJobs(
  //     limit: 3, replaceFirstPage: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        /// Recommended Jobs Section Header
        BlocBuilder<JobsCubit, JobsState>(
          bloc: jobsCubit,
          buildWhen: (_, next){
            return next.status == JobStatus.jobsFetchedSuccessful;
          },
          builder: (context, jobState) {
            return BlocBuilder<JobsCubit, JobsState>(
              bloc: jobsCubit,
              buildWhen: (_, localJobState) {
                return localJobState.status == JobStatus.recommendedJobsFetchingSuccessful;
              },
              builder: (context, localJobState) {
                if(localJobState.status == JobStatus.recommendedJobsFetchingSuccessful
                    && localJobState.jobs.isNotEmpty
                ){
                  return GestureDetector(
                    onTap: () {
                     // changeScreenWithConstructor(context, const RecommendedJobsPage());
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: theme(context).colorScheme.onPrimary.withOpacity(0.1),width: 8)
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Recommended for you', style: TextStyle(color: theme(context).colorScheme.onBackground,fontWeight: FontWeight.w700),),
                            const Text('See more', style: TextStyle(color: kAppBlue),),
                          ],
                        )
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            );

          },
        ),

        /// Recommended jobs section (limited)
        BlocBuilder<JobsCubit, JobsState>(
          bloc: jobsCubit,
          buildWhen: (_, next){
            return next.status == JobStatus.jobsFetchedSuccessful;
          },
          builder: (context, jobState) {
            return BlocBuilder<JobsCubit, JobsState>(
              bloc: jobsCubit,
              buildWhen: (_, localJobState) {
                return localJobState.status == JobStatus.recommendedJobsFetchingSuccessful;
              },
              builder: (context, localJobState) {

                if(localJobState.status == JobStatus.recommendedJobsFetchingSuccessful) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: localJobState.jobs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final job = localJobState.jobs[index];
                          return JobItemWidget(job: job, timeFormat: 'd MMM',containerName: 'recommended_job_list',);
                        },
                      );
                }
                return const SizedBox.shrink();

              },
            );
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
