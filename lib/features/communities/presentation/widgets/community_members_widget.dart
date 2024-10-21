import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_members_cubit.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class CommunityMembersWidget extends StatefulWidget {
  final CommunityModel communityModel;

  const CommunityMembersWidget({Key? key, required this.communityModel}) : super(key: key);

  @override
  CommunityMembersWidgetController createState() => CommunityMembersWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class CommunityMembersWidgetView extends WidgetView<CommunityMembersWidget, CommunityMembersWidgetController> {

  const CommunityMembersWidgetView(CommunityMembersWidgetController state, {super.key}) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PagedSliverList<int, UserModel>.separated(
      // padding: const EdgeInsets.only(top: 10, left: 15, right:15),
      pagingController: state.pagingController,
      builderDelegate: PagedChildBuilderDelegate<UserModel>(
        itemBuilder: (context, item, index) =>
            GestureDetector(
              onTap: () {
                pushToProfile(context, user: item);
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                  key: ValueKey(item.id),
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomUserAvatarWidget(
                        size: 32,
                        username: item.username,
                        networkImage:
                        item.profilePictureKey ?? '',
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${item.displayName}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        '${item.activity?.emoji ?? ''} '),
                                    // if (item.isOwner != null && item.isOwner == true) ...{
                                    //   const SizedBox(
                                    //     width: 5,
                                    //   ),
                                    //   Container(
                                    //     decoration: BoxDecoration(
                                    //         color: kAppBlue,
                                    //         borderRadius:
                                    //         BorderRadius.circular(
                                    //             5)),
                                    //     padding:
                                    //     const EdgeInsets.symmetric(
                                    //         horizontal: 5,
                                    //         vertical: 3),
                                    //     child: const Text(
                                    //       'Owner',
                                    //       style: TextStyle(
                                    //           color: Colors.white),
                                    //     ),
                                    //   )
                                    // },
                                    // if (item.communityRole != null && checksNotEqual(item.communityRole?.name ?? '', 'Member'))...{
                                    //   const SizedBox(
                                    //     width: 5,
                                    //   ),
                                    //   Container(
                                    //     decoration: BoxDecoration(
                                    //         color: Color(int.parse('0xff${item.communityRole?.color?.substring(1)}')),
                                    //         borderRadius:
                                    //         BorderRadius.circular(
                                    //             5)),
                                    //     padding:
                                    //     const EdgeInsets.symmetric(
                                    //         horizontal: 5,
                                    //         vertical: 3),
                                    //     child:  Text(
                                    //       item.communityRole?.name ?? '',
                                    //       style: const TextStyle(
                                    //           color: Colors.white),
                                    //     ),
                                    //   )
                                    // },

                                  ],
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  '@${item.username ?? ''}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color:
                                      theme.colorScheme.onPrimary),
                                ),
                              ],
                            ),
                            // if (item.isAdmin == null || item.isAdmin == false)
                            //   IconButton(
                            //     onPressed: () {
                            //       communitiesMembersAction(
                            //           context: context, theme: theme,networkResponse: item);
                            //     },
                            //     icon: Icon(Icons.edit_outlined,
                            //         size: 15,
                            //         color: theme.colorScheme.onPrimary),
                            //   )
                          ],
                        ),
                      )
                    ],
                  )
              ),
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
      ), separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 20,);
    },
      // separatorBuilder: (context, index) => Container(
      //   height: 7,
      //   color: theme.brightness == Brightness.light ? theme.colorScheme.surface : theme.colorScheme.background,
      // ),
    );
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class CommunityMembersWidgetController extends State<CommunityMembersWidget> {
  
  // page key is page index. Starting from 0, 1, 2 .........
  late PagingController<int, UserModel> pagingController  = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);
  late CommunityMembersCubit communityMembersCubit;
  
  @override
  Widget build(BuildContext context) => CommunityMembersWidgetView(this);

  @override
  void initState() {
    super.initState();
    communityMembersCubit = context.read<CommunityMembersCubit>();
    pagingController.addPageRequestListener((pageKey) async {
      final response = await fetchCommunityMembers(pageKey);
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

  Future<dartz.Either<String, List<UserModel>>> fetchCommunityMembers(int pageKey) async {
    return await communityMembersCubit.fetchCommunityMembers(pageKey: pageKey, communityId: widget.communityModel.id!);
  }


}