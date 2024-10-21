import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/inner_drawer.dart';
import 'package:showwcase_v3/core/utils/sliver_appbar_tabbar_delegate.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_enums.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_state.dart';
import 'package:showwcase_v3/features/home/presentation/pages/ios_drawer_style_wrapper.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_cubit.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_enums.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_app_bar.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_layouts/all_notifications_layout_widget.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_layouts/community_notifications_layout_widget.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_layouts/mentions_notifications_layout_widget.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_layouts/requests_notifications_layout_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/swipe_back_tabview_wrapper_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';

class NotificationsPage extends StatefulWidget {


  const NotificationsPage({Key? key, }) : super(key: key);

  @override
  NotificationsPageController createState() => NotificationsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _NotificationsPageView extends WidgetView<NotificationsPage, NotificationsPageController> {

  const _NotificationsPageView(NotificationsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // anytime last notification read changes on user, this page re-evaluates to dismiss highlighted notifications
    return  BlocSelector<UserProfileCubit, UserProfileState, DateTime?>(
      selector: (userState) {
        final currentUser = AppStorage.currentUserSession!;
        return userState.userProfiles.firstWhere((element) => element.username == currentUser.username).userInfo?.lastNotificationRead;
      },
      builder: (_, __) {
        return IOSDrawerStyleWrapper(
          drawerKey: state.drawerKey,
      // tag: context.getParentRoutePath(),
      //       drawerStateKey: GlobalKey<InnerDrawerState>(),
            page:Scaffold(
            //drawer: const DrawerPage(),
            body: NestedScrollView(
              controller: state._scrollController,
              floatHeaderSlivers: true,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  NotificationAppBarWidget(floating: true, pinned: false, onProfileTapped: () {
                    state.drawerKey.currentState?.open();
                  }, ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverAppBarTabBarDelegate(
                        blurredBackground: false,
                        tabBar: TabBar(
                          controller: state.tabController,
                         // isScrollable: true,
                          indicator: const UnderlineTabIndicator(borderSide: BorderSide(color: kAppBlue, width: 2)),
                          indicatorPadding: EdgeInsets.zero,
                          labelPadding: const EdgeInsets.only(left: 5, right: 5),
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: theme.colorScheme.onBackground,
                          tabs:  [
                            ...notificationTabItems.map((e) => Tab(
                              child: Text(e['text'] as String,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                          ],
                        )


                    ),
                  ),
                ];
              },
              body: SwipeBackTabviewWrapperWidget(
              onBackSwiped: () {
                state.drawerKey.currentState?.open();
              },
              child: SafeArea(
                  top: false,
                  bottom: true,
                  child: TabBarView(
                  controller: state.tabController,
                  children: [
                    ...notificationTabItems.map((tabItem) {
                      final category = tabItem['category'] as NotificationCategory;
                      switch(category) {
                        case NotificationCategory.all:
                          return AllNotificationsLayoutWidget(
                            category: category,
                            type: tabItem['type'] as List<String>,
                            scrollController: state._scrollController,
                          );
                        case NotificationCategory.mentions:
                          return MentionsNotificationsLayoutWidget(
                            category: category,
                            type: tabItem['type'] as List<String>,
                            scrollController: state._scrollController,
                          );
                        case NotificationCategory.requests:
                          return RequestsNotificationsLayoutWidget(
                            category: category,
                            type: tabItem['type'] as List<String>,
                            scrollController: state._scrollController,
                          );
                        case NotificationCategory.community:
                          return CommunityNotificationsLayoutWidget(
                            category: category,
                            type: tabItem['type'] as List<String>,
                            scrollController: state._scrollController,
                          );
                        default:
                          return const SizedBox.shrink();
                      }


                    })
                  ])
              ),
              ),
            )
        )
        );
      },
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class NotificationsPageController extends State<NotificationsPage>  with TickerProviderStateMixin{
  late TabController tabController;
  late ScrollController _scrollController;
  late NotificationCubit _notificationCubit;
  late UserProfileCubit userCubit;
  final drawerKey = GlobalKey<InnerDrawerState>();
  late HomeCubit homeCubit;
  late StreamSubscription<HomeState> homeStateStreamStreamSubscription;

  @override
  Widget build(BuildContext context) => _NotificationsPageView(this);

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _scrollController = ScrollController();
    _notificationCubit = context.read<NotificationCubit>();
    userCubit = context.read<UserProfileCubit>();
    markNotificationsAsRead();
    homeCubit = context.read<HomeCubit>();
    /// Listen to home scaffold interactions
    homeStateStreamStreamSubscription = homeCubit.stream.listen((event) {

      if(event.status == HomeStatus.onActiveIndexTappedCompleted){
        if(_scrollController.hasClients && (event.data as int) == 3){
          _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 375), curve: Curves.linear);
        }
      }

    });
    super.initState();
  }

  void markNotificationsAsRead() async {

    await _notificationCubit.markNotificationAsRead();
    Future.delayed(const Duration(seconds: 5), () async {
      // refresh user info to get latest lastNotificationReadDate()
      final currentUser = AppStorage.currentUserSession!;
      userCubit.fetchUserProfileByUsername(username: currentUser.username!);
    });


  }



}