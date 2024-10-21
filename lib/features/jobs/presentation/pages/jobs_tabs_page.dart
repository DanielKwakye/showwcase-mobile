import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/companies/presentation/pages/company_feeds_page.dart';
import 'package:showwcase_v3/features/jobs/presentation/pages/bookmarked_jobs_page.dart';
import 'package:showwcase_v3/features/jobs/presentation/pages/job_feeds_page.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/swipe_back_tabview_wrapper_widget.dart';

class JobsTabsPage extends StatefulWidget {

  const JobsTabsPage({Key? key}) : super(key: key);

  @override
  JobsTabsPageController createState() => JobsTabsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _JobsTabsPageView extends WidgetView<JobsTabsPage, JobsTabsPageController> {

  const _JobsTabsPageView(JobsTabsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: theme.colorScheme.onBackground,),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: theme.colorScheme.background,
          title: Text("Work",  style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w700,fontSize: defaultFontSize ),),
        ),
        body: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                  border: Border(
                      bottom:
                      BorderSide(color: theme.colorScheme.outline))
              ),
              child: TabBar(
                controller: state.pageController,
                tabs:  List.generate(state.pageItems.length, (index) => index).map((index) {
                  final tabItem = state.pageItems[index];
                  String text = tabItem['text'] as String;
                  return Tab(text: text,);
                }).toList(),
              ),
            ),
            Expanded(
              child: SwipeBackTabviewWrapperWidget(
                child: TabBarView(
                  controller: state.pageController,
                  children: List.generate(state.pageItems.length, (index) => index).map((index) {
                    final tabItem = state.pageItems[index];
                    Widget page = tabItem['page'] as Widget;
                    return page;
                  }).toList(),
                  //     ),
                ),
              ),
            ),
          ],
        )
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class JobsTabsPageController extends State<JobsTabsPage> with TickerProviderStateMixin  {

  late List<Map<String, dynamic>> pageItems;
  late TabController pageController ;
  final ValueNotifier<int> activeStepIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) => _JobsTabsPageView(this);

  @override
  void initState() {
    super.initState();
    pageItems = [

      <String, dynamic>{
        'index': 0,
        'text': "Find jobs",
        'type': "find-work",
        'page': const JobFeedsPage()
      },
      <String, dynamic>{
        'index': 1,
        'text': 'Saved Jobs',
        'type': "saved-jobs",
        'page': const  BookmarkedJobsPage()
      },

    ];
    pageController  = TabController(length: pageItems.length, vsync: this, initialIndex: 0);

  }

  void _onPageChanged(int index) {
    activeStepIndex.value = index;
  }

  @override
  void dispose() {
    super.dispose();
  }

}