import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/job_feeds_cubit.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_cubit.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_enums.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_state.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_model.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_type_model.dart';
import 'package:showwcase_v3/features/jobs/presentation/widgets/job_filter_item_widget.dart';
import 'package:showwcase_v3/features/jobs/presentation/widgets/job_filter_panel_widget.dart';
import 'package:showwcase_v3/features/jobs/presentation/widgets/job_item_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_shared_refresh_indicator.dart';
import 'package:showwcase_v3/features/users/data/models/user_stack_model.dart';
import 'package:dartz/dartz.dart' as dartz;

class JobFeedsPage extends StatefulWidget {
  const JobFeedsPage({Key? key}) : super(key: key);

  @override
  JobFeedsPageController createState() => JobFeedsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _JobFeedsPageView
    extends WidgetView<JobFeedsPage, JobFeedsPageController> {
  const _JobFeedsPageView(JobFeedsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return NestedScrollView(
        headerSliverBuilder: (_, __) {
          return [
            /// Jobs Filter Section
            const SliverToBoxAdapter(
              child: JobFilterPanelWidget(),
            ),
            const SliverToBoxAdapter(
              child: CustomBorderWidget(),
            )
          ];
        },
        body: CustomSharedRefreshIndicator(
          onRefresh: () async {
            final response = await state.fetchJobFeeds(0);
            if(response.isLeft()){
              return;
            }
            final jobs = response.asRight();
            state.pagingController.value = PagingState(
                nextPageKey: 1,
                itemList: jobs
            );

          },
          child: PagedListView<int, JobModel>.separated(
            padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
            pagingController: state.pagingController,
            builderDelegate: PagedChildBuilderDelegate<JobModel>(
              itemBuilder: (context, item, index) {
                return BlocSelector<JobFeedsCubit, JobsState, JobModel>(
                  selector: (state) {
                    return state.jobs.firstWhere((element) => element.id == item.id);
                  },
                  builder: (context, show) {
                    return JobItemWidget(job: show, timeFormat: 'd MMM', containerName: 'jobs_feed',);
                  },
                );
              },
              firstPageProgressIndicatorBuilder: (_) => const Center(child: CustomAdaptiveCircularIndicator(),),
              newPageProgressIndicatorBuilder: (_) => const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: SizedBox(
                    height: 100, width: double.maxFinite,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: CustomAdaptiveCircularIndicator(),
                    ),
                  )),
              noItemsFoundIndicatorBuilder: (_) => const CustomEmptyContentWidget(),
              noMoreItemsIndicatorBuilder: (_) => const SizedBox.shrink(),
              firstPageErrorIndicatorBuilder: (_) => const CustomNoConnectionWidget(
                title:
                "Restore connection and swipe to refresh ...",
              ),
              newPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
            ),
            separatorBuilder: (context, index) => Container(
              height: 7,
              color: theme.brightness == Brightness.light ? theme.colorScheme.surface : theme.colorScheme.background,
            ),
          ),
        )
    );
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class JobFeedsPageController extends State<JobFeedsPage> with AutomaticKeepAliveClientMixin {
  late JobsCubit jobsCubit;
  late StreamSubscription<JobsState> jobsStateStreamSubscription;
  late JobFeedsCubit jobFeedsCubit;
  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, JobModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);

  @override
  void initState() {
    jobsCubit = context.read<JobsCubit>();
    jobFeedsCubit = context.read<JobFeedsCubit>();
    pagingController.addPageRequestListener((pageKey) async {
      final response = await fetchJobFeeds(pageKey);
      if(response.isLeft()){
        pagingController.error = response.asLeft();
        return;
      }
      final newItems = response.asRight();
      final isLastPage = newItems.isEmpty;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    });
    setJobCubitListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _JobFeedsPageView(this);
  }


  Future<dartz.Either<String, List<JobModel>>> fetchJobFeeds(int pageKey) async {
    // Check if filters are applied
    final salary = jobsCubit.state.salaryFilter;
    final jobFilters = jobsCubit.state.jobFilters;
    return await jobFeedsCubit.fetchJobsFeeds(pageKey: pageKey, jobFilters: jobFilters, salary: salary);
  }

  void setJobCubitListener() {
    jobsStateStreamSubscription = jobsCubit.stream.listen((event) {
      if(event.status == JobStatus.jobsFilterToggled) {
        pagingController.refresh();
      }
    });
  }

  @override
  void dispose() {
    jobsStateStreamSubscription.cancel();
    super.dispose();
  }



  @override
  bool get wantKeepAlive => true;
}
