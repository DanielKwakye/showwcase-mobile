import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/search/data/bloc/search_threads_cubit.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_state.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_item_widget.dart';

class SearchThreadsPage extends StatefulWidget {

  final String searchText;
  const SearchThreadsPage({Key? key, required this.searchText}) : super(key: key);

  @override
  SearchThreadsPageController createState() => SearchThreadsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SearchThreadsPageView extends WidgetView<SearchThreadsPage, SearchThreadsPageController> {

  const _SearchThreadsPageView(SearchThreadsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return PagedListView<int, ThreadModel>.separated(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
      pagingController: state.pagingController,
      builderDelegate: PagedChildBuilderDelegate<ThreadModel>(
        itemBuilder: (context, item, index) =>
            Container(
                key: ValueKey(item.id),
                color: theme.brightness == Brightness.dark ? kAppCardDarkModeBackground : kAppWhite,
                child: BlocSelector<SearchThreadsCubit, ThreadState, ThreadModel?>(
                  selector: (state) {return state.threads.firstWhereOrNull((element) => element.id == item.id);},
                  builder: (context, thread) {
                    return ThreadItemWidget(threadModel: thread ?? item,pageName: 'search_results_page',);
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
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SearchThreadsPageController extends State<SearchThreadsPage> {

  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, ThreadModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);
  late SearchThreadsCubit searchThreadsCubit;


  @override
  Widget build(BuildContext context) => _SearchThreadsPageView(this);

  @override
  void initState() {
    searchThreadsCubit = context.read<SearchThreadsCubit>();
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
    super.initState();
  }

  Future<dartz.Either<String, List<ThreadModel>>> fetchThreads(int pageKey) async {
    return await searchThreadsCubit.fetchSearchedThreads(pageKey: pageKey, searchWord: widget.searchText);
  }

  @override
  void dispose() {
    super.dispose();
  }

}