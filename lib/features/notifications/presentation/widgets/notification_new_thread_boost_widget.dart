import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/notifications/data/models/notification_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_message_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class NotificationNewThreadBoostWidget extends StatelessWidget {
  final NotificationModel notificationResponse;

  const NotificationNewThreadBoostWidget(
      {required this.notificationResponse, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<UserModel> users = notificationResponse.initiators ?? [] ;
    users = removeDuplicates(users);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.push(context.generateRoutePath(subLocation: threadPreviewPage),
            extra:  notificationResponse.data!.thread?.parent ?? notificationResponse.data!.thread!);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/svg/boosted.svg',
            height: 32,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Wrap(
                 spacing: 5,
                 children: [
                   ...users.map((user) => CustomUserAvatarWidget(
                     username: user.username,
                     size: 32,
                     networkImage: user.profilePictureKey,
                     borderSize: 0,
                   ))
                 ],
               )
              ,
              const SizedBox(
                height: 5,
              ),

              /// boosted thread
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
                          style:
                              const TextStyle(fontWeight: FontWeight.w700));
                    }),
                    const TextSpan(text: ' boosted your', style: TextStyle(fontWeight: FontWeight.w500,color: kAppGreen)),
                    const TextSpan(
                        text: ' Thread',
                        style: TextStyle(fontWeight: FontWeight.w500)),

                    /// Location of past
                    if (notificationResponse.data?.thread?.community !=
                            null &&
                        notificationResponse.data?.thread?.community?.name !=
                            null) ...{
                      // const TextSpan(text: ' in'),
                      TextSpan(
                          text:
                              ' in ${notificationResponse.data?.thread?.community?.name}',
                          style:
                              const TextStyle(fontWeight: FontWeight.w600)),
                    },
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              ThreadMessageWidget(
                threadModel: notificationResponse.data!.thread!,
                textColor: theme(context).colorScheme.onBackground,
              ),
            ],
          ))
        ],
      ),
    );
  }
}
