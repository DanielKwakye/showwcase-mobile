import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/search/data/bloc/search_shows_cubit.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_state.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_item_widget.dart';

class SearchShowsPage extends StatefulWidget {

  final String searchText;
  const SearchShowsPage({Key? key, required this.searchText}) : super(key: key);

  @override
  SearchShowsPageController createState() => SearchShowsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SearchShowsPageView extends WidgetView<SearchShowsPage, SearchShowsPageController> {

  const _SearchShowsPageView(SearchShowsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return PagedListView<int, ShowModel>.separated(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
      pagingController: state.pagingController,
      builderDelegate: PagedChildBuilderDelegate<ShowModel>(
        itemBuilder: (context, item, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: showSymmetricPadding, vertical: 10),
            color: theme.brightness == Brightness.dark ? kAppCardDarkModeBackground : kAppWhite,
            child: BlocSelector<SearchShowsCubit, ShowsState, ShowModel>(
              selector: (state) {

                return state.shows.firstWhere((element) => element.id == item.id);
              },
              builder: (context, show) {
                return ShowItemWidget(showModel: show,pageName: 'searc',);
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
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SearchShowsPageController extends State<SearchShowsPage> {

  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, ShowModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);
  late SearchShowsCubit searchShowsCubit;

  @override
  Widget build(BuildContext context) => _SearchShowsPageView(this);

  @override
  void initState() {
    searchShowsCubit = context.read<SearchShowsCubit>();
    pagingController.addPageRequestListener((pageKey) async {
      final response = await fetchShows(pageKey);
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


  Future<dartz.Either<String, List<ShowModel>>> fetchShows(int pageKey) async {
    return await searchShowsCubit.fetchSearchedShows(pageKey: pageKey, searchWord: widget.searchText);
  }


  @override
  void dispose() {
    super.dispose();
  }

}