import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/notifications/data/models/notification_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_message_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class NotificationNewThreadReplyWidget extends StatelessWidget {

  final NotificationModel notificationResponse;

  const NotificationNewThreadReplyWidget({
    required this.notificationResponse,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<UserModel> users = notificationResponse.initiators ?? [] ;
    users = removeDuplicates(users);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        context.push(context.generateRoutePath(subLocation: threadPreviewPage), extra: notificationResponse.data!.thread?.parent ?? notificationResponse.data!.thread!, );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset('assets/svg/comment.svg',height: 32,),
              const SizedBox(width: 10,),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      ...users.map((user) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CustomUserAvatarWidget(
                          username: user.username,
                          size: 32,
                          networkImage: user.profilePictureKey,
                          borderSize: 0,
                        ),
                      ))
                    ],
                  )
                ,
                  const SizedBox(
                    height: 10,
                  ),
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
                          final displayName = user.displayName;

                          return TextSpan(text: "$concatenation$displayName", style: const TextStyle(
                              fontWeight: FontWeight.w600));
                        }),
                         TextSpan(text: ' replied your', style: TextStyle(fontWeight: FontWeight.w500,color: theme(context).colorScheme.onPrimary,)),
                        const TextSpan(text: ' Thread', style: TextStyle(fontWeight: FontWeight.w600)),

                        /// Location of past
                        if(notificationResponse.data?.thread?.community != null &&
                            notificationResponse.data?.thread?.community?.name != null)...{
                          // const TextSpan(text: ' in'),
                          TextSpan(text: ' in ${notificationResponse.data?.thread?.community?.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        },


                      ],
                    ),
                  ),
                  const SizedBox(height: 5,),
                  ThreadMessageWidget(
                    threadModel: notificationResponse.data!.reply!,
                    textColor: theme(context).colorScheme.onBackground,
                  ),
                ],
              )),
            ],
          ),
        ],


      ),
    );
  }
}
