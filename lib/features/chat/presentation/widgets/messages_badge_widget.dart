import 'package:flutter/material.dart';
import 'package:flutter_animator/animation/animation_preferences.dart';
import 'package:flutter_animator/animation/animator_play_states.dart';
import 'package:flutter_animator/widgets/attention_seekers/swing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_cubit.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_state.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_notifications_totals_model.dart';



class MessagesBadgeWidget extends StatefulWidget {

  final double? size;
  final bool active;
  const MessagesBadgeWidget({
    this.size,
    this.active = false,
    Key? key}) : super(key: key);

  @override
  MessagesBadgeController createState() => MessagesBadgeController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _MessagesBadgeView extends WidgetView<MessagesBadgeWidget, MessagesBadgeController> {

  const _MessagesBadgeView(MessagesBadgeController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocSelector<ChatCubit, ChatState, ChatNotificationsTotalModel>(
      bloc: state._chatCubit,
      selector:(state){
        return state.notificationTotals;
      } ,
      builder: (context, ChatNotificationsTotalModel totals) {
        final count = totals.totalUnreadChats > 0 ? totals.totalUnreadChats : ((totals.totalPendingRequests > 0) ? totals.totalPendingRequests : 0);
        debugPrint("ChatNotification: count called: count -> $count");
        return Swing(
            preferences: AnimationPreferences(
                duration: const Duration(seconds: 1),
                autoPlay: count > 0 ? AnimationPlayStates.Reverse : AnimationPlayStates.None),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  widget.active ?  'assets/svg/mail_solid.svg' : 'assets/svg/mail.svg',
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(widget.active ? kAppBlue : theme.colorScheme.onBackground, BlendMode.srcIn),

                ),
                if(count > 0) ... {
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

class MessagesBadgeController extends State<MessagesBadgeWidget> {


  @override
  Widget build(BuildContext context) => _MessagesBadgeView(this);

  late ChatCubit _chatCubit;


  @override
  initState(){
    super.initState();
    _chatCubit = context.read<ChatCubit>();
  }

}