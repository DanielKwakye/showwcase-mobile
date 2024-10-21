import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_shared_refresh_indicator.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_enums.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_state.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_item_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/profile_threads_cubit.dart';

class ProfileThreadFeed extends StatefulWidget {
  final String username;
  const ProfileThreadFeed({Key? key, required this.username}) : super(key: key);

  @override
  BookmarkThreadFeedsPageController createState() => BookmarkThreadFeedsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _BookmarkThreadFeedsPageView extends WidgetView<ProfileThreadFeed, BookmarkThreadFeedsPageController> {

  const _BookmarkThreadFeedsPageView(BookmarkThreadFeedsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return BlocListener<ProfileThreadsCubit, ThreadState>(
      listenWhen: (_, next){
        return next.status == ThreadStatus.refreshThreadsCompleted;
      },
      listener: (context, threadState) {
        if(threadState.status  == ThreadStatus.refreshThreadsCompleted){
          state.pagingController.itemList = threadState.threads;
        }
      },
      child: CustomSharedRefreshIndicator(
        onRefresh: () async {
          final response = await state.fetchThreads(0);
          if(response.isLeft()){
            return;
          }
          final threads = response.asRight();
          state.pagingController.value = PagingState(
              nextPageKey: 1,
              itemList: threads
          );

        },
        child: PagedListView<int, ThreadModel>.separated(
          padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
          pagingController: state.pagingController,
          builderDelegate: PagedChildBuilderDelegate<ThreadModel>(
            itemBuilder: (context, item, index) =>
                Container(
                    key: ValueKey(item.id),
                    color: theme.brightness == Brightness.dark ? kAppCardDarkModeBackground : kAppWhite,
                    child: BlocSelector<ProfileThreadsCubit, ThreadState, ThreadModel?>(
                      selector: (state) {return state.threads.firstWhereOrNull((element) => element.id == item.id);},
                      builder: (context, thread) {
                        return ThreadItemWidget(threadModel: thread ?? item,pageName: checksEqual(widget.username, AppStorage.currentUserSession!.username!) ? personalProfilePage : publicProfilePage,);
                      },
                    )
                ),
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
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class BookmarkThreadFeedsPageController extends State<ProfileThreadFeed> {

  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, ThreadModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);
  late ProfileThreadsCubit threadCubit;

  @override
  Widget build(BuildContext context) => _BookmarkThreadFeedsPageView(this);

  @override
  void initState() {
    super.initState();
    threadCubit = context.read<ProfileThreadsCubit>();
    pagingController.addPageRequestListener((pageKey) async {
      final response = await fetchThreads(pageKey);
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
  }


  Future<dartz.Either<String, List<ThreadModel>>> fetchThreads(int pageKey) async {
    return await threadCubit.fetchThreadFeeds(pageKey,widget.username);
  }

  @override
  void dispose() {
    // pagingController.dispose();
    super.dispose();
  }

}