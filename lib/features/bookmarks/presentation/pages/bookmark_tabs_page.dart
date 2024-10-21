import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/core/utils/sliver_appbar_tabbar_delegate.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/bookmarks/presentation/pages/bookmark_show_feeds_page.dart';
import 'package:showwcase_v3/features/bookmarks/presentation/pages/bookmark_thread_feeds_page.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';

import '../../../../core/utils/theme.dart';

class BookmarkTabsPage extends StatefulWidget {

  const BookmarkTabsPage({Key? key}) : super(key: key);

  @override
  BookmarkTabsPageController createState() => BookmarkTabsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _BookmarkTabsPageView extends WidgetView<BookmarkTabsPage, BookmarkTabsPageController> {

  const _BookmarkTabsPageView(BookmarkTabsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return SafeArea(child: ExtendedNestedScrollView(
        floatHeaderSlivers: false,
        onlyOneScrollInBody: true,
        headerSliverBuilder: (BuildContext ctx, bool innerBoxIsScrolled){
          return  [
            const CustomInnerPageSliverAppBar(
              pageTitle: "Bookmarks", leading: BackButton(),

            ),
            /// Tab bar
            SliverPersistentHeader(
              pinned: true,
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
        },
        body: NotificationListener(
          onNotification: (notification) {
            // debugPrint("$notification");
            if(notification is OverscrollNotification){
              // debugPrint("notification:  ${notification.dragDetails?.delta.distance}");
              if(notification.dragDetails != null){
                final bool forward = notification.dragDetails!.delta.dx > 0;
                if(forward == true){
                  // pop(context);
                  context.pop();
                }
              }
            }
            return false;
          },
          child: TabBarView(
            controller: state.tabController,
            // physics: const CustomScrollPhysics(),
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
        )
    ));

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class BookmarkTabsPageController extends State<BookmarkTabsPage> with TickerProviderStateMixin {

  late TabController tabController;
  late List<Map<String, dynamic>> tabItems;
  late HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) => _BookmarkTabsPageView(this);

  @override
  void initState() {
    super.initState();
    homeCubit = context.read<HomeCubit>();
    tabItems =  [
      <String, dynamic>{'index': 0,
        'title': "Threads",
        'sub_text': "", // set a string here to include any subtext on the tab
        "page": const BookmarkThreadFeedsPage()
      },
      <String, dynamic>{'index': 1,
        'title': 'Shows',
        'sub_text': "", // set a string here to include any subtext on the tab
        'page': const BookmarkShowFeedsPage()
      },
    ];
    tabController  = TabController(length: tabItems.length, vsync: this, initialIndex: 0);
  }


  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

}