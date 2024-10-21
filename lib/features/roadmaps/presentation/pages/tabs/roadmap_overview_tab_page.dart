import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_model.dart';

class RoadmapOverviewTabPage extends StatefulWidget {

  final RoadmapModel roadmapModel;
  const RoadmapOverviewTabPage({Key? key, required this.roadmapModel}) : super(key: key);

  @override
  RoadmapOverviewTabPageController createState() => RoadmapOverviewTabPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _RoadmapOverviewTabPageView extends WidgetView<RoadmapOverviewTabPage, RoadmapOverviewTabPageController> {

  const _RoadmapOverviewTabPageView(RoadmapOverviewTabPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Container()
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class RoadmapOverviewTabPageController extends State<RoadmapOverviewTabPage> {

  @override
  Widget build(BuildContext context) => _RoadmapOverviewTabPageView(this);

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

}