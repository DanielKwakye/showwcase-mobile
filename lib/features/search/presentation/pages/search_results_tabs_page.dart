import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/sliver_appbar_tabbar_delegate.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/search/presentation/pages/search_communities_page.dart';
import 'package:showwcase_v3/features/search/presentation/pages/search_people_page.dart';
import 'package:showwcase_v3/features/search/presentation/pages/search_shows_page.dart';
import 'package:showwcase_v3/features/search/presentation/pages/search_threads_page.dart';
import 'package:showwcase_v3/features/search/presentation/pages/search_top_results_page.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/swipe_back_tabview_wrapper_widget.dart';

class SearchResultsTabsPage extends StatefulWidget {

  final String searchText;
  const SearchResultsTabsPage({Key? key, required this.searchText}) : super(key: key);

  @override
  SearchResultsTabsPageController createState() => SearchResultsTabsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SearchResultsTabsPageView extends WidgetView<SearchResultsTabsPage, SearchResultsTabsPageController> {

  const _SearchResultsTabsPageView(SearchResultsTabsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme  = Theme.of(context);

    return Scaffold(
        body: ExtendedNestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [

              /// Search app bar
              SliverAppBar(
                // automaticallyImplyLeading: true,
                backgroundColor: theme.colorScheme.background,
                // leadingWidth: 40,
                iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
                pinned: true,
                elevation: 0,
                expandedHeight: kToolbarHeight,
                actions: [
                  UnconstrainedBox(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        context.push(context.generateRoutePath(subLocation: searchPage));
                      },
                      child: Container(
                        width: width(context) - 75,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                            color:theme.brightness == Brightness.light ? kAppLightGray : kDarkOutlineColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(100)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(kSearchIconSvg, width: 14,colorFilter: ColorFilter.mode(theme.colorScheme.onPrimary.withOpacity(0.5), BlendMode.srcIn)),
                            const SizedBox(width: 5,),
                            Text(widget.searchText, style: TextStyle(fontSize: 14, color: theme.colorScheme.onPrimary.withOpacity(0.5)),)
                          ],
                        ),
                      ),
                    ),
                  )
                ],

              ),

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
          body: SwipeBackTabviewWrapperWidget(
            child: TabBarView(
              controller: state.tabController,
              // physics:  CustomScrollPhysics(state.tabController),
              // physics: const ClampingScrollPhysics(),
              // dragStartBehavior: DragStartBehavior.down,
              children: List.generate(state.tabItems.length, (index) => index).map((index) {
                final tabItem = state.tabItems[index];
                Widget page = tabItem['page'] as Widget;
                return ExtendedVisibilityDetector(
                  uniqueKey: ValueKey("search-tabs-${tabItem['title']}-${tabItem['index']}"),
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

class SearchResultsTabsPageController extends State<SearchResultsTabsPage> with TickerProviderStateMixin {

  late TabController tabController;
  late List<Map<String, dynamic>> tabItems;

  @override
  Widget build(BuildContext context) => _SearchResultsTabsPageView(this);

  @override
  void initState() {

    tabItems = [
      {
        'index': 0,
        'title': 'Top',
        'page': const SearchTopResultsPage()
      },
      {
        'index': 1,
        'title': 'People',
        'page': SearchPeoplePage(searchText: widget.searchText,)
      },
      {
        'index': 2,
        'title': 'Threads',
        'page':   SearchThreadsPage(searchText: widget.searchText,)
      },
      {
        'index': 2,
        'title': 'Shows',
        'page':   SearchShowsPage(searchText: widget.searchText,)
      },
      {
        'index': 2,
        'title': 'Communities',
        'page':   SearchCommunitiesPage(searchText: widget.searchText,)
      },
    ];

    tabController  = TabController(length: tabItems.length, vsync: this, initialIndex: 0);

    super.initState();
  }


  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

}