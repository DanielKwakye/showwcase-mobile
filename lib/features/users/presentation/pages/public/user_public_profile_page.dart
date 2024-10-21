import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:separated_row/separated_row.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/sliver_appbar_tabbar_delegate.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/circles/data/bloc/circles_cubit.dart';
import 'package:showwcase_v3/features/circles/data/bloc/circles_enums.dart';
import 'package:showwcase_v3/features/guestbook/presentation/widgets/public_profile_guestbook_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_circular_loader.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_sliver_fab_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_visibility_app_bar_title_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/swipe_back_tabview_wrapper_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_enums.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_tab_model.dart';
import 'package:showwcase_v3/features/users/presentation/pages/public/public_profile_modules_tabview.dart';
import 'package:showwcase_v3/features/users/presentation/pages/public/public_series_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/public/public_basic_user_info_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/public/public_user_%20blocked_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/profile_image_preview.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/profile_shows.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/profile_threads.dart';

import '../../widgets/public/public_custom_tab_widget.dart';

class UserPublicProfilePage extends StatefulWidget {
  final UserModel userModel;

  const UserPublicProfilePage({Key? key, required this.userModel})
      : super(key: key);

  @override
  UserPublicProfilePageController createState() =>
      UserPublicProfilePageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _UserPublicProfilePageView
    extends WidgetView<UserPublicProfilePage, UserPublicProfilePageController> {
  const _UserPublicProfilePageView(UserPublicProfilePageController state)
      : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocSelector<UserProfileCubit, UserProfileState, UserModel?>(
      selector: (userState) {
        //! this user may or may not be part of users interest
        return userState.userProfiles
            .firstWhereOrNull(
                (element) => element.username == widget.userModel.username)
            ?.userInfo;
      },
      builder: (context, userinfo) {
        return SafeArea(
          top: false,
          child: Scaffold(
              body: SliverFabWidget(
                  expandedHeight: 100,
                  controller: state.scrollController,
                  headerSlivers: [
                    /// App bar with username title
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: theme.colorScheme.primary,
                      expandedHeight: 100,
                      elevation: 0,
                      leading: const BackButton(
                        color: Colors.white,
                      ),
                      title: CustomVisibilityControlAppBarTitleWidget(child:
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(child: Text('${widget.userModel.displayName}',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: defaultFontSize))),
                          Center(child: Text('@${widget.userModel.username}',style: const TextStyle(color: Colors.white,fontSize: 13,overflow: TextOverflow.ellipsis))),
                        ],
                      )
                      ),
                      actions: [
                        _moreActionsWidget(context, user: widget.userModel),
                      ],
                      flexibleSpace: Stack(
                        children: [
                          /// when appbar is collapsed
                          SizedBox(
                            child: widget.userModel.profileCoverImageKey != null
                                ? Stack(
                              children: [
                                SizedBox(
                                  width: double.maxFinite,
                                  height: double.maxFinite,
                                  child: CachedNetworkImage(
                                    imageUrl: profileCoverImageUrl(profileCoverImageKey: widget.userModel.profileCoverImageKey),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          color: kAppBlue,
                                        ),
                                    placeholder: (ctx, url) => Container(
                                      color: kAppBlue,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: kAppBlack.withOpacity(0.8),
                                ),
                                ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 5, sigmaY: 5),
                                    child: const SizedBox.expand(),
                                  ),
                                ),
                                // Align(
                                //   alignment: Alignment.topCenter,
                                //   child: ConstrainedBox(
                                //     constraints: BoxConstraints(maxWidth: width(context) / 1.6),
                                //     child: ,
                                //   ),
                                // )
                              ],
                            )
                                : Container(
                              color: kAppBlue,
                            ),
                          ),

                          /// When appbar is expanded
                          FlexibleSpaceBar(
                            background: CachedNetworkImage(
                              imageUrl: profileCoverImageUrl(profileCoverImageKey: widget.userModel.profileCoverImageKey),
                              errorWidget: (context, url, error) =>
                                  Container(
                                    color: kAppBlue,
                                  ),
                              placeholder: (ctx, url) => Container(
                                color: kAppBlue,
                              ),
                              fit: BoxFit.cover,
                            ),
                            centerTitle: true,
                          )

                        ],
                      ),
                    ),
                    /// action buttons
                    SliverToBoxAdapter(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 10, right: 15, bottom: 5),
                          child: SeparatedRow(
                            mainAxisSize: MainAxisSize.min,
                            separatorBuilder: (BuildContext context, int index) {
                              return const SizedBox(
                                width: 5,
                              );
                            },
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    state.onCircleTapped(context: context,isColleague: userinfo?.isColleague ?? '');
                                  },
                                  child: SvgPicture.asset(
                                    'assets/svg/circles_add.svg',
                                    height: 18,
                                    width: 18,
                                    color: state.circlesIconColor(
                                        userinfo?.isColleague.toString() ?? ''),
                                  )),
                              const SizedBox(width: 15),

