import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_cubit.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_enums.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_state.dart';
import 'package:showwcase_v3/features/jobs/presentation/widgets/job_item_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';

class MainJobs extends StatefulWidget {
  const MainJobs({super.key});

  @override
  State<MainJobs> createState() => _MainJobsState();
}

class _MainJobsState extends State<MainJobs> with AutomaticKeepAliveClientMixin{

  late JobsCubit jobsCubit ;
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    jobsCubit  = context.read<JobsCubit>();
    //jobsCubit.fetchNewJobs(replaceFirstPage: true,);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
     // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// New Jobs Section Header
        BlocBuilder<JobsCubit, JobsState>(
          bloc: jobsCubit,
          buildWhen: (_, next){
            return next.status == JobStatus.jobsFetchedSuccessful;
          },
          builder: (context, jobState) {
            return BlocBuilder<JobsCubit, JobsState>(
              bloc: jobsCubit,
              buildWhen: (_, next) {
                return next.status == JobStatus.jobsFetchedSuccessful;
              },
              builder: (context, localJobsState) {
                if(localJobsState.status == JobStatus.jobsFetchedSuccessful) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: theme(context).colorScheme.onPrimary.withOpacity(0.1),width: 8)
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Text('New  Jobs', style: TextStyle(color: theme(context).colorScheme.onBackground,fontWeight: FontWeight.w700),),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),

        /// Main Job List Bode below ---------------------------
        BlocBuilder<JobsCubit, JobsState>(
          buildWhen: (_, next) {
            return next.status == JobStatus.jobsFetchedSuccessful
                || next.status == JobStatus.jobsFetchUpdatingFilters
                || next.status ==  JobStatus.jobsFetchError;
          },
          builder: (context, jobState) {

            switch (jobState.status) {

              case JobStatus.jobsFilterToggled:
              case JobStatus.jobsFetchUpdatingFilters:
                return const SizedBox.shrink();

              case JobStatus.jobsFetchError:
                return const CustomEmptyContentWidget();

              case JobStatus.jobsFetchedSuccessful:
                if (jobState.jobs.isEmpty) {
                  return const SingleChildScrollView(
                    child: CustomEmptyContentWidget(
                        title: "No jobs found!"
                    ),
                  );
                }
                return NotificationListener(
                  onNotification: (ScrollNotification scrollInfo) {
                    _onScroll();
                    return false;
                  },
                  child: ListView.builder(
                    key: const PageStorageKey('jobs'),
                    shrinkWrap: true,
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    itemCount:  jobState.jobs.length,
                    itemBuilder: (BuildContext context, int index) {

                      if (index >= jobState.jobs.length) {
                        return const SizedBox(
                          height: 100,
                          child: Align(
                            alignment: Alignment.center,
                            child: CupertinoActivityIndicator(),
                          ),
                        );
                      }

                      final job = jobState.jobs[index];

                      if(job.title!.isNullOrEmpty()) {
                        return const SizedBox.shrink();
                      }
                     // AnalyticsManager.jobImpression(pageName: 'jobs_page', jobId: job.id!,index: index, pageTitle: job.title!,containerName: 'main_job_list');


                      return JobItemWidget(job: job,containerName: 'main_job_list',);
                    },),
                );
              default:
                return const SizedBox.shrink();
            }
          },
        )
      ],
    );
  }

  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }


  void _onScroll() {
    if (_isBottom) {
      /// we use debouncer because _onScroll is called multiple times
      EasyDebounce.debounce(
          'jobs-debouncer', // <-- An ID for this particular debouncer
          const Duration(milliseconds: 500), // <-- The debounce duration
              () {
           // jobsCubit.fetchNewJobs(replaceFirstPage: false, isScrolling: true);
          }
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
