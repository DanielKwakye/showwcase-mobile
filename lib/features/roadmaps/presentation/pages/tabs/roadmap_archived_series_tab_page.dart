import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_archived_series_cubit.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_state.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/series/presentation/widgets/series_item_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';

import '../../../../shared/presentation/widgets/custom_no_connection_widget.dart';
import '../../../data/models/roadmap_model.dart';

class RoadmapArchivedSeriesTabPage extends StatefulWidget {

  final RoadmapModel roadmapModel;
  const RoadmapArchivedSeriesTabPage({Key? key, required this.roadmapModel}) : super(key: key);

  @override
  RoadmapArchivedSeriesTabPageController createState() => RoadmapArchivedSeriesTabPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _RoadmapArchivedSeriesTabPageView extends WidgetView<RoadmapArchivedSeriesTabPage, RoadmapArchivedSeriesTabPageController> {

  const _RoadmapArchivedSeriesTabPageView(RoadmapArchivedSeriesTabPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return PagedListView<int, SeriesModel>.separated(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
      pagingController: state.pagingController,
      builderDelegate: PagedChildBuilderDelegate<SeriesModel>(
        itemBuilder: (context, item, index) {
          return Container(
              key: ValueKey(item.id),
              padding: const EdgeInsets.symmetric(horizontal: showSymmetricPadding, vertical: 10),
              color: theme.brightness == Brightness.dark ? kAppCardDarkModeBackground : kAppWhite,
              child: BlocSelector<RoadmapArchivedSeriesCubit, SeriesState, SeriesModel>(
                selector: (seriesState) {
                  return seriesState.series.firstWhere((element) => element.id == item.id);
                },
                builder: (context, updatedSeriesItem) {
                  return SeriesItemWidget(seriesItem: updatedSeriesItem, itemIndex: index, key: ValueKey(item.id),pageName: roadmapsPreviewPage,);
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
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class RoadmapArchivedSeriesTabPageController extends State<RoadmapArchivedSeriesTabPage> {

  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, SeriesModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);
  late RoadmapArchivedSeriesCubit roadmapArchivedSeriesCubit;

  @override
  Widget build(BuildContext context) => _RoadmapArchivedSeriesTabPageView(this);

  @override
  void initState() {

    roadmapArchivedSeriesCubit = context.read<RoadmapArchivedSeriesCubit>();
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
    return await roadmapArchivedSeriesCubit.fetchArchivedRoadmapSeriesCubit(pageKey: pageKey, roadmapId: widget.roadmapModel.id!);
  }


  @override
  void dispose() {
    super.dispose();
  }

}