import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/functions.dart';

class SwipeBackTabviewWrapperWidget extends StatelessWidget {

  final Widget child;
  final Function()? onBackSwiped;
  const SwipeBackTabviewWrapperWidget({Key? key, required this.child, this.onBackSwiped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        // debugPrint("$notification");
        if(notification is OverscrollNotification){
          // debugPrint("notification:  ${notification.dragDetails?.delta.distance}");
          if(notification.dragDetails != null){
            final bool forward = notification.dragDetails!.delta.dx > 0;
            if(forward == true){
              onBackSwiped == null ? pop(context) : onBackSwiped?.call();
            }
          }
        }
        return false;
      },
      child: child,
    );
  }
}
