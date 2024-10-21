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

class NotificationNewFollowerWidget extends StatelessWidget {
  final NotificationModel notificationResponse;

  const NotificationNewFollowerWidget(
      {required this.notificationResponse, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<UserModel> users = notificationResponse.initiators ?? [] ;
    users = removeDuplicates(users);
    return GestureDetector(
     behavior: HitTestBehavior.opaque,
      onTap: () {
       if(users.length == 1){
          context.push(context.generateRoutePath(subLocation: publicProfilePage,),extra: users.first);
       }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/svg/following.svg',
            height: 32,
          ),
          const SizedBox(
            width: 10,
          ),
          /// new follower
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...{
              Wrap(
                children: [
                  ...users
                      .map((user) => GestureDetector(
                        onTap: (){
                          context.push(context.generateRoutePath(subLocation: publicProfilePage,),extra: user);
                        },
                        child: CustomUserAvatarWidget(
                    username: user.username,
                    size: 32,
                    networkImage: user.profilePictureKey,
                    borderSize: 0,
                  ),
                      ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                  text: '',
                  style: TextStyle(
                      color: theme(context).colorScheme.onBackground,
                      fontSize: (defaultFontSize - 1)),
                  children: <TextSpan>[
                    ...users.map((user) {
                      final index =
                      users.indexOf(user);
                      String concatenation = '';

                      if (index == 1) {
                        if (users.length == 2) {
                          concatenation = ' and ';
                        } else {
                          concatenation = ', ';
                        }
                      } else if (index > 1) {
                        if (index ==
                            users.length - 1) {
                          concatenation = ' and ';
                        } else {
                          concatenation = ', ';
                        }
                      }
                      return TextSpan(
                          text: "$concatenation${user.displayName}",
                          style: const TextStyle(fontWeight: FontWeight.w700));
                    }),
                    const TextSpan(text: ' started ', style: TextStyle()),
                    const TextSpan(
                        text: ' Following ',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const TextSpan(text: ' you ', style: TextStyle()),
                  ],
                ),
              ),
            },
            ],
          ))
        ],
      ),
    );
  }
}
