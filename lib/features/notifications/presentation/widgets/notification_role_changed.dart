import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/notifications/data/models/notification_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class NotificationCommunityRoleChanged extends StatelessWidget {

  final NotificationModel notificationResponse;
  const NotificationCommunityRoleChanged({super.key, required this.notificationResponse,});

  @override
  Widget build(BuildContext context) {
    List<UserModel> users = notificationResponse.initiators ?? [] ;
    users = removeDuplicates(users);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.push(context.generateRoutePath(subLocation: communityPreviewPage,),extra: notificationResponse.data?.community);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/svg/permission.svg',
            height: 32,
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  spacing: 5,
                  children: [
                    ...users.map(
                            (user) => CustomUserAvatarWidget(username: user.username, networkImage: user.profilePictureKey, borderSize: 0,size: 32,)
                    )
                  ],
                )
                ,

                const SizedBox(height: 10,),
                /// new permission assigned
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
                        return TextSpan(text: "$concatenation${user.displayName}", style: const TextStyle(fontWeight: FontWeight.w700));
                      }),
                      const TextSpan(text: ' assigned you permission on ', style: TextStyle()),
                      TextSpan(text: notificationResponse.data?.community?.name ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),


                    ],
                  ),
                ),
                const SizedBox(height: 10,),


              ],
            ),
          ),
        ],
      ),
    );
  }
}
