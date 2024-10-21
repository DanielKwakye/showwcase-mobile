import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/communities/data/bloc/drawer_communities_cubit.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';

class DrawerCommunitiesListWidget extends StatefulWidget {
  const DrawerCommunitiesListWidget({Key? key}) : super(key: key);

  @override
  State<DrawerCommunitiesListWidget> createState() =>
      _DrawerCommunitiesListWidgetState();
}

class _DrawerCommunitiesListWidgetState
    extends State<DrawerCommunitiesListWidget> {
  late DrawerCommunitiesCubit drawerCommunitiesCubit;
  final PagingController<int, CommunityModel> pagingController =
      PagingController(
          firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);

  @override
  void initState() {
    if (mounted) {
      drawerCommunitiesCubit = context.read<DrawerCommunitiesCubit>();
      pagingController.addPageRequestListener((pageKey) async {
        final response = await fetchCurrentUserCommunities(pageKey);
        if (response.isLeft()) {
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
    super.initState();
  }

  Future<dartz.Either<String, List<CommunityModel>>>
      fetchCurrentUserCommunities(int pageKey) async {
    final user = AppStorage.currentUserSession!;
    return await drawerCommunitiesCubit.fetchDrawerCommunities(
        userModel: user, pageKey: pageKey);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.only(right: 10),
          childrenPadding: EdgeInsets.zero,
          initiallyExpanded: true,
          title: Padding(
            // color: Colors.red,
            padding: const EdgeInsets.only(left: 24, right: 15),
            child: Text(
              "MY COMMUNITIES",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onPrimary),
            ),
          ),
          collapsedIconColor: theme.colorScheme.onBackground,
          iconColor: theme.colorScheme.onBackground,
          children: [
            PagedListView<int, CommunityModel>.separated(
              padding: const EdgeInsets.only(top: 0, left: 24, right: 20),
              pagingController: pagingController,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              builderDelegate: PagedChildBuilderDelegate<CommunityModel>(
                itemBuilder: (context, item, index) {
                  final icon = item.pictureKey != null
                      ? "${ApiConfig.profileUrl}/${item.pictureKey}"
                      : '';
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      context.push(
                          context.generateRoutePath(
                              subLocation: communityPreviewPage),
                          extra: item);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: theme.colorScheme.outline),
                                      borderRadius: BorderRadius.circular(5),
                                      color: theme.colorScheme.outline),
                                  child: icon.contains('.svg')
                                      ? SvgPicture.network(
                                          Uri.encodeFull(icon),
                                          placeholderBuilder:
                                              (BuildContext context) =>
                                                  _fallbackIcon(context,
                                                      item.name ?? 'Communities'),
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: Uri.encodeFull(icon),
                                          errorWidget: (context, url, error) =>
                                              _fallbackIcon(context,
                                                  item.name ?? 'Communities'),
                                          placeholder: (ctx, url) => _fallbackIcon(
                                              context, item.name ?? 'Communities'),
                                          cacheKey: item.pictureKey,
                                          fit: BoxFit.cover,
                                        ),

                                  // ,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (item.hasNewContent != null &&
                                            item.hasNewContent == true)
                                        ? Colors.red
                                        : Colors
                                            .transparent, // Replace this with the color you want for the badge
                                  ),
                                  // Add your badge content here if needed (e.g., an icon or text)
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                item.name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: theme.colorScheme.onBackground,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                firstPageProgressIndicatorBuilder: (_) => const Center(
                  child: CustomAdaptiveCircularIndicator(),
                ),
                newPageProgressIndicatorBuilder: (_) => const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: SizedBox(
                      height: 100,
                      width: double.maxFinite,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: CustomAdaptiveCircularIndicator(),
                      ),
                    )),
                noItemsFoundIndicatorBuilder: (_) => const SizedBox.shrink(),
                noMoreItemsIndicatorBuilder: (_) => const SizedBox.shrink(),
                firstPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
                newPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 10,),
            )
          ],
        ),
      ),
    );
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: <Widget>[
    //     const SizedBox(
    //       height: 10,
    //     ),
    //     Theme(
    //       data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    //       child:  ExpansionTile(
    //         tilePadding: const EdgeInsets.only(right: 10),
    //         childrenPadding: EdgeInsets.zero,
    //         initiallyExpanded: true,
    //         title: Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 20),
    //           child: Text(
    //             "MY COMMUNITIES",
    //             style: TextStyle(
    //                 fontSize: 12,
    //                 fontWeight: FontWeight.w700,
    //                 color: theme.colorScheme.onPrimary),
    //           ),
    //         ),
    //         collapsedIconColor: theme.colorScheme.onPrimary,
    //         iconColor: theme.colorScheme.onPrimary,
    //         children: <Widget>[
    //           // PagedListView<int, CommunityModel>.separated(
    //           //   padding: const EdgeInsets.only(top: 0,left: 20,right: 20),
    //           //   pagingController: pagingController,
    //           //   shrinkWrap: true,
    //           //   physics: const NeverScrollableScrollPhysics(),
    //           //   builderDelegate: PagedChildBuilderDelegate<CommunityModel>(
    //           //       firstPageProgressIndicatorBuilder: (ctx) => CustomAppShimmer(repeat: defaultPageSize,),
    //           //       noItemsFoundIndicatorBuilder: (ctx) => const SizedBox.shrink(),
    //           //       noMoreItemsIndicatorBuilder: (ctx) => const SizedBox.shrink(),
    //           //       newPageErrorIndicatorBuilder: (ctx) {
    //           //         return const SizedBox.shrink();
    //           //       },
    //           //       firstPageErrorIndicatorBuilder: (ctx) => GestureDetector(
    //           //           onVerticalDragDown: (_) => pagingController.refresh(),
    //           //           child: const CustomNoConnectionWidget(
    //           //             title: "Restore connection and swipe to refresh ...",)),
    //           //       newPageProgressIndicatorBuilder: (ctx) =>
    //           //       const CustomAppShimmer(),
    //           //       itemBuilder: (context, item, index) {
    //           //         final icon = item.pictureKey != null
    //           //             ? "${ApiConfig.profileUrl}/${item.pictureKey}"
    //           //             : '';
    //           //         return Padding(
    //           //           padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
    //           //           child: GestureDetector (
    //           //             behavior: HitTestBehavior.opaque,
    //           //             onTap: () {
    //           //               Navigator.pop(context);
    //           //             },
    //           //             child: Row(
    //           //               crossAxisAlignment: CrossAxisAlignment.start,
    //           //               mainAxisAlignment: MainAxisAlignment.center,
    //           //               children: [
    //           //                 Stack(
    //           //                   children: [
    //           //                     ClipRRect(
    //           //                       borderRadius: BorderRadius.circular(5),
    //           //                       child: Container(
    //           //                         width: 20,
    //           //                         height: 20,
    //           //                         decoration: BoxDecoration(
    //           //                             border: Border.all(
    //           //                                 color: theme.colorScheme.outline),
    //           //                             borderRadius: BorderRadius.circular(5),
    //           //                             color: theme.colorScheme.outline),
    //           //                         child: icon.contains('.svg')
    //           //                             ? SvgPicture.network(
    //           //                           Uri.encodeFull(icon),
    //           //                           placeholderBuilder:
    //           //                               (BuildContext context) => _fallbackIcon(context, item.name ?? 'Communities'),
    //           //                         )
    //           //                             : CachedNetworkImage(
    //           //                           imageUrl: Uri.encodeFull(icon),
    //           //                           errorWidget: (context, url, error) => _fallbackIcon(context, item.name ?? 'Communities'),
    //           //                           placeholder: (ctx, url) => _fallbackIcon(context, item.name ?? 'Communities'),
    //           //                           cacheKey: item.pictureKey,
    //           //                           fit: BoxFit.cover,
    //           //                         ),
    //           //
    //           //                         // ,
    //           //                       ),
    //           //                     ),
    //           //                     Positioned(
    //           //                       top: 0,
    //           //                       left: 0,
    //           //                       child: Container(
    //           //                         width: 6,
    //           //                         height: 6,
    //           //                         decoration: BoxDecoration(
    //           //                           shape: BoxShape.circle,
    //           //                           color: (item.hasNewContent != null && item.hasNewContent == true) ? Colors.red : Colors.transparent, // Replace this with the color you want for the badge
    //           //                         ),
    //           //                         // Add your badge content here if needed (e.g., an icon or text)
    //           //                       ),
    //           //                     ),
    //           //                   ],
    //           //                 ),
    //           //                 const SizedBox(
    //           //                   width: 10,
    //           //                 ),
    //           //                 Expanded(
    //           //                   child: Padding(
    //           //                     padding: const EdgeInsets.only(bottom: 8),
    //           //                     child: Text(
    //           //                       item.name ?? '',
    //           //                       style: TextStyle(
    //           //                           color: theme.colorScheme.onBackground,
    //           //                           fontSize: 12,
    //           //                           fontWeight: FontWeight.w600),
    //           //                     ),
    //           //                   ),
    //           //                 )
    //           //               ],
    //           //             ),
    //           //           ),
    //           //         );
    //           //       }
    //           //
    //           //   ),
    //           // ),
    //         ],
    //       ),
    //     )
    //   ],
    // );
    // return BlocConsumer<CommunityCubit, CommunityState>(
    //   buildWhen: (previousState, currentState) {
    //     return currentState.status == CommunityStatus.userCommunitiesSuccess;
    //   },
    //   listener: (BuildContext context, CommunityState state) {
    //     if (state.status == CommunityStatus.userCommunitiesError) {
    //       if (kTestingMode) {
    //         context.showSnackBar(state.message, appearance: Appearance.error);
    //       }
    //       pagingController.error = state.message;
    //     }
    //     if(state.status == CommunityStatus.userCommunitiesSuccess) {
    //       final userCommunities = state.userCommunities;
    //       // _fetchPage(userCommunities , _currentPageKey);
    //     }
    //   },
    //   bloc: _communityCubit,
    //   builder: (ctx, bloc) {
    //     return ;
    //   },
    // );
  }

  Widget _fallbackIcon(BuildContext context, String name) {
    return Center(
        child: Text(
      getInitials(name.toUpperCase()),
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground, fontSize: 10),
    ));
  }
}
