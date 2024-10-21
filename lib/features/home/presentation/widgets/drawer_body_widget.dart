import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/drawer_communities_list_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/flavors.dart';

class DrawerBodyWidget extends StatelessWidget {
  const DrawerBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final color = theme.colorScheme.onBackground;
    return  NestedScrollView(headerSliverBuilder: (_, __){
      return [
        SliverToBoxAdapter(
          child: Column(
             children: [
               GestureDetector(
                 onTap: () {
                  pushToProfile(context, user: AppStorage.currentUserSession!);
                   pop(context);
                 },
                 child: Container(
                   width: double.infinity,
                   color: Colors.transparent,
                   padding: const EdgeInsets.only(top: 0, bottom: 12, left: 20, right: 20),
                   child: Row(
                     children: [
                       Icon(FeatherIcons.user, color: color, size: 24,),
                       const SizedBox(width: 13,),
                       Text(
                         'Profile',
                         style: TextStyle(
                             color: color,fontSize: defaultFontSize + 6,fontWeight: FontWeight.normal),
                       )
                     ],
                   ),
                 ),
               ),
               GestureDetector(
                 onTap: () {
                   // state._moveToDashboardPage
                   context.push(context.generateRoutePath(subLocation: dashboardPage));
                   pop(context);
                 },
                 child: Container(
                   width: double.infinity,
                   color: Colors.transparent,
                   padding: const EdgeInsets.only(top: 8, bottom: 12, left: 20, right: 20),
                   child: Row(
                     children: [
                       Icon(FeatherIcons.compass, color: color, size: 24,),
                       const SizedBox(width: 13,),
                       Text('Dashboard',
                         style: TextStyle(
                             color: color,fontSize: defaultFontSize + 6,fontWeight: FontWeight.normal),
                       )
                     ],
                   ),
                 ),
               ),
               GestureDetector(
                 onTap:() {
                   // state._moveToCommunitiesPage
                   context.push(context.generateRoutePath(subLocation: discoverCommunitiesPage));
                   pop(context);
                 },
                 behavior: HitTestBehavior.opaque,
                 child: Container(
                   width: double.infinity,
                   color: Colors.transparent,
                   padding: const EdgeInsets.only(top: 8, bottom: 12, left: 20, right: 20),
                   child: Row(
                     children: [
                       Icon(FeatherIcons.users, color: color, size: 24,),
                       const SizedBox(width: 13,),
                       Text(
                         'Communities',
                         style: TextStyle(
                             color: color,fontSize: defaultFontSize + 6,fontWeight: FontWeight.normal),
                       )
                     ],
                   ),
                 ),
               ),
               GestureDetector(
                 onTap: () {
                   // state._moveToBookMarkPage
                   pop(context); // pop to close drawer
                   context.push(context.generateRoutePath(subLocation: bookmarksPage));
                 },
                 child: Container(
                   width: double.infinity,
                   color: Colors.transparent,
                   padding: const EdgeInsets.only(top: 10, bottom: 12, left: 20, right: 20),
                   child: Row(
                     children: [
                       Icon(FeatherIcons.bookmark, color: color, size: 24,),
                       const SizedBox(width: 13,),
                       Text(
                         'Bookmarks',
                         style: TextStyle(color: color, fontSize: defaultFontSize + 6,fontWeight: FontWeight.normal),
                       ),
                     ],
                   ),
                 ),
               ),
               GestureDetector(
                 onTap: () {
                   context.push(context.generateRoutePath(subLocation: settingsPage));
                   pop(context);
                 },
                 child: Container(
                   width: double.infinity,
                   color: Colors.transparent,
                   padding: const EdgeInsets.only(top: 10, bottom: 12, left: 20, right: 20),
                   child: Row(
                     children:  [
                       Icon(FeatherIcons.settings, color: color, size: 24,),
                       const SizedBox(width: 13,),
                       Text(
                         'Settings',
                         style: TextStyle(color: color, fontSize: defaultFontSize + 6,fontWeight: FontWeight.normal),
                       )
                     ],
                   ),
                 ),
               ),
               if(theme.brightness == Brightness.light) ... {
                 GestureDetector(
                   onTap: () {
                    setThemeMode(context, brightness: Brightness.dark);
                   },
                   child: Container(
                     width: double.infinity,
                     color: Colors.transparent,
                     padding: const EdgeInsets.only(top: 10, bottom: 12, left: 20, right: 20),
                     child: Row(
                       children:  [
                         Icon(FeatherIcons.globe, color: color, size: 24,),
                         const SizedBox(width: 13,),
                         Text(
                           'Dark mode',
                           style: TextStyle(color: color, fontSize: defaultFontSize + 6,fontWeight: FontWeight.normal),
                         )
                       ],
                     ),
                   ),
                 ),
               } else ... {
                 GestureDetector(
                   onTap: () {
                     //  state._lightThemeTap
                     setThemeMode(context, brightness: Brightness.light);
                   },
                   child: Container(
                     width: double.infinity,
                     color: Colors.transparent,
                     padding: const EdgeInsets.only(top: 10, bottom: 12, left: 20, right: 20),
                     child: Row(
                       children:  [
                         Icon(FeatherIcons.globe, color: color, size: 24,),
                         const SizedBox(width: 13,),
                         Text(
                           'Light mode',
                           style: TextStyle(color: color, fontSize: defaultFontSize + 6,fontWeight: FontWeight.normal),
                         )
                       ],
                     ),
                   ),
                 ),
               },
               GestureDetector(
                 onTap: () {
                   context.push(context.generateRoutePath(subLocation: refferalsPage));
                   pop(context);
                 },
                 child: Container(
                   width: double.infinity,
                   color: Colors.transparent,
                   padding: const EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 20),
                   child: Row(
                     children:  [
                       Icon(FeatherIcons.userPlus, color: color, size: 24,),
                       const SizedBox(width: 13,),
                       Text(
                         'Invite',
                         style: TextStyle(color: color, fontSize: defaultFontSize + 6,fontWeight: FontWeight.normal),
                       )
                     ],
                   ),
                 ),
               ),

               // feature halted
               // if( kBetaMode) ... {
               //   GestureDetector(
               //     onTap: () {
               //       context.push(context.generateRoutePath(subLocation: spacesPage));
               //       pop(context);
               //     },
               //     child: Container(
               //       width: double.infinity,
               //       color: Colors.transparent,
               //       padding: const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
               //       child: Row(
               //         children:  [
               //           Icon(FeatherIcons.headphones, color: color, size: 24,),
               //           const SizedBox(width: 13,),
               //           Text(
               //             'Spaces',
               //             style: TextStyle(color: color, fontSize: defaultFontSize + 6,fontWeight: FontWeight.normal),
               //           )
               //         ],
               //       ),
               //     ),
               //   ),
               // },

               // GestureDetector(
               //   onTap: () {
               //     //  state._moveToCirclesPage(tabIndex: 0)
               //     context.read<AuthCubit>().logout();
               //     context.go(walkthroughPage);
               //   },
               //   child: Container(
               //     width: double.infinity,
               //     color: Colors.transparent,
               //     padding: const EdgeInsets.only(top: 10, bottom: 12, left: 20, right: 20),
               //     child: Row(
               //       children: [
               //         SvgPicture.asset(kCirclesIconSvg,
               //           colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
               //           height: 25,
               //         ),
               //         const SizedBox(width: 12,),
               //         Text(
               //           'Logout',
               //           style: TextStyle(
               //               color: color, fontSize: defaultFontSize + 6,fontWeight: FontWeight.normal),
               //         )
               //       ],
               //     ),
               //   ),
               // ),
               const CustomBorderWidget(left: 20, right: 20, top: 20, bottom: 0,),
              //  GestureDetector(
              //    onTap: (){
              //      context.push(context.generateRoutePath(subLocation: discoverCommunitiesPage));
              //      pop(context);
              //    },
              //    behavior: HitTestBehavior.opaque,
              //    child: Padding(
              //     padding: const EdgeInsets.only(left: 24, right: 15),
              //     child: Row(
              //        children: [
              //          Text(
              //            "MY COMMUNITIES",
              //            style: TextStyle(
              //                fontSize: 12,
              //                fontWeight: FontWeight.w700,
              //                color: theme.colorScheme.onPrimary),
              //          ),
              //          const Spacer(),
              //          Icon(Icons.keyboard_arrow_right_rounded, color: theme.colorScheme.onBackground,)
              //        ],
              //     ),
              // ),
              //  ),
             //  const SizedBox(height: 15,)
             ],
          ),
        )
      ];
    }, body: const DrawerCommunitiesListWidget());

    //   ListView(
    //   shrinkWrap: true,
    //   children: [
    //
    //     // GestureDetector(
    //     //   onTap: () {
    //     //     final currentUser = AppStorage.currentUserSession!;
    //     //     context.push(context.generateRoutePath(subLocation: circlesPage), extra: currentUser);
    //     //     pop(context);
    //     //   },
    //     //   child: Container(
    //     //     width: double.infinity,
    //     //     color: Colors.transparent,
    //     //     padding: const EdgeInsets.only(top: 10, bottom: 12, left: 20, right: 20),
    //     //     child: Row(
    //     //       children: [
    //     //         SvgPicture.asset(kCirclesIconSvg,
    //     //           colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    //     //           height: 25,
    //     //         ),
    //     //         const SizedBox(width: 13,),
    //     //         Text(
    //     //           'My Circle',
    //     //           style: TextStyle(
    //     //               color: color, fontSize: defaultFontSize + 6,fontWeight: FontWeight.normal),
    //     //         )
    //     //       ],
    //     //     ),
    //     //   ),
    //     // ),
    //
    //     // todo invite feature NOT TESTED YET
    //     // GestureDetector(
    //     //   onTap: state._onInviteTapped,
    //     //   child: Container(
    //     //     width: double.infinity,
    //     //     color: Colors.transparent,
    //     //     padding: const EdgeInsets.only(top: 10, bottom: 12, left: 20, right: 20),
    //     //     child: Row(
    //     //       children:  [
    //     //         SvgPicture.asset('assets/svg/user-add.svg', color: color,height: 20,),
    //     //         const SizedBox(width: 10,),
    //     //          Text(
    //     //           'Invite',
    //     //           style: TextStyle(color: color, fontSize: defaultFontSize,fontWeight: FontWeight.normal),
    //     //         )
    //     //       ],
    //     //     ),
    //     //   ),
    //     // ),
    //
    //      // const
    //
    //   ],
    // );
  }

  void setThemeMode(BuildContext context, {required Brightness brightness}){
    // state._darkThemeTap
    if(brightness == Brightness.dark) {
      AdaptiveTheme.of(context).setDark();
    }else{
      AdaptiveTheme.of(context).setLight();
    }

    // set the theme on the server as well, and then in session
    context.read<AuthCubit>().updateAuthUserData(AppStorage.currentUserSession!.copyWith(
      theme: brightness.name
    ));

  }
}
