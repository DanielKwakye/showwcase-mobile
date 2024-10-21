import 'dart:async';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/inner_drawer.dart';
import 'package:showwcase_v3/core/utils/sliver_appbar_tabbar_delegate.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_enums.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_state.dart';
import 'package:showwcase_v3/features/home/presentation/pages/ios_drawer_style_wrapper.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/swipe_back_tabview_wrapper_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/pages/following_thread_feeds_page.dart';
import 'package:showwcase_v3/features/threads/presentation/pages/for_you_thread_feeds_page.dart';
import 'package:showwcase_v3/features/threads/presentation/pages/news_thread_feeds_page.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_feeds_app_bar_widget.dart';

class ThreadFeedsTabPage extends StatefulWidget {

  const ThreadFeedsTabPage({Key? key}) : super(key: key);

  @override
  ThreadFeedsTabPageController createState() => ThreadFeedsTabPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ThreadsFeedsTabPageView extends WidgetView<ThreadFeedsTabPage, ThreadFeedsTabPageController> {

  const _ThreadsFeedsTabPageView(ThreadFeedsTabPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return  IOSDrawerStyleWrapper(
      // tag: context.getParentRoutePath(),
      drawerKey: state.drawerKey,
      page: ExtendedNestedScrollView(
        floatHeaderSlivers: true,
        controller: state.scrollController,
        onlyOneScrollInBody: true,
        headerSliverBuilder: (BuildContext ctx, bool innerBoxIsScrolled) {

          return [

            /// App bar -------
            ThreadFeedsAppBarWidget(pinned: false, floating: true, onProfileIconTapped: () {
              state.drawerKey.currentState?.open();
            },),

            /// Tab bar
            SliverPersistentHeader(
              pinned: false,
              floating: true,
              delegate: SliverAppBarTabBarDelegate(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  blurredBackground: true,
                  tabBar: TabBar(
                    controller: state.tabController,
                    isScrollable: false,
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
                      ...state.tabItems.map((e) => Tab(
                        child: Text(e['title'] as String,
                          overflow: TextOverflow.ellipsis,
                          // style: theme.textTheme.bodyMedium?.copyWith(
                          //     fontWeight: FontWeight.w600,fontSize: 14),
                        ),
                      ))
                    ],
                  )

              ),
            ),

          ];

        }, body:
        SwipeBackTabviewWrapperWidget(
        onBackSwiped: () {
          state.drawerKey.currentState?.open();
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
              uniqueKey: ValueKey("thread-feeds-tabs-${tabItem['title']}-${tabItem['index']}"),
              child: page,
            );
          }).toList(),
          //     ),
        ),
      ),

      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ThreadFeedsTabPageController extends State<ThreadFeedsTabPage> with TickerProviderStateMixin {

  late TabController tabController;
  late List<Map<String, dynamic>> tabItems;
  final ValueNotifier<bool> activateDrawer = ValueNotifier(false);
  final ScrollController scrollController =  ScrollController();
  late HomeCubit homeCubit;
  late StreamSubscription<HomeState> homeStateStreamStreamSubscription;
  final drawerKey = GlobalKey<InnerDrawerState>();



  @override
  Widget build(BuildContext context) {
    return _ThreadsFeedsTabPageView(this);
  }

  @override
  void initState() {
    super.initState();
    homeCubit = context.read<HomeCubit>();
    tabItems = [
      {
        'index': 0,
        'title': 'For you',
        'page': const ForYouThreadFeedsPage()
      },
      {
        'index': 1,
        'title': 'Following',
        'page': const FollowingThreadFeedsPage()
      },
      {
        'index': 2,
        'title': 'News',
        'page':  const NewsThreadFeedsPage()
      },
    ];
    tabController  = TabController(length: tabItems.length, vsync: this, initialIndex: 0);

    /// notify home scaffold of pages scrolls..
    /// bottom navigation bar shows and hides on page scroll
    scrollController.addListener(() {
      final pixelScrolled = scrollController.position.pixels;
      if(pixelScrolled >  20) {
        homeCubit.onPageScroll(PageScrollDirection.up);
      }else {
        homeCubit.onPageScroll(PageScrollDirection.down);
      }
    });

    /// Listen to home scaffold interactions
    homeStateStreamStreamSubscription = homeCubit.stream.listen((event) {

      if(event.status == HomeStatus.onActiveIndexTappedCompleted){
        if(scrollController.hasClients && (event.data as int) == 0){
          scrollController.animateTo(0.0, duration: const Duration(milliseconds: 375), curve: Curves.linear);
        }
      }

    });

  }


  @override
  void dispose() {
    scrollController.removeListener(() { });
    scrollController.dispose();
    tabController.dispose();
    homeStateStreamStreamSubscription.cancel();
    super.dispose();
  }

}