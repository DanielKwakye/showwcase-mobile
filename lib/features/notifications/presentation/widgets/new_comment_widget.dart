import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/notifications/data/models/notification_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';

class NotificationNewCommentWidget extends StatelessWidget {

  final NotificationModel notificationResponse;
  const NotificationNewCommentWidget({
    required this.notificationResponse,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(builder: (_)
        //     => ProfilePage(user: notificationResponse.initiators!.first),settings: RouteSettings(arguments: {'page_title':'profile_page','page_id': notificationResponse.initiators!.first.id}),
        // ));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [

                  Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: kAppBlue.withOpacity(0.4)
                    ),
                    child: const Icon(Icons.person, size: 13, color: kAppBlue,),
                  ),
                  const SizedBox(width: 10,),

                  if(notificationResponse.initiators != null) ... {
                    ...notificationResponse.initiators!.map(
                            (user) => CustomUserAvatarWidget(username: user.username, networkImage: user.profilePictureKey,)
                    )
                  },


                ],
              ),
            ),

            const SizedBox(height: 5,),

            /// new follower

            const SizedBox(height: 0,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                text: TextSpan(
                  text: '',
                  style: TextStyle(color: theme(context).colorScheme.onBackground, fontSize: (defaultFontSize - 1)),
                  children: <TextSpan>[
                    ...notificationResponse.initiators!.map((user) {
                      final index = notificationResponse.initiators!.indexOf(user);
                      String concatenation = '';

                      if(index == 1){
                        if(notificationResponse.initiators!.length == 2){
                          concatenation = ' and ';
                        }else {
                          concatenation = ', ';
                        }

                      }else if(index > 1) {
                        if(index == notificationResponse.initiators!.length - 1){
                          concatenation = ' and ';
                        }else{
                          concatenation = ', ';
                        }
                      }
                      return TextSpan(text: "$concatenation${user.displayName}", style: const TextStyle());
                    }),
                    const TextSpan(text: ' commented on your  ', style: TextStyle()),
                    const TextSpan(text: ' Show ', style: TextStyle(fontWeight: FontWeight.w600)),
                    // const TextSpan(text: ' you ', style: TextStyle()),

                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),


          ],
        ),
      ),
    );
  }
}
