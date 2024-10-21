import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';

class ThreadFeedsAppBarWidget extends StatelessWidget {
  final bool pinned;
  final bool floating;
  final Function() onProfileIconTapped;
  const ThreadFeedsAppBarWidget({Key? key, this.pinned = true, this.floating = false, required this.onProfileIconTapped}) : super(key: key);

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
          onProfileIconTapped.call();
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
      title: IgnorePointer(
          ignoring: true,
          child: Hero(
            tag: "app-logo",
            child: SvgPicture.asset(
              kLogoSvg,
              colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn),
              width: 30,
            ),
          ),
        ),
      actions: [

      GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            context.push(context.generateRoutePath(subLocation: explorePage));
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: SvgPicture.asset(kSearchIconSvg, width: 18,colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn))),
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
                child: SvgPicture.asset('assets/svg/briefcase_outline.svg', colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn), width: 24)),
            //NotificationBadgeWidget(size: 27,),
          ),
        )
      ],
      // flexibleSpace: FlexibleSpaceBar(
      //   background: ColoredBox(
      //     color: theme.colorScheme.background.withOpacity(0.5),
      //     child: ClipRRect(
      //       child: BackdropFilter(
      //         filter: ImageFilter.blur(
      //           sigmaX: 10.0,
      //           sigmaY: 10.0,
      //         ),
      //         child: Opacity(
      //           //you can change the opacity to whatever suits you best
      //           opacity: 0.7,
      //           child: SafeArea(
      //             child: SizedBox(
      //               width: mediaQuery.size.width,
      //               child: LayoutBuilder(builder: (ctx, ctr) {
      //                 final eachWidth = ctr.maxWidth / 3;
      //                 return Row(
      //                   children: [
      //                     SizedBox(
      //                       width: eachWidth,
      //                       child: Align(
      //                         alignment: Alignment.centerLeft,
      //                         child: GestureDetector(
      //                           onTap: (){
      //                             debugPrint("Profile image tapped");
      //                           },
      //                           child: Padding(
      //                             padding: const EdgeInsets.only(left: 20),
      //                             child: UnconstrainedBox(
      //                                 child: CustomUserAvatarWidget(
      //                                   username: AppStorage.currentUserSession?.username ?? 'Showwcase',
      //                                   size: 30,
      //                                   borderSize: 0,
      //                                   dimension: '100x',
      //                                   networkImage: AppStorage.currentUserSession?.profilePictureKey,
      //                                 )),
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                     IgnorePointer(
      //                       ignoring: true,
      //                       child: SizedBox(
      //                         width: eachWidth + 0,
      //                         child: Align(
      //                           alignment: Alignment.center,
      //                           child: Hero(
      //                             tag: "app-logo",
      //                             child: SvgPicture.asset(
      //                               kLogoSvg,
      //                               colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn),
      //                               width: 26,
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                     SizedBox(
      //                       width: eachWidth - 0,
      //                       child:  Row(
      //                         mainAxisAlignment: MainAxisAlignment.end,
      //                         children: [
      //                           // Expanded(child: ),
      //                           GestureDetector(
      //                             behavior: HitTestBehavior.opaque,
      //                             onTap: (){
      //                               // changeScreenWithConstructor(context, const SearchPage());
      //                             },
      //                             child: Align(
      //                               alignment: Alignment.centerRight,
      //                               child: Padding(
      //                                   padding: const EdgeInsets.only(right: 20),
      //                                   child: SvgPicture.asset(kSearchIconSvg, color: theme.colorScheme.onBackground, width: 18)),
      //                               //NotificationBadgeWidget(size: 27,),
      //                             ),
      //                           ),
      //                           // Expanded(child: GestureDetector(
      //                           //   behavior: HitTestBehavior.opaque,
      //                           //   onTap: (){
      //                           //     changeScreenWithConstructor(context, const DiscoverCommunities());
      //                           //   },
      //                           //   child: Align(
      //                           //     alignment: Alignment.centerRight,
      //                           //     child: Padding(
      //                           //         padding: const EdgeInsets.only(right: 20),
      //                           //         child: SvgPicture.asset(kCommunitiesIconSvg, color: theme.colorScheme.onBackground, width: 24)),
      //                           //     //NotificationBadgeWidget(size: 27,),
      //                           //   ),
      //                           // )),
      //                           // Expanded(child: ),
      //                           GestureDetector(
      //                             behavior: HitTestBehavior.opaque,
      //                             onTap: (){
      //                               // changeScreenWithConstructor(context, const JobsPage());
      //                             },
      //                             child: Align(
      //                               alignment: Alignment.centerRight,
      //                               child: Padding(
      //                                   padding: const EdgeInsets.only(right: 20),
      //                                   child: SvgPicture.asset('assets/svg/briefcase_outline.svg', color: theme.colorScheme.onBackground, width: 24)),
      //                               //NotificationBadgeWidget(size: 27,),
      //                             ),
      //                           )
      //
      //                           // GestureDetector(
      //                           //   behavior: HitTestBehavior.opaque,
      //                           //   onTap: (){
      //                           //     changeScreenWithConstructor(context, const ChatPage());
      //                           //   },
      //                           //   child: Align(
      //                           //     alignment: Alignment.centerRight,
      //                           //     child: Padding(
      //                           //         padding: const EdgeInsets.only(right: 20),
      //                           //         child: SvgPicture.asset('assets/svg/mail_solid.svg', color: theme.colorScheme.onBackground, width: 24)),
      //                           //     //NotificationBadgeWidget(size: 27,),
      //                           //     ),
      //                           // ),
      //                         ],
      //                       ),
      //                     ),
      //                   ],
      //                 );
      //               }),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      //
      // ),

    );
  }
}
