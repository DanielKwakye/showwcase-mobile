import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_dot_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = AppStorage.currentUserSession!;
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        pushToProfile(context, user: user);
        pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: CustomUserAvatarWidget(username: user.username!,
                    networkImage: user.profilePictureKey,
                    borderSize: user.role == "community_lead" ? 2 : 0,
                    borderColor: user.role == "community_lead" ?  kAppGold : null,
                    size: 42,
                  ),
                ),
                Positioned(
                    right: -5,
                    bottom: -5,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark ?  const Color(0xff14171A) : kAppWhite,
                          borderRadius: BorderRadius.circular(1000)
                      ),
                      child: Center(
                        child: Text(user.activity?.emoji != null && !user.activity!.emoji!.contains('?') ? user.activity!.emoji! : '🔎', style: TextStyle(
                            color: theme.colorScheme.onBackground,fontSize: 12
                        ),),
                      ),// emoji,
                    )
                ),

              ],
            ),
            const SizedBox(height: 8,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(user.displayName ?? '', style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w800, fontSize: 22),),
                const SizedBox(height: 3,),
                Text('@${user.username!}', style:  TextStyle(color: theme.colorScheme.onPrimary),),
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // state._moveToCirclesPage(tabIndex: 1)
                    context.push(context.generateRoutePath(subLocation: circlesPage), extra: {
                      "user": AppStorage.currentUserSession!,
                      "initialTabIndex": 1
                    });
                  },
                  child: RichText(
                    text: TextSpan(
                      text: '${user.totalFollowers ?? 0} ',
                      style:  theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w800),
                      children: <TextSpan>[
                        TextSpan(text: ' Followers', style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xff999999), fontWeight: FontWeight.normal, )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15,),
                const CustomDotWidget(),
                const SizedBox(width: 15,),
                GestureDetector(
                  onTap: () {
                    //state._moveToCirclesPage(tabIndex: 2)
                    context.push(context.generateRoutePath(subLocation: circlesPage), extra: {
                      "user": AppStorage.currentUserSession!,
                      "initialTabIndex": 2
                    });
                  },
                  child: RichText(
                    text: TextSpan(
                      text: '${user.totalFollowing ?? 0} ',
                      style:  theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w800),
                      children:  <TextSpan>[
                        TextSpan(text: ' Following', style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xff999999), fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                ),

              ],
            )

          ],

        ),
      ),
    );
  }
}
