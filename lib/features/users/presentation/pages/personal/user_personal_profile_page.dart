import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:separated_row/separated_row.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/sliver_appbar_tabbar_delegate.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/guestbook/presentation/widgets/personal_profile_guestbook_widget.dart';
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
import 'package:showwcase_v3/features/users/presentation/pages/personal/personal_profile_modules_tabview.dart';
import 'package:showwcase_v3/features/users/presentation/pages/personal/personal_series_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/personal/personal_basic_user_info_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/personal/personal_custom_tab_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/profile_image_preview.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/profile_shows.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/profile_threads.dart';

class UserPersonalProfilePage extends StatefulWidget {

  const UserPersonalProfilePage({Key? key}) : super(key: key);

  @override
  UserPersonalProfilePageController createState() => UserPersonalProfilePageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _UserPersonalProfilePageView extends WidgetView<UserPersonalProfilePage, UserPersonalProfilePageController> {

  const _UserPersonalProfilePageView(UserPersonalProfilePageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final UserModel userModel = AppStorage.currentUserSession!;
    final theme = Theme.of(context);


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
                        Center(child: Text('${userModel.displayName}',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: defaultFontSize))),
                        Center(child: Text('@${userModel.username}',style: const TextStyle(color: Colors.white,fontSize: 13,overflow: TextOverflow.ellipsis))),
                      ],
                    )
                  ),
                  actions: [
                    _moreActionsWidget(context, user: userModel),
                  ],
                  flexibleSpace: Stack(
                    children: [
                      /// when appbar is collapsed
                      SizedBox(
                        child: userModel.profileCoverImageKey != null
                            ? Stack(
                          children: [
                            SizedBox(
                              width: double.maxFinite,
                              height: double.maxFinite,
                              child: CachedNetworkImage(
                                imageUrl: profileCoverImageUrl(profileCoverImageKey: userModel.profileCoverImageKey),
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
                          imageUrl: profileCoverImageUrl(profileCoverImageKey: userModel.profileCoverImageKey),
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
                      padding: const EdgeInsets.only(top: 10, right: 15, bottom: 5),
                      child: SeparatedRow(
                        mainAxisSize: MainAxisSize.min,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(width: 5,);
                        },
                        children: [

                          // //! connect to domain ---------------
                          // DecoratedBox(
                          //   decoration: BoxDecoration(
                          //     border: Border.all(
                          //       color: theme.colorScheme.onPrimary,
                          //       width: 1
                          //     ),
                          //     borderRadius: BorderRadius.circular(3)
                          //   ),
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       // open home link
                          //     },
                          //     child:  Padding(padding: const EdgeInsets.all(10),child: Icon(FeatherIcons.externalLink, size: 15, color: theme.colorScheme.onBackground,),),
                          //   ),
                          // ),
                          //
                          // //! resume ------------
                          // DecoratedBox(
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //           color: theme.colorScheme.onPrimary,
                          //           width: 1
                          //       ),
                          //       borderRadius: BorderRadius.circular(3)
                          //   ),
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       // open home link
                          //     },
                          //     child: Padding(padding: const EdgeInsets.all(10),child: SvgPicture.asset('assets/svg/resume.svg',
                          //         colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn), width: 12),),
                          //   ),
                          // ),

                          //! edit profile -----------
                          CustomButtonWidget(
                              text: 'Edit profile',
                              appearance: Appearance.primary,
                              outlineColor: theme.colorScheme.onPrimary,
                              backgroundColor: theme.colorScheme.background,
                              textColor: theme.colorScheme.onBackground,
                              onPressed: () {
                                context.push(context.generateRoutePath(subLocation: editProfilePage));
                              }),



                        ],
                      ),
                    ),
                  ),
                ),

                /// User profile Info
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child:  PersonalBasicUserInfoWidget(userModel: userModel,),
                  ),
                ),

                //! space
                const SliverToBoxAdapter(child: SizedBox(height: 10,),),

                BlocBuilder<UserProfileCubit, UserProfileState>(
                  builder: (context, userState) {
                    return  SliverToBoxAdapter(child:
                    (userState.status == UserStatus.fetchUserTabsInProgress) ?
                    const SizedBox(height: 50, width: double.maxFinite,
                      child: Center(
                        child: CustomCircularLoader(),
                      ),
                    ): const SizedBox.shrink(),
                    );
                  },
                ),


                /// user Tabs -----------
                BlocSelector<UserProfileCubit,UserProfileState, List<UserTabModel>>(
                  selector: (userState) {
                    final tabs = userState.userProfiles.firstWhere((element) => element.username == userModel.username).tabs;
                    return tabs;
                  },
                  builder: (_, tabItems) {
                    return  SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverAppBarTabBarDelegate(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                          ),
                          tabBar: TabBar(
                            isScrollable: true,
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            indicator: const UnderlineTabIndicator(
                                insets: EdgeInsets.only(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                ),
                                borderSide: BorderSide(color: kAppBlue, width: 2)),
                            // labelPadding: const EdgeInsets.only(left: 10, right: 10),
                            controller: state.tabController,
                            labelColor: theme.colorScheme.onBackground,
                            indicatorSize: TabBarIndicatorSize.label,
                            tabs: [
                              ...tabItems
                                  .where((element) => !element.name.isNullOrEmpty() && !element.category.isNullOrEmpty())
                                  .where((element) => element.visible == true)
                                  .map((UserTabModel tabItem) {
                                return Tab(
                                  child: Text(tabItem.category == "user_section" ? "${userModel.displayName}" : tabItem.name ?? "",
                                    style: const TextStyle(
                                        fontSize: defaultFontSize + 2 ,
                                        fontWeight: FontWeight.w600),
                                  ),
                                );
                              })
                            ],
                          )),
                    );
                  },
                )

              ],
              /// Floating action button at the top left
              floatingWidget: Stack(
                clipBehavior: Clip.none,
                children: [
                  // UserProfilePic
                  GestureDetector(
                    onTap: () {
                      pushScreen(context, ProfileImagePreviewPage(url: userModel.profilePictureKey!, tag: "profilePictureKey"));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Hero(
                        tag: "profilePictureKey",
                        child: CustomUserAvatarWidget(
                          username: userModel.displayName,
                          networkImage: userModel.profilePictureKey != null
                              ? getProfileImage(userModel.profilePictureKey!) : null,
                          borderColor: userModel.role == "community_lead" ? kAppGold
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
                          child: Text(userModel.activity?.emoji != null &&
                              userModel.activity!.emoji!.contains('?')
                              ? userModel.activity!.emoji! : '🔎',
                            style: TextStyle(
                                color: theme.colorScheme.onBackground),
                          ),
                        ), // emoji,
                      )),
                ],
              ),

              /// Main body of the profile page controlled by tabs
              body: BlocSelector<UserProfileCubit,UserProfileState, List<UserTabModel>>(
                selector: (userState) {
                  final tabs = userState.userProfiles.firstWhere((element) => element.username == userModel.username).tabs;
                  return tabs;
                },
                builder: (context, tabItems) {

                  // enables
                  return SwipeBackTabviewWrapperWidget(
                    onBackSwiped: () => pop(context),
                    child: TabBarView(
                      controller: state.tabController,
                      // physics:  CustomScrollPhysics(state.tabController),
                      // physics: const ClampingScrollPhysics(),
                      // dragStartBehavior: DragStartBehavior.down,
                      children: tabItems
                          .where((element) => !element.name.isNullOrEmpty() && !element.category.isNullOrEmpty())
                          .where((element) => element.visible == true)
                          .map((UserTabModel tabItem) {

                        /// Profile modules ---------------------------------
                        if(tabItem.category == "user_section"){

                          return ExtendedVisibilityDetector(
                            uniqueKey: ValueKey(tabItem.name),
                            child:  PersonalProfileModulesTabview(tabModel: tabItem),
                          );


                        }
                        /// Internal tabs -----------------------------
                        else if(tabItem.category == "internal"){

                          final slug = (tabItem.name ?? "").toLowerCase().replaceAll(" ", "_");

                          switch(slug) {

                            case "threads":
                              return ExtendedVisibilityDetector(
                                uniqueKey: ValueKey(tabItem.name),
                                child: ProfileThreadFeed(username: userModel.username!),
                              );

                            case "shows":
                              return ExtendedVisibilityDetector(
                                uniqueKey: ValueKey(tabItem.name),
                                child: ProfileShowFeedsPage(username: userModel.username!),
                              );

                            case "series":
                              return ExtendedVisibilityDetector(
                                uniqueKey: ValueKey(tabItem.name),
                                child:  const PersonalProfileSeriesWidget(),
                              );

                            case "guestbooks":
                              return ExtendedVisibilityDetector(
                                uniqueKey: ValueKey(tabItem.name),
                                child: PersonalProfileGuestBookWidget(
                                  userModel: userModel,
                                ),
                              );

                            default:
                              return ExtendedVisibilityDetector(
                                uniqueKey: ValueKey(tabItem.name),
                                child: const SizedBox.shrink(),
                              );
                          }

                        }else if(tabItem.category == "custom") {

                          /// custom tabs -----------------------
                          return ExtendedVisibilityDetector(
                            uniqueKey: ValueKey(tabItem.name),
                            child: PersonalCustomTabWidget(modules: tabItem.modules,),
                          );


                        }else {
                          return const SizedBox.shrink();
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
              )
          )
      ),
    );

  }

  Widget _moreActionsWidget(BuildContext context, {required UserModel user}) {
    final theme = Theme.of(context);
    return PopupMenuButton<String>(
        padding: EdgeInsets.zero,
      color: theme.brightness == Brightness.dark ? kCodeBackgroundColor : theme.colorScheme.primary,
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
        _buildPopupMenu(ctx, label: "Copy link to profile", icon: Icons.link, value: "copy"),
      ],
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Icon(Icons.more_horiz, color: Colors.white, size: 30),
      ),
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

  void _onMoreMenuItemTapped(BuildContext context, String menu, {required UserModel user}) {
    if (menu == "copy") {
      //  insert user profile url here ....
      final copyUrl = "${ApiConfig.websiteUrl}/${user.username}";
      copyTextToClipBoard(context, copyUrl);
    }
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class UserPersonalProfilePageController extends State<UserPersonalProfilePage>  with TickerProviderStateMixin {

  final scrollController = ScrollController();
  late UserProfileCubit userCubit;
  late StreamSubscription<UserProfileState> userStateStreamSubscription;
  late TabController tabController;


  @override
  Widget build(BuildContext context) => _UserPersonalProfilePageView(this);

  @override
  void initState() {
    super.initState();

    final UserModel currentUser = AppStorage.currentUserSession!;
    userCubit = context.read<UserProfileCubit>();
    final user = userCubit.setUserInfo(userInfo: currentUser);
    final tabs = userCubit.state.userProfiles.firstWhere((element) => element.username == user?.username).tabs;
    tabController = TabController(length: tabs.length, vsync: this);
    userCubit.fetchUserTabs(userModel: currentUser);
    userStateStreamSubscription = userCubit.stream.listen((event) {
      if(event.status == UserStatus.fetchUserTabsSuccessful){
        // Initialize the TabController with the right length
        final tabs = event.userProfiles.firstWhere((element) => element.username == user?.username).tabs;
        tabController = TabController(vsync: this, length: tabs.length);
      }
    });
    userCubit.fetchUserProfileByUsername(username: currentUser.username!);


    // // arrangements are dynamic ----
    // tabItems = [
    //   <String, dynamic>{
    //     "key": "modules",
    //     'text': "",
    //     'sub_text': "", // set a string here to include any subtext on the tab
    //     'page': PersonalProfileModulesSection(userModel: currentUser,)
    //   },
    //   <String, dynamic>{
    //     "key": "shows",
    //     'text': 'Shows',
    //     'sub_text': "", // set a string here to include any subtext on the tab
    //     'page': PersonalProfileModulesSection(userModel: currentUser,)
    //   },
    //   <String, dynamic>{
    //     "key": "series",
    //     'text': 'Series',
    //     'sub_text': "", // set a string here to include any subtext on the tab
    //     'page': PersonalProfileModulesSection(userModel: currentUser,)
    //   },
    //   <String, dynamic>{
    //     "key": "threads",
    //     'text': 'Threads',
    //     'sub_text': "", // set a string here to include any subtext on the tab
    //     'page': PersonalProfileModulesSection(userModel: currentUser,)
    //   },
    //   <String, dynamic>{
    //     "key": "guestbook",
    //     'text': 'Guestbook',
    //     'sub_text': "", // set a string here to include any subtext on the tab
    //     'page': PersonalProfileModulesSection(userModel: currentUser,)
    //   },
    // ];
  }

  void handleProfilePicTapped() {
    // if (userModel.profilePictureKey == null) return;
    //
    // if (isOwner) {
    //   if (ShowwcaseStorage
    //       .currentUserSession!.profilePictureKey !=
    //       null) {
    //     Navigator.of(context).push(CustomFadeInPageRoute(
    //         ProfileImagePreviewPage(
    //             url: getProfileImage(ShowwcaseStorage
    //                 .currentUserSession!
    //                 .profilePictureKey!),
    //             tag: "profilePictureKey"),
    //         color: Theme.of(context).colorScheme.background));
    //   }
    // } else {
    //   Navigator.of(context).push(CustomFadeInPageRoute(
    //       ProfileImagePreviewPage(
    //           url: getProfileImage(
    //               userResponse.profilePictureKey!),
    //           tag: "profilePictureKey"),
    //       color: Theme.of(context).colorScheme.background));
    // }
  }


  @override
  void dispose() {
    scrollController.dispose();
    userStateStreamSubscription.cancel();
    super.dispose();
  }

}