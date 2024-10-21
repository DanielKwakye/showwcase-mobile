
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';

class NotificationAppBarWidget extends StatelessWidget {
  final bool pinned;
  final bool floating;
  final Function() onProfileTapped;
  const NotificationAppBarWidget({Key? key, this.pinned = true, this.floating = false, required this.onProfileTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
      automaticallyImplyLeading: false,
      expandedHeight: kToolbarHeight,
      pinned: pinned,
      floating: floating,
      centerTitle: true,
      elevation: 0,
      backgroundColor: theme.colorScheme.background.withAlpha(200),
      // backgroundColor: Colors.red,
      // backgroundColor: Colors.transparent,
      leading: GestureDetector(
        onTap: (){
          onProfileTapped.call();
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: UnconstrainedBox(
              child: CustomUserAvatarWidget(
                username: AppStorage.currentUserSession?.username ?? 'Showwcase',
                size: 30,
                borderSize: 0,
                dimension: '100x',
                networkImage: AppStorage.currentUserSession?.profilePictureKey,
              )),
        ),
      ),
      // flexibleSpace: Platform.isIOS ? ClipRRect(
      //   child: BackdropFilter(
      //     filter: ImageFilter.blur(
      //       sigmaX: 5.0,
      //       sigmaY: 5.0,
      //     ),
      //     child: Container(color: Colors.transparent,),
      //   ),
      // ): null,
      title: Text("Notifications", style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w700,fontSize: defaultFontSize),),
      actions: [

        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            context.push(context.generateRoutePath(subLocation: explorePage));
            // changeScreenWithConstructor(context, const SearchPage());
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: SvgPicture.asset(kSearchIconSvg, color: theme.colorScheme.onBackground, width: 18)),
            //NotificationBadgeWidget(size: 27,),
          ),
        ),
        // Expanded(child: GestureDetector(
        //   behavior: HitTestBehavior.opaque,
        //   onTap: (){
        //     changeScreenWithConstructor(context, const DiscoverCommunities());
        //   },
        //   child: Align(
        //     alignment: Alignment.centerRight,
        //     child: Padding(
        //         padding: const EdgeInsets.only(right: 20),
        //         child: SvgPicture.asset(kCommunitiesIconSvg, color: theme.colorScheme.onBackground, width: 24)),
        //     //NotificationBadgeWidget(size: 27,),
        //   ),
        // )),
        // Expanded(child: ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            context.push(context.generateRoutePath(subLocation: jobsPage));
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: SvgPicture.asset('assets/svg/briefcase_outline.svg', color: theme.colorScheme.onBackground, width: 24)),
            //NotificationBadgeWidget(size: 27,),
          ),
        )
      ],

    );
  }
}
