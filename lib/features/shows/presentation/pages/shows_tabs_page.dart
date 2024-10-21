import 'dart:async';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/inner_drawer.dart';
import 'package:showwcase_v3/core/utils/sliver_appbar_tabbar_delegate.dart';
import 'package:showwcase_v3/core/utils/sliver_pinned_box_adapter.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_enums.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_state.dart';
import 'package:showwcase_v3/features/home/presentation/pages/ios_drawer_style_wrapper.dart';
import 'package:showwcase_v3/features/roadmaps/presentation/pages/roadmaps_feeds_page.dart';
import 'package:showwcase_v3/features/series/presentation/pages/series_feeds_page.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/swipe_back_tabview_wrapper_widget.dart';
import 'package:showwcase_v3/features/shows/presentation/pages/show_feeds_page.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_categories_widget.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/shows_app_bar.dart';


class ShowsTabsPage extends StatefulWidget {

  const ShowsTabsPage({Key? key}) : super(key: key);

  @override
  ShowsPageController createState() => ShowsPageController();

}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ShowsTabsPageView extends WidgetView<ShowsTabsPage, ShowsPageController> {

  const _ShowsTabsPageView(ShowsPageController state) : super(state);

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
            ShowsAppBarWidget(pinned: false, floating: true, onProfileTapped: () {
              state.drawerKey.currentState?.open();
            }, ),

            /// Tab bar
            SliverPersistentHeader(
              pinned: false,
              floating: false,
              delegate: SliverAppBarTabBarDelegate(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  blurredBackground: false,
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

            ValueListenableBuilder<int>(valueListenable: state.currentTabIndex, builder: (_, currentTabIndex, ch) {

              /// Show feeds
              if(currentTabIndex == 0){

                return SliverPinnedBoxAdapter(
                  widget: FadeInDown(
                    child: ch!,
                  ),
                );
              }

              return const SliverToBoxAdapter(child: SizedBox.shrink(),);


            }, child: const ShowCategoriesWidget() ),



          ];

        }, body: SwipeBackTabviewWrapperWidget(
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
              uniqueKey: ValueKey(tabItem['title']),
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

class ShowsPageController extends State<ShowsTabsPage>  with TickerProviderStateMixin {

  late List<Map<String, dynamic>> tabItems;
  late TabController tabController;
  final ValueNotifier<bool> activateDrawer = ValueNotifier(false);
  // final ValueNotifier<bool> activateShowsCategories = ValueNotifier(true);
  final ScrollController scrollController =  ScrollController();
  late HomeCubit homeCubit;
  late StreamSubscription<HomeState> homeStateStreamStreamSubscription;
  final ValueNotifier<int> currentTabIndex = ValueNotifier(0);
  final drawerKey = GlobalKey<InnerDrawerState>();

  @override
  Widget build(BuildContext context) => _ShowsTabsPageView(this);

  @override
  void initState() {
    super.initState();
    homeCubit = context.read<HomeCubit>();
    tabItems = [
      <String, dynamic>{
        'index': 0,
        'title': "Shows",
        'page': const ShowFeedsPage(),

      },
      <String, dynamic>{
        'index': 2,
        'title': 'Series',
        'page': const SeriesFeedsPage()
      },
      <String, dynamic>{
        'index': 3,
        'title': 'Roadmaps',
        'page': const RoadmapsFeedsPage()
      },
    ];

    tabController  = TabController(length: tabItems.length, vsync: this, initialIndex: 0);
    tabController.addListener(() {
      currentTabIndex.value = tabController.index;
    });

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
        if(scrollController.hasClients && (event.data as int) == 1){
          scrollController.animateTo(0.0, duration: const Duration(milliseconds: 375), curve: Curves.linear);
        }
      }

    });

  }



}