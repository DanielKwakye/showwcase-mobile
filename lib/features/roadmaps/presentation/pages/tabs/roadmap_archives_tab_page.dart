import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_model.dart';
import 'package:showwcase_v3/features/roadmaps/presentation/pages/tabs/roadmap_archived_series_tab_page.dart';
import 'package:showwcase_v3/features/roadmaps/presentation/pages/tabs/roadmap_archived_shows_tab_page.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';

class RoadmapArchivesTabPage extends StatefulWidget {

  final RoadmapModel roadmapModel;
  const RoadmapArchivesTabPage({Key? key, required this.roadmapModel}) : super(key: key);

  @override
  RoadmapArchivesTabPageController createState() => RoadmapArchivesTabPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _RoadmapArchivesTabPageView extends WidgetView<RoadmapArchivesTabPage, RoadmapArchivesTabPageController> {

  const _RoadmapArchivesTabPageView(RoadmapArchivesTabPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Column(
      children: [
        TabBar(
          isScrollable: false,
          labelColor: theme.colorScheme.onBackground,
          controller: state.tabController,
          // indicatorWeight: 1,
          indicator: const UnderlineTabIndicator(
              insets: EdgeInsets.only(
                left: 0,
                right: 20,
                bottom: 0,
              ),
              borderSide:
              BorderSide(color: kAppBlue, width: 2)),
          tabs: [
            ...state.tabItems.map((e) => Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: <Widget>[
                  Text(e['text'] as String,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ))
          ],
        ),
        const CustomBorderWidget(),
        Expanded(child: TabBarView(
          controller: state.tabController,
          children:  [

            ...state.tabItems.map((e) {
              return e['page'] as Widget;
            })

        ],
        ),)
      ],
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class RoadmapArchivesTabPageController extends State<RoadmapArchivesTabPage> with TickerProviderStateMixin {

  late List<Map<String, dynamic>> tabItems;
  late TabController tabController;

  @override
  Widget build(BuildContext context) => _RoadmapArchivesTabPageView(this);

  @override
  void initState() {
    tabItems = [
      <String, dynamic>{
        'index': 0,
        'text': "Shows",
        'sub_text': "shows-archive", // set a string here to include any subtext on the tab
        'page': RoadmapArchivedShowsTabPage(roadmapModel: widget.roadmapModel,)
      },
      <String, dynamic>{
        'index': 3,
        'text': 'Series',
        'sub_text': "series-archive", // set a string here to include any subtext on the tab
        'page': RoadmapArchivedSeriesTabPage(roadmapModel: widget.roadmapModel,)
      },
    ];
    tabController = TabController(length: tabItems.length, vsync: this);
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

}