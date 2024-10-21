import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_feeds_cubit.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_state.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/series/presentation/widgets/series_item_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_shared_refresh_indicator.dart';

class SeriesFeedsPage extends StatefulWidget {

  const SeriesFeedsPage({Key? key}) : super(key: key);

  @override
  SeriesFeedsPageController createState() => SeriesFeedsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SeriesFeedsPageView extends WidgetView<SeriesFeedsPage, SeriesFeedsPageController> {

  const _SeriesFeedsPageView(SeriesFeedsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      bottom: true,
      child: CustomSharedRefreshIndicator(
        onRefresh: () async {
          final response = await state.fetchSeriesFeeds(0);
          if(response.isLeft()){
            return;
          }
          final shows = response.asRight();
          state.pagingController.value = PagingState(
              nextPageKey: 1,
              itemList: shows
          );

        },
        child: PagedListView<int, SeriesModel>.separated(
          padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
          pagingController: state.pagingController,
          builderDelegate: PagedChildBuilderDelegate<SeriesModel>(
            itemBuilder: (context, item, index) {
              return Container(
                key: ValueKey(item.id),
                padding: const EdgeInsets.symmetric(horizontal: showSymmetricPadding, vertical: 10),
                color: theme.brightness == Brightness.dark ? kAppCardDarkModeBackground : kAppWhite,
                child: BlocSelector<SeriesFeedsCubit, SeriesState, SeriesModel>(
                  selector: (seriesState) {
                    return seriesState.series.firstWhere((element) => element.id == item.id);
                  },
                  builder: (context, updatedSeriesItem) {
                    return SeriesItemWidget(seriesItem: updatedSeriesItem, itemIndex: index, key: ValueKey(item.id),pageName: shows,);
                  },
                )

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
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SeriesFeedsPageController extends State<SeriesFeedsPage> with AutomaticKeepAliveClientMixin {

  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, SeriesModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);
  late SeriesFeedsCubit seriesFeedsCubit;
  // late StreamSubscription<ShowsState> showStateStreamSubscription;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _SeriesFeedsPageView(this);
  }

  @override
  void initState() {
    seriesFeedsCubit = context.read<SeriesFeedsCubit>();
    pagingController.addPageRequestListener((pageKey) async {
      final response = await fetchSeriesFeeds(pageKey);
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


  Future<dartz.Either<String, List<SeriesModel>>> fetchSeriesFeeds(int pageKey) async {
    return await seriesFeedsCubit.fetchSeriesFeeds(pageKey);
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

}