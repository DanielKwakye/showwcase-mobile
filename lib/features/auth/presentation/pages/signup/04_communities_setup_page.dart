import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_state.dart';
import 'package:showwcase_v3/features/communities/data/bloc/suggested_communities_cubit.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/community_item_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_shared_refresh_indicator.dart';

class CommunitiesSetupPage extends StatefulWidget {

  final Function()? onCompleted;
  const CommunitiesSetupPage({Key? key, this.onCompleted}) : super(key: key);

  @override
  CommunitiesSetupController createState() => CommunitiesSetupController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _CommunitiesSetupView extends WidgetView<CommunitiesSetupPage, CommunitiesSetupController> {

  const _CommunitiesSetupView(CommunitiesSetupController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
        bottomNavigationBar: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            return BlocBuilder<CommunityCubit, CommunityState>(
                  builder: (context, communityState) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                      child: CustomButtonWidget(
                        expand: true,
                        loading: authState.status == AuthStatus.markOnboardingAsCompleteInProgress,
                        // disabled: communityState.communitiesOfInterest.where((element) => element?.isMember == true).length < 5,
                        onPressed: state.handleCommunitySetupComplete, text: 'Complete',
                      ),
                    );
                  },
                );
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
              child: Text(
                'Select 5 relevant communities to get started',
                style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onPrimary,
                    height: 1.4),
              ),
            ),

            const CustomBorderWidget(),
            Expanded(
              child: CustomSharedRefreshIndicator(
                onRefresh: () async {
                  final response = await state.fetchCommunities(0);
                  if(response.isLeft()){
                    return;
                  }
                  final communities = response.asRight();
                  state.pagingController.value = PagingState(
                      nextPageKey: 1,
                      itemList: communities
                  );

                },
                child: PagedListView<int, CommunityModel>.separated(
                  padding: const EdgeInsets.only(top: 0,left: 0,right: 0),
                  pagingController: state.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<CommunityModel>(
                    itemBuilder: (context, item, index) {

                        return BlocSelector<SuggestedCommunitiesCubit, CommunityState, CommunityModel>(
                          selector: (state) {
                            return state.communities.firstWhere((element) => element.id == item.id);
                          },
                          builder: (context, community) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 15,right: 15),
                              child: CommunityItemWidget(
                                key: ValueKey(item.id),
                                onTap: () {}, community: community,
                                pageName: 'community_onboarding',
                                containerName: 'main',
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
                  separatorBuilder: (context, index) => const CustomBorderWidget(),
                ),
              )

              // BlocBuilder<CommunityCubit, CommunityState>(
              //   buildWhen: (_, next){
              //     return next.status == CommunityStatus.fetchSuggestedCommunitiesSuccessful
              //         || next.status == CommunityStatus.fetchSuggestedCommunitiesInProgress
              //         || next.status == CommunityStatus.fetchSuggestedCommunitiesFailed;
              //   },
              //   builder: (context, communityState) {
              //
              //     if(communityState.status == CommunityStatus.fetchSuggestedCommunitiesInProgress) {
              //       return const Align(
              //         alignment: Alignment.topCenter,
              //         child: Padding(
              //             padding: EdgeInsets.only(top: 20),
              //           child: CircularProgressIndicator(color: kAppBlue, strokeWidth: 2,),
              //         ),
              //       );
              //     }
              //
              //     if(communityState.status == CommunityStatus.fetchSuggestedCommunitiesSuccessful) {
              //       if(communityState.suggestedCommunities.isEmpty){
              //         return const CustomEmptyContentWidget();
              //       }
              //       return ListView.separated(
              //         padding: const EdgeInsets.only(top: 0,left: 15,right: 15),
              //         separatorBuilder: (ctx, i) {
              //           return const CustomBorderWidget();
              //         },
              //         itemBuilder: (BuildContext context, int index) {
              //           final communityModel = communityState.suggestedCommunities[index];
              //           return Padding(
              //             padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              //             child: CommunityItemWidget(
              //               key: ValueKey(communityModel!.id),
              //               communityModel: communityModel,
              //             ),
              //           );
              //         }, itemCount: communityState.suggestedCommunities.length,
              //       );
              //     }
              //
              //     return const SizedBox.shrink();
              //   },
              // ),
            ),
          ],
        )
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class CommunitiesSetupController extends State<CommunitiesSetupPage> {


  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, CommunityModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);
  late SuggestedCommunitiesCubit suggestedCommunitiesCubit;

  @override
  Widget build(BuildContext context) => _CommunitiesSetupView(this);

  @override
  void initState() {
    super.initState();
    suggestedCommunitiesCubit = context.read<SuggestedCommunitiesCubit>();
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

  }

  void handleCommunitySetupComplete() {
    widget.onCompleted?.call();
  }

  Future<dartz.Either<String, List<CommunityModel>>> fetchCommunities(int pageKey) async {
    return await suggestedCommunitiesCubit.fetchSuggestedCommunities(pageKey: pageKey);
  }

  @override
  void dispose() {
    super.dispose();
  }

}