                              /// follow and unfollow -----------
                              Builder(builder: (_) {
                                final isFollowed = (userinfo?.isFollowed != null &&
                                    userinfo?.isFollowed != false);
                                return CustomButtonWidget(
                                    text: isFollowed ? 'Following' : 'Follow',
                                    borderRadius: 30,
                                    appearance: isFollowed
                                        ? Appearance.secondary
                                        : Appearance.primary,
                                    backgroundColor: theme.brightness == Brightness.dark ? kPrimaryBlue : kAppBlue.withOpacity(0.2),
                                    textColor: kAppBlue,
                                    onPressed: () {
                                      state.userCubit.followAndUnfollowUser(
                                          userInfo: widget.userModel,
                                          action: !isFollowed
                                              ? FollowerAction.follow
                                              : FollowerAction.unfollow);
                                    });
                              })
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// User profile Info
                    BlocSelector<UserProfileCubit, UserProfileState, UserModel?>(
                      selector: (state) {
                        final index = state.userProfiles.indexWhere((element) =>
                            element.username == widget.userModel.username);
                        if (index < 0) {
                          return null;
                        }
                        return state.userProfiles[index].userInfo;
                      },
                      builder: (BuildContext context, reactiveUserModel) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, ),
                            child: PublicBasicUserInfoWidget(
                              userModel: reactiveUserModel ?? widget.userModel,
                            ),
                          ),
                        );
                      },
                    ),

                    //! space
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),

                    // (userState.status == UserStatus.fetchUserTabsInProgress)
                    //     ?
                    //     : const SizedBox.shrink(),

                    BlocBuilder<UserProfileCubit, UserProfileState>(
                      builder: (context, userState) {
                        if (userState.status ==
                            UserStatus.fetchUserTabsInProgress) {
                          return const SliverToBoxAdapter(
                              child: SizedBox(
                            height: 30,
                            width: double.maxFinite,
                            child: Center(
                              child: CustomCircularLoader(),
                            ),
                          ));
                        }
                        return const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        );
                      },
                    ),

                    /// user Tabs -----------
                    Builder(
                      builder: (_) {
                        final hasBlocked = userinfo?.hasBlocked ?? false;
                        if (hasBlocked) {
                          return const SliverToBoxAdapter(child: SizedBox.shrink());
                        } else {
                          return BlocSelector<UserProfileCubit, UserProfileState,
                              List<UserTabModel>>(
                            selector: (userState) {
                              final tabs = userState.userProfiles
                                  .firstWhere((element) =>
                                      element.username == widget.userModel.username)
                                  .tabs;
                              return tabs;
                            },
                            builder: (_, tabItems) {
                              return SliverPersistentHeader(
                                pinned: true,
                                delegate: SliverAppBarTabBarDelegate(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                    ),
                                    tabBar: TabBar(
                                      isScrollable: true,
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 0),
                                      indicator: const UnderlineTabIndicator(
                                          insets: EdgeInsets.only(
                                            left: 0,
                                            right: 0,
                                            bottom: 0,
                                          ),
                                          borderSide: BorderSide(
                                              color: kAppBlue, width: 2)),
                                      // labelPadding: const EdgeInsets.only(left: 10, right: 10),
                                      controller: state.tabController,
                                      labelColor: theme.colorScheme.onBackground,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      tabs: [
                                        ...tabItems
                                            .where((element) =>
                                                !element.name.isNullOrEmpty() &&
                                                !element.category.isNullOrEmpty())
                                            .where((element) =>
                                                element.visible == true)
                                            .map((UserTabModel tabItem) {
                                          return Tab(
                                            child: Text(
                                              tabItem.category == "user_section"
                                                  ? "${widget.userModel.displayName}"
                                                  : tabItem.name ?? "",
                                              style: const TextStyle(
                                                  fontSize: defaultFontSize + 2,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          );
                                        })
                                      ],
                                    )),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                  floatingWidget: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // UserProfilePic
                      GestureDetector(
                        onTap: () {
                          pushScreen(
                              context,
                              ProfileImagePreviewPage(
                                  url: widget.userModel.profilePictureKey!,
                                  tag: "profilePictureKey"));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Hero(
                            tag: "profilePictureKey",
                            child: CustomUserAvatarWidget(
                              username: widget.userModel.displayName,
                              networkImage:
                                  widget.userModel.profilePictureKey != null
                                      ? getProfileImage(
                                          widget.userModel.profilePictureKey!)
                                      : null,
                              borderColor: widget.userModel.role == "community_lead"
                                  ? kAppGold
                                  : theme.colorScheme.primary,
                              size: 80,
                              // dimension: '200x',
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          right: -5,
                          bottom: -5,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: theme.brightness == Brightness.dark
                                    ? const Color(0xff14171A)
                                    : kAppWhite,
                                borderRadius: BorderRadius.circular(1000)),
                            child: Center(
                              child: Text(
                                widget.userModel.activity?.emoji != null &&
                                        widget.userModel.activity!.emoji!
                                            .contains('?')
                                    ? widget.userModel.activity!.emoji!
                                    : '🔎',
                                style: TextStyle(
                                    color: theme.colorScheme.onBackground),
                              ),
                            ), // emoji,
                          )),
                    ],
                  ),

                  /// Main body of the profile page controlled by tabs
                  body: BlocSelector<UserProfileCubit, UserProfileState, UserModel?>(
                          selector: (userState) {
                    //! this user may or may not be part of users interest
                    return userState.userProfiles
                        .firstWhereOrNull((element) =>
                            element.username == widget.userModel.username)
                        ?.userInfo;
                  }, builder: (context, userInfo) {
                    final hasBlocked = userInfo?.hasBlocked ?? false;
                    if (hasBlocked) {
                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    }
                    return hasBlocked
                        ? PublicUserBlockedWidget(
                            username: widget.userModel.username ?? "",
                            onViewProfileTapped: () {
                              //
                            },
                          )
                        : BlocSelector<UserProfileCubit, UserProfileState,
                            List<UserTabModel>>(
                            selector: (userState) {
                              final tabs = userState.userProfiles
                                  .firstWhere((element) =>
                                      element.username == widget.userModel.username)
                                  .tabs;
                              return tabs;
                            },
                            builder: (context, tabItems) {
                              return SwipeBackTabviewWrapperWidget(
                                child: TabBarView(
                                  controller: state.tabController,
                                  children: tabItems
                                      .where((element) =>
                                          !element.name.isNullOrEmpty() &&
                                          !element.category.isNullOrEmpty())
                                      .where((element) => element.visible == true)
                                      .map((UserTabModel tabItem) {
                                    /// Profile modules ---------------------------------
                                    if (tabItem.category == "user_section") {
                                      return ExtendedVisibilityDetector(
                                        uniqueKey: ValueKey(tabItem.name),
                                        child: PublicProfileModulesTabview(
                                          tabModel: tabItem,
                                          userModel: widget.userModel,
                                        ),
                                      );
                                    }

                                    /// Internal tabs -----------------------------
                                    else if (tabItem.category == "internal") {
                                      final slug = (tabItem.name ?? "")
                                          .toLowerCase()
                                          .replaceAll(" ", "_");

                                      switch (slug) {
                                        case "threads":
                                          return ExtendedVisibilityDetector(
                                            uniqueKey: ValueKey(tabItem.name),
                                            child: ProfileThreadFeed(
                                                username:
                                                    widget.userModel.username!),
                                          );

                                        case "shows":
                                          return ExtendedVisibilityDetector(
                                            uniqueKey: ValueKey(tabItem.name),
                                            child: ProfileShowFeedsPage(
                                                username:
                                                    widget.userModel.username!),
                                          );

                                        case "series":
                                          return ExtendedVisibilityDetector(
                                            uniqueKey: ValueKey(tabItem.name),
                                            child: PublicProfileSeriesWidget(
                                              userModel: widget.userModel,
                                            ),
                                          );

                                        case "guestbooks":
                                          return ExtendedVisibilityDetector(
                                            uniqueKey: ValueKey(tabItem.name),
                                            child: PublicProfileGuestBookWidget(
                                              userModel: widget.userModel,
                                            ),
                                          );
                                        default:
                                          return ExtendedVisibilityDetector(
                                            uniqueKey: ValueKey(tabItem.name),
                                            child: const SizedBox.shrink(),
                                          );
                                      }
                                    } else {
                                      /// custom tabs -----------------------
                                      return ExtendedVisibilityDetector(
                                        uniqueKey: ValueKey(tabItem.name),
                                        child: PublicCustomTabWidget(
                                          modules: tabItem.modules,
                                          userModel: widget.userModel,
                                        ),
                                      );
                                    }

                                    // return ExtendedVisibilityDetector(
                                    //   uniqueKey: ValueKey(tabItem.category),
                                    //   child: page,
                                    // );
                                  }).toList(),
                                  //     ),
                                ),
                              );
                            },
                          );
                  }))),
        );
      },
    );
  }



  Widget _moreActionsWidget(BuildContext context, {required UserModel user}) {
    final theme = Theme.of(context);
    return PopupMenuButton<String>(
      padding: const EdgeInsets.only(right: 0.0),
      color: theme.brightness == Brightness.dark
          ? kCodeBackgroundColor
          : theme.colorScheme.primary,
      icon: const Icon(Icons.more_horiz, color: Colors.white, size: 30),
      onSelected: (menu) {
        _onMoreMenuItemTapped(context, menu, user: user);
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      itemBuilder: (ctx) => [
        _buildPopupMenu(ctx,
            label: "Copy link to profile", icon: Icons.link, value: "copy"),
        if (user.hasBlocked ?? false) ...{
          _buildPopupMenu(ctx,
              label: "Unblock", icon: FeatherIcons.flag, value: "unblock"),
        } else ...{
          _buildPopupMenu(ctx,
              label: "Block", icon: FeatherIcons.lock, value: "block"),
        },
        _buildPopupMenu(ctx,
            label: "Report", icon: FeatherIcons.flag, value: "report"),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenu(BuildContext context,
      {required String label, required IconData icon, required String value}) {
    return PopupMenuItem(
      height: 30,
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 8,
          ),
          Icon(icon, color: theme(context).colorScheme.onPrimary, size: 16),
          const SizedBox(
            width: 8,
          ),
          Text(label,
              style: TextStyle(
                  fontSize: 14, color: theme(context).colorScheme.onPrimary)),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }

  void _onMoreMenuItemTapped(BuildContext context, String menu,
      {required UserModel user}) {
    if (menu == "copy") {
      final copyUrl = "${ApiConfig.websiteUrl}/${user.username}";
      copyTextToClipBoard(context, copyUrl);
    } else if (menu == "block") {
      /// block user
      state.userCubit
          .blockAndUnblockUser(userInfo: user, action: BlockAction.block);
    } else if (menu == "report") {
      // report user
    } else if (menu == 'unblock') {
      /// unblock user
      state.userCubit
          .blockAndUnblockUser(userInfo: user, action: BlockAction.unblock);
    }
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class UserPublicProfilePageController extends State<UserPublicProfilePage>
    with TickerProviderStateMixin {
  final scrollController = ScrollController();
  late UserProfileCubit userCubit;
  late StreamSubscription<UserProfileState> userStateStreamSubscription;
  late TabController tabController;
  late CirclesCubit circlesCubit;

  @override
  Widget build(BuildContext context) => _UserPublicProfilePageView(this);

  @override
  void initState() {
    super.initState();
    userCubit = context.read<UserProfileCubit>();
    final user = userCubit.setUserInfo(userInfo: widget.userModel);
    final tabs = userCubit.state.userProfiles
        .firstWhere((element) => element.username == user?.username)
        .tabs;
    tabController = TabController(length: tabs.length, vsync: this);
    userCubit.fetchUserTabs(userModel: widget.userModel);
    userStateStreamSubscription = userCubit.stream.listen((event) {
      if (event.status == UserStatus.fetchUserTabsSuccessful) {
        // Initialize the TabController with the right length
        final tabs = event.userProfiles
            .firstWhere((element) => element.username == user?.username)
            .tabs;
        tabController = TabController(vsync: this, length: tabs.length);
      }
    });
    circlesCubit = context.read<CirclesCubit>();
    userCubit.fetchUserProfileByUsername(username: widget.userModel.username!);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Color? circlesIconColor(String isColleague) {
    if (isColleague == 'active') {
      return kAppGreen;
    } else if (isColleague == 'requesting') {
      return kAppBlue;
    }

    return null;
  }

  void onCircleTapped({required String isColleague ,required BuildContext context}) {

    if (isColleague == 'active' || isColleague == 'requesting') {
      showCancelCircleRequestDialog(context);
    } else  {
      context.push(
          context.generateRoutePath(
              subLocation: collaboratorsRequest),
          extra: widget.userModel);
    }

  }

  void showCancelCircleRequestDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: theme(context).colorScheme.onSurface,
            title: const Text('Cancel Circle Request'),
            content: RichText(text: TextSpan(
              children: [
                const TextSpan(text: 'Are you sure you want to remove '),
                TextSpan(text: '${widget.userModel.displayName}',style: const TextStyle(fontWeight: FontWeight.w700)),
                const TextSpan(text: ' from your collaboration?'),

              ]
            )),
            actions: [
              CustomButtonWidget(text: 'Yes', onPressed: () {
                circlesCubit.handleCircleInvite(widget.userModel,userId: widget.userModel.id, circleAction: CirclesBroadcastAction.circleRequestRejected);
                pop(context);
              }, appearance: Appearance.error,),
              CustomButtonWidget(text: 'Cancel', onPressed: () {
                pop(context);
              }, appearance: Appearance.secondary,),
            ],
          );
        });
  }
}
