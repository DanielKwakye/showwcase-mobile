import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/home/presentation/widgets/drawer_body_widget.dart';
import 'package:showwcase_v3/features/home/presentation/widgets/drawer_header_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';

class DrawerPage extends StatefulWidget {

  const DrawerPage({Key? key}) : super(key: key);

  @override
  DrawerPageController createState() => DrawerPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _DrawerPageView extends WidgetView<DrawerPage, DrawerPageController> {

  const _DrawerPageView(DrawerPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return  Material(
      color: theme.colorScheme.background,
      child: const SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20,),
            DrawerHeaderWidget(),
            CustomBorderWidget(left: 20, right: 20, top: 20, bottom: 15,),
            Expanded(child: DrawerBodyWidget())
          ],
        ),
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class DrawerPageController extends State<DrawerPage> {



  @override
  Widget build(BuildContext context) => _DrawerPageView(this);

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

}