import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';

class SpacesInfoPage extends StatefulWidget {

  const SpacesInfoPage({Key? key}) : super(key: key);

  @override
  SpacesInfoPageController createState() => SpacesInfoPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SpacesInfoPageView extends WidgetView<SpacesInfoPage, SpacesInfoPageController> {

  const _SpacesInfoPageView(SpacesInfoPageController state) : super(state);

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

class SpacesInfoPageController extends State<SpacesInfoPage> {

  @override
  Widget build(BuildContext context) => _SpacesInfoPageView(this);

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

}