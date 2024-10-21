import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/sliver_appbar_tabbar_delegate.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/dashboard/presentation/widgets/dashboard_shows.dart';
import 'package:showwcase_v3/features/dashboard/presentation/widgets/dashboard_stat.dart';
import 'package:showwcase_v3/features/dashboard/presentation/widgets/dashboard_threads.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  DashboardPageController createState() => DashboardPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _DashboardPageView extends WidgetView<DashboardPage, DashboardPageController> {
  const _DashboardPageView(DashboardPageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            CustomInnerPageSliverAppBar(
              pageTitle: 'Dashboard',
              pinned: true,
              backgroundColor: theme.colorScheme.primary,
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: DashboardStats(),
                ),
              ]),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverAppBarTabBarDelegate(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  tabBar: TabBar(
                    isScrollable: false,
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    indicator: const UnderlineTabIndicator(
                        insets: EdgeInsets.only(
                          left: 0,
                          right: 20,
                          bottom: 0,
                        ),
                        borderSide: BorderSide(color: kAppBlue, width: 2)),
                    labelPadding: const EdgeInsets.only(left: 0, right: 20),
                    controller: state.tabController,
                    labelColor: theme.colorScheme.onBackground,
                    // unselectedLabelColor: theme.colorScheme.onPrimary, // change unselected color with this
                    tabs: const [
                      Tab(
                        child: Text('Shows',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      Tab(
                        child: Text('Threads',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  )),
            ),
          ];
        },
        body: TabBarView(
            controller: state.tabController,
            children: const [
              DashboardShowPage(),
              DashboardThreadPage(),
            ]),
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class DashboardPageController extends State<DashboardPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => _DashboardPageView(this);

  late TabController tabController;

  @override
  initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }
}
