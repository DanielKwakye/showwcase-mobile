import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_shared_refresh_indicator.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_list_tile_widget.dart';

class CollaboratorsPage extends StatefulWidget {

  final UserModel userModel;
  const CollaboratorsPage({Key? key, required this.userModel}) : super(key: key);

  @override
  CollaboratorsPageController createState() => CollaboratorsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _CollaboratorsPageView extends WidgetView<CollaboratorsPage, CollaboratorsPageController> {

  const _CollaboratorsPageView(CollaboratorsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    // final theme = Theme.of(context);

    return CustomSharedRefreshIndicator(
      onRefresh: () async {
        final response = await state.fetchCollaborators(0);
        if(response.isLeft()){
          return;
        }
        final shows = response.asRight();
        state.pagingController.value = PagingState(
            nextPageKey: 1,
            itemList: shows
        );

      },
      child: PagedListView<int, UserModel>.separated(
        padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
        pagingController: state.pagingController,
        builderDelegate: PagedChildBuilderDelegate<UserModel>(
          itemBuilder: (context, item, index) {

            return BlocSelector<UserProfileCubit, UserProfileState, UserModel>(
              selector: (profileState) {
                return profileState.collaborators[widget.userModel.username!]!.firstWhere((element) => element.id == item.id);
              },
              builder: (context, user) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),

                  child: UserListTileWidget(
                    userModel: user, showFollowButton: true, showHeadLine: true,),
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
        separatorBuilder: (context, index) => const CustomBorderWidget(),
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class CollaboratorsPageController extends State<CollaboratorsPage> with AutomaticKeepAliveClientMixin {

  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, UserModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);
  late UserProfileCubit userProfileCubit;


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _CollaboratorsPageView(this);
  }

  @override
  void initState() {
    super.initState();
    userProfileCubit = context.read<UserProfileCubit>();
    pagingController.addPageRequestListener((pageKey) async {
      final response = await fetchCollaborators(pageKey);
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

  Future<dartz.Either<String, List<UserModel>>> fetchCollaborators(int pageKey) async {
    return await userProfileCubit.fetchUserCollaborators(user: widget.userModel, pageKey: pageKey);
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

}