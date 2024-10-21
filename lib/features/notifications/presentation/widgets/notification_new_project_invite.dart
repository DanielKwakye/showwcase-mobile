import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/mix/launch_external_app_mixin.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/notifications/data/models/notification_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';


class NotificationNewProjectInviteWidget extends StatelessWidget with LaunchExternalAppMixin {

  final NotificationModel notificationResponse;
  const NotificationNewProjectInviteWidget({
    required this.notificationResponse,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<UserModel> users = notificationResponse.initiators ?? [] ;
    users = removeDuplicates(users);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        context.push(context.generateRoutePath(subLocation: showPreviewPage,),extra: notificationResponse.data?.project);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/svg/invite.svg',
            height: 32,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  children: [
                    ...users.map((user) => CustomUserAvatarWidget(
                      username: user.username,
                      size: 32,
                      networkImage: user.profilePictureKey,
                      borderSize: 0,
                    ))
                  ],
                ),
                const SizedBox(height: 5,),
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
                       const TextSpan(text: ' added you as a', style: TextStyle()),
                       const TextSpan(text: ' Contributor', style: TextStyle(fontWeight: FontWeight.w600)),

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
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: theme(context).colorScheme.outline),
                      //color: theme(context).colorScheme.surface,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notificationResponse.data!.project!.title!,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 5,),
                        Text(
                          notificationResponse.data!.project?.projectSummary ?? '',
                          style:  TextStyle(fontWeight: FontWeight.w700,fontSize: 13,color: theme(context).colorScheme.onPrimary),
                        ),
                        const SizedBox(height: 5,),
                      if(notificationResponse.data!.project!.publishedDate != null)  Text(
                          getFormattedDateWithIntl(notificationResponse.data!.project!.publishedDate!,format: 'd MMMM'),
                          style:  TextStyle(fontWeight: FontWeight.w700,fontSize: 13,color: theme(context).colorScheme.onPrimary),
                        ),
                      ],
                    ),
                  ),

                ],


            ),
          ),
        ],
      ),
    );
  }
}
