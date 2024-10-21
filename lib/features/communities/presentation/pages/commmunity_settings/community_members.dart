import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_admin_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_members_cubit.dart';
import 'package:showwcase_v3/features/communities/data/models/community_admin_role.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class CommunityMembers extends StatefulWidget {
  final CommunityModel communityModel;

  const CommunityMembers({Key? key, required this.communityModel})
      : super(key: key);

  @override
  CommunityMembersController createState() => CommunityMembersController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class CommunityMembersWidgetView
    extends WidgetView<CommunityMembers, CommunityMembersController> {
  const CommunityMembersWidgetView(CommunityMembersController state,
      {super.key})
      : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<CommunityAdminCubit, CommunityAdminState>(
      listener: (context, state) {
        if (state is AddRolesLoading) {}
        if (state is AddRolesSuccess) {}
        if (state is AddRolesError) {}
        if (state is CommunityRolesSuccess) {
          state.rolesResponse.addAll(state.rolesResponse);
        }
      },
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              const CustomInnerPageSliverAppBar(
                pageTitle: "Members",
              )
            ];
          },
          body: PagedListView<int, UserModel>.separated(
            // padding: const EdgeInsets.only(top: 10, left: 15, right:15),
            padding: const EdgeInsets.only(top: 10),
            pagingController: state.pagingController,
            builderDelegate: PagedChildBuilderDelegate<UserModel>(
              itemBuilder: (context, item, index) => GestureDetector(
                onTap: () {
                  pushToProfile(context, user: item);
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                    key: ValueKey(item.id),
                    // margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomUserAvatarWidget(
                          size: 32,
                          username: item.username,
                          networkImage: item.profilePictureKey ?? '',
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      Text('${item.activity?.emoji ?? ''} '),
                                      if (item.isOwner != null &&
                                          item.isOwner == true) ...{
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: kAppBlue,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 3),
                                          child: const Text(
                                            'Owner',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      },
                                      if (item.communityRole != null &&
                                          checksNotEqual(
                                              item.communityRole?.name ?? '',
                                              'Member')) ...{
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Color(int.parse(
                                                  '0xff${item.communityRole?.color?.substring(1)}')),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 3),
                                          child: Text(
                                            item.communityRole?.name ?? '',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        )
                                      },
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
                                        color: theme.colorScheme.onPrimary),
                                  ),
                                ],
                              ),
                              if (item.isAdmin == null || item.isAdmin == false)
                                IconButton(
                                  onPressed: () {
                                    // communitiesMembersAction(
                                    //     context: context, theme: theme,userModel: item);
                                  },
                                  icon: Icon(Icons.edit_outlined,
                                      size: 15,
                                      color: theme.colorScheme.onPrimary),
                                )
                            ],
                          ),
                        ),
                        //Icon(Icons.keyboard_arrow_right_sharp, color: theme.colorScheme.onPrimary)
                      ],
                    )),
              ),
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
              noItemsFoundIndicatorBuilder: (_) =>
                  const CustomEmptyContentWidget(),
              noMoreItemsIndicatorBuilder: (_) => const SizedBox.shrink(),
              firstPageErrorIndicatorBuilder: (_) =>
                  const CustomNoConnectionWidget(
                title: "Restore connection and swipe to refresh ...",
              ),
              newPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
            ),
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 20,
              );
            },
            // separatorBuilder: (context, index) => Container(
            //   height: 7,
            //   color: theme.brightness == Brightness.light ? theme.colorScheme.surface : theme.colorScheme.background,
            // ),
          ),
        ),
      ),
    );
  }

  void communitiesMembersAction({
    required BuildContext context,
    required ThemeData theme,
    required UserModel? userModel,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SizedBox(
          height: 160,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 4,
                  width: 44,
                  decoration: BoxDecoration(
                      color: theme.colorScheme.onBackground.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.pop(context);
                    communitiesRolesList(
                        context: context, theme: theme, userModel: userModel);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 20,
                        color: theme.colorScheme.onBackground,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Assign Role',
                        style: TextStyle(
                            color: theme.colorScheme.onBackground,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/delete.svg',
                        color: theme.colorScheme.onBackground,
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Remove Member',
                        style: TextStyle(
                            color: theme.colorScheme.onBackground,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void communitiesRolesList({
    required BuildContext context,
    required ThemeData theme,
    required UserModel? userModel,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 4,
                  width: 44,
                  decoration: BoxDecoration(
                      color: theme.colorScheme.onBackground.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pop(context);
                          state.communityAdminCubit.assignMemberRole(
                              communityId: widget.communityModel!.id!,
                              roleId: state.rolesResponse[index].id!,
                              userId: userModel?.id);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        color: Color(int.parse(
                                            '0xff${state.rolesResponse[index].color?.substring(1)}')),
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  Text(
                                    '${state.rolesResponse[index].name}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    state.rolesResponse[index].isDefault != null &&
                                        state.rolesResponse[index].isDefault == 1
                                        ? '(Default)'
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (userModel?.communityRole != null &&
                                userModel?.communityRole?.id ==
                                    state.rolesResponse[index].id!)
                              Icon(
                                Icons.check,
                                color: theme.colorScheme.onPrimary,
                                size: 12,
                              ),
                          ],
                        ),
                      );
                    },
                    shrinkWrap: true,
                    itemCount: state.rolesResponse.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 20,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class CommunityMembersController extends State<CommunityMembers> {
  // page key is page index. Starting from 0, 1, 2 .........
  late PagingController<int, UserModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);
  late CommunityMembersCubit communityMembersCubit;
  late CommunityAdminCubit communityAdminCubit;
  late List<CommunityAdminRoleModel> rolesResponse;

  @override
  Widget build(BuildContext context) => CommunityMembersWidgetView(this);

  @override
  void initState() {
    super.initState();
    communityMembersCubit = context.read<CommunityMembersCubit>();
    rolesResponse = [];
    communityAdminCubit = context.read<CommunityAdminCubit>();
    communityAdminCubit.fetchCommunityRoles(communityId: widget.communityModel.id!);
    pagingController.addPageRequestListener((pageKey) async {
      final response = await fetchCommunityMembers(pageKey);
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

  Future<dartz.Either<String, List<UserModel>>> fetchCommunityMembers(
      int pageKey) async {
    return await communityMembersCubit.fetchCommunityMembers(
        pageKey: pageKey, communityId: widget.communityModel.id!);
  }
}
