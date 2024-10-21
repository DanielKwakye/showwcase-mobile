import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/notifications/data/models/notification_model.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_message_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class NotificationNewPollVoteWidget extends StatelessWidget {

  final NotificationModel notificationResponse;
  const NotificationNewPollVoteWidget({
    required this.notificationResponse,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<UserModel> users = notificationResponse.initiators ?? [] ;
    users = removeDuplicates(users);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        context.push(context.generateRoutePath(subLocation: threadPreviewPage), extra: notificationResponse.data!.thread!, );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/svg/poll_notification.svg', height: 32, ),
          const SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// thread mention
                RichText(
                  text: TextSpan(
                    text: '',
                    style: TextStyle(color: theme(context).colorScheme.onBackground, fontSize: (defaultFontSize - 1)),
                    children: <TextSpan>[
                      ...users.map((user) {
                        final index = users.indexOf(user);
                        String concatenation = '';

                        if(index == 1){
                          if(users.length == 2){
                            concatenation = ' and ';
                          }else {
                            concatenation = ', ';
                          }

                        }else if(index > 1) {
                          if(index == users.length - 1){
                            concatenation = ' and ';
                          }else{
                            concatenation = ', ';
                          }
                        }
                        return TextSpan(text: "$concatenation${user.displayName}", style: const TextStyle(fontWeight: FontWeight.w600));
                      }),
                      TextSpan(text: ' just voted on your ', style: TextStyle(fontWeight: FontWeight.w500,color: theme(context).colorScheme.onPrimary)),
                      const TextSpan(text: ' Poll', style: TextStyle(fontWeight: FontWeight.w600)),


                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                ThreadMessageWidget(
                    threadModel: notificationResponse.data!.thread!,
                  textColor: theme(context).colorScheme.onBackground,
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }
}