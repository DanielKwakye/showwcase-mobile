import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/notifications/data/models/notification_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/flavors.dart';


class NotificationInitialPostWidget extends StatelessWidget {

  final NotificationModel notificationResponse;
  const NotificationInitialPostWidget({
    required this.notificationResponse,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: kAppBlue.withOpacity(0.4)
              ),
              child: const Icon(Icons.edit, size: 13, color: kAppBlue,),
            ),
            const SizedBox(width: 10,),

            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: 'Introduce yourself to the Showwcase community by posting a ',
                    style: TextStyle(color: theme(context).colorScheme.onBackground, fontSize: (defaultFontSize - 1)),
                    children: [
                      TextSpan(text: 'Thread', style: TextStyle(color: theme(context).colorScheme.onBackground, fontSize: (defaultFontSize - 1), fontWeight: FontWeight.w800),)
                    ]
                  ),
                ),
                const SizedBox(height: 5,),
                CustomButtonWidget(text: 'Post a thread', onPressed: () {
                  context.push(threadEditorPage, extra:  {
                    'community': CommunityModel( // create a dummy notification object for introduction
                        id: F.appFlavor == Flavor.beta ? 13 : 1, // Introduction community ids based on flavor
                        name: "Introductions",
                        slug: "introductions",
                        userId: AppStorage.currentUserSession?.id,
                        pictureKey: "7/1622778978025-Introductions.jpg",
                    )
                  });

                },)

              ],
            )),


          ],
        ),




      ],
    );
  }
}
