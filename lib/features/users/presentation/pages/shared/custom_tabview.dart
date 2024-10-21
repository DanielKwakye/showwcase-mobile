import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';

class CustomTabview extends StatefulWidget {

  const CustomTabview({Key? key}) : super(key: key);

  @override
  CustomTabviewController createState() => CustomTabviewController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _CustomTabviewView extends WidgetView<CustomTabview, CustomTabviewController> {

  const _CustomTabviewView(CustomTabviewController state) : super(state);

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

class CustomTabviewController extends State<CustomTabview> {

  @override
  Widget build(BuildContext context) => _CustomTabviewView(this);

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

}