import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_shared_refresh_indicator.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_poll_voters_cubit.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_voter_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_list_tile_widget.dart';

class ThreadPollVotersPage extends StatefulWidget {

  final ThreadModel thread;
  const ThreadPollVotersPage({Key? key, required this.thread}) : super(key: key);

  @override
  ThreadVotersPageController createState() => ThreadVotersPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ThreadVotersPageView extends WidgetView<ThreadPollVotersPage, ThreadVotersPageController> {

  const _ThreadVotersPageView(ThreadVotersPageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              centerTitle: true,
              pinned: true,
              automaticallyImplyLeading: false,
              backgroundColor: theme.colorScheme.primary,
              elevation: 0,
              title: Text("Voters", style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w700,fontSize: defaultFontSize ),),
              iconTheme: const IconThemeData(color: kAppWhite),
              actions: [
                CloseButton(
                  color: theme.colorScheme.onBackground,
                )
              ],
              bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: CustomBorderWidget()
              ),
            )
          ];
        }, body: CustomSharedRefreshIndicator(
          onRefresh: () async {
            final response = await state.fetchVoters(0);
            if(response.isLeft()){
              return;
            }
            final threads = response.asRight();
            state.pagingController.value = PagingState(nextPageKey: 1, itemList: threads);

          },
          child: PagedListView<int, ThreadVoterModel>.separated(
            padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
            pagingController: state.pagingController,
            builderDelegate: PagedChildBuilderDelegate<ThreadVoterModel>(
              itemBuilder: (context, item, index) {
                final options = widget.thread.poll?.options;
                final selectedOption = options?.where((element) => element.id == item.option?['id'] as int? ).firstOrNull;

                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: UserListTileWidget(userModel: item.user!, subTitleText: selectedOption?.option,),
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
            separatorBuilder: (context, index) => const CustomBorderWidget(),
          ),
        ),)
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ThreadVotersPageController extends State<ThreadPollVotersPage> {

  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, ThreadVoterModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);
  late ThreadPollVotersCubit cubit;

  @override
  Widget build(BuildContext context) => _ThreadVotersPageView(this);

  @override
  void initState() {
    super.initState();
    cubit = context.read<ThreadPollVotersCubit>();
    pagingController.addPageRequestListener((pageKey) async {
      final response = await fetchVoters(pageKey);
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

  Future<dartz.Either<String, List<ThreadVoterModel>>> fetchVoters(int pageKey) async {
    return await cubit.fetchThreadPollVoters(pageKey: pageKey, thread: widget.thread);
  }


  @override
  void dispose() {
    super.dispose();
  }

}