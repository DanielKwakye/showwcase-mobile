import 'dart:async';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/sliver_appbar_tabbar_delegate.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/circles/presentation/pages/collaborators_page.dart';
import 'package:showwcase_v3/features/circles/presentation/pages/followers_page.dart';
import 'package:showwcase_v3/features/circles/presentation/pages/following_page.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';


class CircleMembersTabsPage extends StatefulWidget {

  final UserModel user;
  final int initialTabIndex;
  const CircleMembersTabsPage({Key? key, this.initialTabIndex = 0, required this.user}) : super(key: key);

  @override
  CircleMembersTabsPageController createState() => CircleMembersTabsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _CircleMembersTabsPageView extends WidgetView<CircleMembersTabsPage, CircleMembersTabsPageController> {

  const _CircleMembersTabsPageView(CircleMembersTabsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
        body: ExtendedNestedScrollView(
          floatHeaderSlivers: true,
          onlyOneScrollInBody: true,
          headerSliverBuilder: (BuildContext ctx, bool innerBoxIsScrolled) {

            return [

              /// App bar -------
              CustomInnerPageSliverAppBar(pinned: true, pageTitle: "@${widget.user.username}",),

              /// Tab bar
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: SliverAppBarTabBarDelegate(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    blurredBackground: true,
                    tabBar: TabBar(
                      controller: state.tabController,
                      isScrollable: true,
                      indicator: const UnderlineTabIndicator(
                        insets: EdgeInsets.only(left: 0, right: 0, bottom: 0,),
                        borderSide: BorderSide(color: kAppBlue, width: 2),
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      // indicatorColor: kAppBlue,
                      indicatorPadding: EdgeInsets.zero,
                      labelColor: theme.colorScheme.onBackground,
                      unselectedLabelColor: theme.colorScheme.onPrimary,
                      tabs: [
                        ...state.tabItems.map((e) {
                          final title = e['title'] as String;
                          final total = e['total'] as int;

                          return Tab(
                            child: Text( "$total $title",
                              overflow: TextOverflow.ellipsis,
                              // style: theme.textTheme.bodyMedium?.copyWith(
                              //     fontWeight: FontWeight.w600,fontSize: 14),
                            ));
                          },
                        )
                      ],
                    )

                ),
              ),

            ];

          }, body: NotificationListener(
            onNotification: (notification) {
              // debugPrint("$notification");
              if(notification is OverscrollNotification){
                // debugPrint("notification:  ${notification.dragDetails?.delta.distance}");
                if(notification.dragDetails != null){
                  final bool forward = notification.dragDetails!.delta.dx > 0;
                  if(forward == true){
                    pop(context);
                  }
                }
              }
              return false;
            },
            child: TabBarView(
              controller: state.tabController,
              // physics:  CustomScrollPhysics(state.tabController),
              // physics: const ClampingScrollPhysics(),
              // dragStartBehavior: DragStartBehavior.down,
              children: List.generate(state.tabItems.length, (index) => index).map((index) {
                final tabItem = state.tabItems[index];
                Widget page = tabItem['page'] as Widget;
                return ExtendedVisibilityDetector(
                  uniqueKey: ValueKey(tabItem['title']),
                  child: page,
                );
              }).toList(),
              //     ),
            ),
          ),

        )
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class CircleMembersTabsPageController extends State<CircleMembersTabsPage> with TickerProviderStateMixin  {

  late TabController tabController;
  late List<Map<String, dynamic>> tabItems;
  late UserProfileCubit userCubit;
  late StreamSubscription<UserProfileState> userStateStreamSubscriptionListener;

  @override
  Widget build(BuildContext context) => _CircleMembersTabsPageView(this);

  @override
  void initState() {
    super.initState();
    tabItems = [
      {
        'index': 0,
        'title': 'Collaborated With',
        'total': widget.user.totalWorkedWiths ?? 0,
        'page': CollaboratorsPage(userModel: widget.user,)
      },
      {
        'index': 1,
        'title': 'Followers',
        'total': widget.user.totalFollowers ?? 0,
        'page': FollowersPage(userModel: widget.user,)
      },
      {
        'index': 2,
        'title': 'Following',
        'total': widget.user.totalFollowing ?? 0,
        'page':  FollowingPage(userModel: widget.user,)
      },
    ];
    tabController  = TabController(length: tabItems.length, vsync: this, initialIndex: widget.initialTabIndex);

    //we need to update total Followers and following in any of them changes
    userCubit = context.read<UserProfileCubit>();
    // add this user to the users of interest
    userCubit.setUserInfo(userInfo: widget.user);
    userStateStreamSubscriptionListener = userCubit.stream.listen(userCubitStreamListener);
  }

  void userCubitStreamListener(UserProfileState event) {
    final user = event.userProfiles.firstWhere((element) => element.username == widget.user.username).userInfo;
    final totalFollowers = user?.totalFollowers ?? 0;
    final totalFollowing = user?.totalFollowing ?? 0;
    final totalWorkedWiths = user?.totalWorkedWiths ?? 0;

    setState(() {

      final workedWithTabItem = tabItems[0];
      workedWithTabItem['total'] = totalWorkedWiths;

      final followersTabItem = tabItems[1];
      followersTabItem['total'] = totalFollowers;

      final followingTabItem = tabItems[2];
      followingTabItem['total'] = totalFollowing;

    });

  }


  @override
  void dispose() {
    userStateStreamSubscriptionListener.cancel();
    super.dispose();
  }

}