import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_contributors_cubit.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_list_tile_widget.dart';

import '../../../../shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import '../../../../shared/presentation/widgets/custom_emtpy_content_widget.dart';
import '../../../data/models/roadmap_model.dart';

class RoadmapContributorsTabPage extends StatefulWidget {

  final RoadmapModel roadmapModel;
  const RoadmapContributorsTabPage({Key? key, required this.roadmapModel}) : super(key: key);

  @override
  RoadmapContributorsTabPageController createState() => RoadmapContributorsTabPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _RoadmapContributorsTabPageView extends WidgetView<RoadmapContributorsTabPage, RoadmapContributorsTabPageController> {

  const _RoadmapContributorsTabPageView(RoadmapContributorsTabPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    return PagedListView<int, UserModel>.separated(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
      pagingController: state.pagingController,
      builderDelegate: PagedChildBuilderDelegate<UserModel>(
        itemBuilder: (context, item, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),

            child: UserListTileWidget(
              userModel: item, showFollowButton: true, showHeadLine: true,),
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
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class RoadmapContributorsTabPageController extends State<RoadmapContributorsTabPage> {

  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, UserModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);
  late RoadmapContributorsCubit roadmapContributorsCubit;

  @override
  Widget build(BuildContext context) => _RoadmapContributorsTabPageView(this);

  @override
  void initState() {
    roadmapContributorsCubit = context.read<RoadmapContributorsCubit>();
    pagingController.addPageRequestListener((pageKey) async {
      final response = await fetchUsers(pageKey);
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

  Future<dartz.Either<String, List<UserModel>>> fetchUsers(int pageKey) async {
    return await roadmapContributorsCubit.fetchRoadmapContributors( pageKey: pageKey, roadmapId: widget.roadmapModel.id!);
  }


  @override
  void dispose() {
    super.dispose();
  }

}