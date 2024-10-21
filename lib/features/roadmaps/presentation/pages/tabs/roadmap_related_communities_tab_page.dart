import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_state.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/community_item_widget.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_related_communities_cubit.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';

import '../../../../../core/utils/constants.dart';
import '../../../data/models/roadmap_model.dart';

class RoadmapRelatedCommunitiesTabPage extends StatefulWidget {

  final RoadmapModel roadmapModel;
  const RoadmapRelatedCommunitiesTabPage({Key? key, required this.roadmapModel}) : super(key: key);

  @override
  RoadmapRelatedCommunitiesTabPageController createState() => RoadmapRelatedCommunitiesTabPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _RoadmapRelatedCommunitiesTabPageView extends WidgetView<RoadmapRelatedCommunitiesTabPage, RoadmapRelatedCommunitiesTabPageController> {

  const _RoadmapRelatedCommunitiesTabPageView(RoadmapRelatedCommunitiesTabPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    return PagedListView.separated(
      separatorBuilder: (ctx, i) {
        return const CustomBorderWidget();
      },
      pagingController: state.pagingController,
      builderDelegate: PagedChildBuilderDelegate<CommunityModel>(
        itemBuilder: (context, item, index) {
          //AnalyticsManager.communityImpressions(pageTitle: item.name!, pageName: 'see_more_active_community_page', communityId: item.id!, index: index, pageID:  item.id!,containerName: 'main');

          return BlocSelector<RoadmapRelatedCommunitiesCubit, CommunityState, CommunityModel>(
            selector: (state) {
              return state.communities.firstWhere((element) => element.id == item.id);
            },
            builder: (context, community) {
              return Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 15, right: 15),
                child: CommunityItemWidget(
                  key: ValueKey(item.id),
                  onTap: () {
                    context.push(context.generateRoutePath(subLocation: communityPreviewPage),extra: item);
                  }, community: community,
                  containerName: 'roadmap_related_communities',
                  pageName: 'roadmap_related_communities',
                ),
              );
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

    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class RoadmapRelatedCommunitiesTabPageController extends State<RoadmapRelatedCommunitiesTabPage> {

  late RoadmapRelatedCommunitiesCubit roadmapRelatedCommunitiesCubit ;
  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, CommunityModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);


  @override
  Widget build(BuildContext context) => _RoadmapRelatedCommunitiesTabPageView(this);

  @override
  void initState() {
    roadmapRelatedCommunitiesCubit = context.read<RoadmapRelatedCommunitiesCubit>();
    pagingController.addPageRequestListener((pageKey) async {
      final response = await fetchCommunities(pageKey);
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

  Future<dartz.Either<String, List<CommunityModel>>> fetchCommunities(int pageKey) async {
    return await roadmapRelatedCommunitiesCubit.fetchRoadmapRelatedCommunities(pageKey: pageKey, roadmapId: widget.roadmapModel.id!);
  }


  @override
  void dispose() {
    super.dispose();
  }

}