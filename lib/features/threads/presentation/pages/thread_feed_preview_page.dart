import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';

class ThreadFeedPreviewPage extends StatefulWidget {

  const ThreadFeedPreviewPage({Key? key}) : super(key: key);

  @override
  ThreadFeedPreviewPageController createState() => ThreadFeedPreviewPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ThreadFeedPreviewPageView extends WidgetView<ThreadFeedPreviewPage, ThreadFeedPreviewPageController> {

  const _ThreadFeedPreviewPageView(ThreadFeedPreviewPageController state) : super(state);

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

class ThreadFeedPreviewPageController extends State<ThreadFeedPreviewPage> {

  @override
  Widget build(BuildContext context) => _ThreadFeedPreviewPageView(this);

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

}