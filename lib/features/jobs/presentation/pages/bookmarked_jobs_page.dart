import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/bookmarked_job_feeds_cubit.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_cubit.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_enums.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_state.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_model.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:showwcase_v3/features/jobs/presentation/widgets/job_item_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_shared_refresh_indicator.dart';

class BookmarkedJobsPage extends StatefulWidget {

  const BookmarkedJobsPage({Key? key}) : super(key: key);

  @override
  BookmarkedJobsPageController createState() => BookmarkedJobsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _BookmarkedJobsPageView extends WidgetView<BookmarkedJobsPage, BookmarkedJobsPageController> {

  const _BookmarkedJobsPageView(BookmarkedJobsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return CustomSharedRefreshIndicator(
      onRefresh: () async {
        final response = await state.fetchBookmarkedJobFeeds(0);
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
            return  ColoredBox(
              color: theme.brightness == Brightness.dark ? kAppCardDarkModeBackground : kAppWhite,
              child: BlocSelector<BookmarkedJobFeedsCubit, JobsState, JobModel?>(
                selector: (state) {
                  return state.jobs.firstWhere((element) => element.id == item.id);
                },
                builder: (context, job) {
                  return JobItemWidget(job: job ?? item, timeFormat: 'd MMM',containerName: 'bookmarked_jobs',);
                },
              )
              ,
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
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class BookmarkedJobsPageController extends State<BookmarkedJobsPage>  with AutomaticKeepAliveClientMixin{

  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, JobModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);
  late BookmarkedJobFeedsCubit bookmarkedJobFeedsCubit;
  late StreamSubscription<JobsState> jobsStateStreamSubscription;
  late JobsCubit jobsCubit;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _BookmarkedJobsPageView(this);
  }

  @override
  void initState() {
    bookmarkedJobFeedsCubit = context.read<BookmarkedJobFeedsCubit>();
    jobsCubit = context.read<JobsCubit>();
    pagingController.addPageRequestListener((pageKey) async {
      final response = await fetchBookmarkedJobFeeds(pageKey);
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

  Future<dartz.Either<String, List<JobModel>>> fetchBookmarkedJobFeeds(int pageKey, {int? manualSkip, int? manualLimit}) async {
    return await bookmarkedJobFeedsCubit.fetchBookmarkedJobs(pageKey, manualSkip: manualSkip, manualLimit: manualLimit);
  }

  void setJobCubitListener() {
    jobsStateStreamSubscription = jobsCubit.stream.listen((event) async {
      if(event.status == JobStatus.refreshBookmarks) {
        final response = await fetchBookmarkedJobFeeds(pagingController.firstPageKey, manualSkip: 0, manualLimit: event.jobs.length);
        if(response.isLeft()){
          return;
        }
        final jobs = response.asRight();
        pagingController.value = PagingState(
            nextPageKey: 1,
            itemList: jobs
        );

      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

}