import 'package:flutter/material.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/notifications/data/models/notification_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_list_tile_widget.dart';

class NotificationInitiatorsPage extends StatefulWidget {

  final NotificationModel notificationModel;
  const NotificationInitiatorsPage({
    required this.notificationModel,
    Key? key}) : super(key: key);

  @override
  NotificationInitiatorsPageController createState() => NotificationInitiatorsPageController();

}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _NotificationInitiatorsPageView extends WidgetView<NotificationInitiatorsPage, NotificationInitiatorsPageController> {

  const _NotificationInitiatorsPageView(NotificationInitiatorsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: CustomScrollView(
            slivers: [
               const CustomInnerPageSliverAppBar(),
               SliverList(delegate: SliverChildListDelegate([
                 ...(widget.notificationModel.initiators ?? <UserModel>[]).map(
                         (user) => SeparatedColumn(
                           mainAxisSize: MainAxisSize.min,
                           separatorBuilder: (BuildContext context, int index) {
                             return const CustomBorderWidget();
                           },
                           children: <Widget>[
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 15),
                               child: UserListTileWidget(userModel: user,),
                             ),

                           ],
                         )
                 )
               ]))
            ],
          ),
        );
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class NotificationInitiatorsPageController extends State<NotificationInitiatorsPage> {

  @override
  Widget build(BuildContext context) => _NotificationInitiatorsPageView(this);

  @override
  void initState() {
    super.initState();
  }

}