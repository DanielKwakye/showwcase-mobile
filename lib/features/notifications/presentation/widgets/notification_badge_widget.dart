import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animator/animation/animation_preferences.dart';
import 'package:flutter_animator/animation/animator_play_states.dart';
import 'package:flutter_animator/widgets/attention_seekers/swing.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_cubit.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_state.dart';


class NotificationBadgeWidget extends StatefulWidget {

  final double? size;
  final bool active;
  const NotificationBadgeWidget({
    this.size,
    this.active = false,
    Key? key}) : super(key: key);

  @override
  NotificationBadgeController createState() => NotificationBadgeController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _NotificationBadgeView extends WidgetView<NotificationBadgeWidget, NotificationBadgeController> {

  const _NotificationBadgeView(NotificationBadgeController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocSelector<NotificationCubit, NotificationState, int>(
      bloc: state._notificationCubit,
      selector: (notificationState){
          return notificationState.total;
      },
      builder: (context, count) {
        // final count = notificationState.total;
        return Swing(
            preferences: AnimationPreferences(
                duration: const Duration(seconds: 1),
                autoPlay: count > 0 ? AnimationPlayStates.Reverse : AnimationPlayStates.None),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // const SizedBox(width: 5,),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: SvgPicture.asset(
                    widget.active ? "assets/svg/notification_solid.svg" : "assets/svg/notification_icon.svg",
                    width: widget.size ??( widget.active ? 20 : 20),
                    height: widget.active ? 20 : 20,
                    colorFilter:  ColorFilter.mode(widget.active ? kAppBlue : theme.colorScheme.onBackground, BlendMode.srcIn),

                  ),
                ),
                if(
                count > 0
                //true
                ) ... {
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(100)),
                      height: 20,
                      width: 20,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                        child: FittedBox(
                          child: Text(
                            '$count',
                            // '20',
                            style: const TextStyle(color: kAppWhite),
                          ),
                        ),
                      ),
                    ),
                  )
                },

                // const SizedBox(
                //   width: 15,
                // ),
              ],
            ));
      },
    );
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class NotificationBadgeController extends State<NotificationBadgeWidget> {


  @override
  Widget build(BuildContext context) => _NotificationBadgeView(this);

  late NotificationCubit _notificationCubit;
  late StreamSubscription<NotificationState> notificationStateStreamSubscription;


  @override
  initState(){
    super.initState();
    _notificationCubit = context.read<NotificationCubit>();
    fetchNotificationsTotal();
    notificationStateStreamSubscription = _notificationCubit.stream.listen((event) async {
      final total = event.total ;
      final supported = await FlutterAppBadger.isAppBadgeSupported();
      if(supported) {
        if(total > 0) {
          FlutterAppBadger.updateBadgeCount(total);
        }else{
          FlutterAppBadger.removeBadge();
        }
      }
    });
  }


  
  void fetchNotificationsTotal(){
    _notificationCubit.fetchNotificationTotal();
  }


  @override
  void dispose() {
    super.dispose();
    notificationStateStreamSubscription.cancel();
  }

}