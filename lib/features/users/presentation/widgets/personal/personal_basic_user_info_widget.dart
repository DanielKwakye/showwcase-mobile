import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_dot_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/personal/personal_social_widget.dart';

class PersonalBasicUserInfoWidget extends StatelessWidget {
  final UserModel userModel;

  const PersonalBasicUserInfoWidget({Key? key, required this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SeparatedColumn(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 10,
        );
      },
      children: <Widget>[
        /// display name and verified badge ----
        Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 2,
              ),
              child: Text(
                userModel.displayName!,
                style: TextStyle(
                    color: userModel.role == "community_lead"
                        ? kAppGold
                        : theme.colorScheme.onBackground,
                    fontWeight: FontWeight.w800,
                    fontSize: defaultFontSize + 3),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            if (userModel.badges != null && userModel.badges!.isNotEmpty) ...{
              if (userModel.badges!.contains('founding_creator') ||
                  userModel.badges!.contains('community_lead'))
                const Icon(
                  Icons.verified,
                  color: kAppBlue,
                )
            }
          ],
        ),

        if (!userModel.headline.isNullOrEmpty()) ...{
          Text(
            userModel.headline ?? '',
            style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontSize: defaultFontSize,
                height: defaultLineHeight),
          ),
        },

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            //!username
            Text(
              "@${userModel.username!}",
              style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w500),
            ),

            //!location
            if (!userModel.location.isNullOrEmpty()) ...{
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    kLocationIconSvg,
                    colorFilter: ColorFilter.mode(
                        theme.colorScheme.onPrimary, BlendMode.srcIn),
                    width: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    userModel.location!,
                    style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            },
            //! date joined
            if (userModel.createdAt != null) ...{
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    kCalendarIconSvg,
                    colorFilter: ColorFilter.mode(
                        theme.colorScheme.onPrimary, BlendMode.srcIn),
                    width: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Joined ${getFormattedDateWithIntl(userModel.createdAt!)}",
                    style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            }
          ],
        ),

        GestureDetector(
          onTap: () {
            context.push(context.generateRoutePath(subLocation: userResumePreviewPage), extra: userModel);
          },
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/svg/resume.svg',
                color: theme.colorScheme.onPrimary,
                width: 14,
                height: 14,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                'View Resume',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: defaultFontSize,
                ),
              ),
            ],
          ),
        ),

        /// followers and following section -----
        Wrap(
          spacing: 15,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                context.push(context.generateRoutePath(subLocation: circlesPage), extra: {
                  "user": AppStorage.currentUserSession!,
                  "initialTabIndex": 1
                });
              },
              child: RichText(
                text: TextSpan(
                  text: '${userModel.totalFollowers ?? 0} ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onBackground,
                      fontWeight: FontWeight.w800),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' Followers',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
            ),
            const CustomDotWidget(),
            GestureDetector(
              onTap: () {
                context.push(context.generateRoutePath(subLocation: circlesPage), extra: {
                  "user": AppStorage.currentUserSession!,
                  "initialTabIndex": 2
                });
              },
              child: RichText(
                text: TextSpan(
                  text: '${userModel.totalFollowing ?? 0} ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onBackground,
                      fontWeight: FontWeight.w800),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' Following',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
            ),
          ],
        ),

        ///social section ----
        const PersonalSocialWidget(),

      if(userModel.domain  != null)  GestureDetector(
        onTap: () {
          context.push(browserPage, extra: "https://${userModel.domain!}");
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
            decoration: BoxDecoration(
                color: theme.colorScheme.onSurface,
                borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/frontpage.svg',
                  height: 32,
                ),
                const SizedBox(width: 10,),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'My Front Page:',
                      style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      userModel.domain!,
                      style: TextStyle(
                          color: theme.colorScheme.onBackground,
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),),
                // const Spacer(),
                const SizedBox(width: 10,),
                CustomButtonWidget(
                  text: 'Visit',
                  onPressed: () {
                    context.push(browserPage, extra: "https://${userModel.domain!}");
                  },
                )
              ],
            ),
          ),
      ),

        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: theme.colorScheme.onSurface,
              borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Community Karma',
                style: TextStyle(
                    color: theme.colorScheme.onBackground,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          '${userModel.totalThreads ?? 0}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: kTagBlue,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Threads",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onPrimary),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          '${userModel.engagement?.totalThreadReplies ?? 0}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: kTagPurple,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Threads Replied",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          "${userModel.engagement?.totalPublishedShows ?? 0}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: kTagGreen,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Shows Created",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onPrimary),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          "${userModel.totalInvited ?? 0}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: kTagLilac,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "People Invited",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        )

        // /// Resume section ---
        // Row(
        //   children: [
        //     // FittedBox(
        //     //   child: GestureDetector(
        //     //     onTap: () async {
        //     //
        //     //       await changeScreenWithConstructor(context, NetWorkPage(
        //     //           userId:  userModel.id!,
        //     //           userName:  userModel.username!,
        //     //           networkCount: [
        //     //             userModel.totalWorkedWiths ?? 0,
        //     //             userModel.totalFollowers ?? 0,
        //     //             userModel.totalFollowing ?? 0
        //     //           ],
        //     //           tabIndex: 0
        //     //       ));
        //     //
        //     //       if(!state.mounted) return;
        //     //
        //     //       // this refreshes the profile shows
        //     //       context.read<ProfileShowsCubit>().fetchProfileShows(userName: userModel.username!, replaceFirstPage: true);
        //     //
        //     //       // this refreshes the profile threads
        //     //       context.read<ProfileThreadsCubit>().fetchProfileThreads(userName:  userModel.username!, replaceFirstPage: true,);
        //     //
        //     //       // fetch modules again
        //     //       context.read<ProfileCubit>().fetchModules(userName: userModel.username!);
        //     //
        //     //       context.read<ProfilePollsCubit>().fetchPollsThreads(userName:   userModel.username!, replaceFirstPage: true);
        //     //
        //     //       context.read<ProfileMediaCubit>().fetchMediaThreads(userName:   userModel.username!, replaceFirstPage: true);
        //     //
        //     //     },
        //     //     // child: Row(
        //     //     //   children: [
        //     //     //     ShaderMask(
        //     //     //       shaderCallback: (bounds) {
        //     //     //         return RadialGradient(
        //     //     //           center: Alignment.topLeft,
        //     //     //           radius: 1,
        //     //     //           colors: kAppLinearGradient.colors,
        //     //     //           tileMode: TileMode.mirror,
        //     //     //         ).createShader(bounds);
        //     //     //       },
        //     //     //       child: SvgPicture.asset(
        //     //     //         kCirclesIconSvg,
        //     //     //         color: Colors.white,
        //     //     //       ),
        //     //     //     ),
        //     //     //     const SizedBox(
        //     //     //       width: 10,
        //     //     //     ),
        //     //     //     CustomGradientTextWidget(
        //     //     //         "${ userModel.totalWorkedWiths ?? 0} Circle Members",
        //     //     //         style: const TextStyle(
        //     //     //             fontWeight: FontWeight.w600,
        //     //     //             fontSize: defaultFontSize,
        //     //     //             color: Colors.white),
        //     //     //         gradient: kAppLinearGradient),
        //     //     //
        //     //     //   ],
        //     //     // ),
        //     //   ),
        //     // ),
        //     // const SizedBox(
        //     //   width: 20,
        //     // ),
        //     if( userModel.resumeUrl != null)  ... {
        //
        //       GestureDetector(
        //         onTap: () {},
        //         child: Row(
        //           children: [
        //             SvgPicture.asset('assets/svg/resume.svg',
        //                 colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn), width: 12),
        //             const SizedBox(
        //               width: 5,
        //             ),
        //             GestureDetector(
        //               onTap: () {
        //                 // AnalyticsManager.trackResumeView(pageTitle: userModel.displayName!, resumeID: userModel.id);
        //                 // Navigator.push(context, MaterialPageRoute(builder: (context) =>  ResumePage(user:  widget.user,),settings: RouteSettings(arguments: {'page_title':'resume_page','page_id':  userModel.id}),));
        //               },
        //               child: Text(
        //                 'View Resume',
        //                 style: TextStyle(
        //                   color: theme.colorScheme.onPrimary,
        //                   fontSize: defaultFontSize,
        //                 ),
        //               ),
        //             ),
        //             IconButton(
        //                 visualDensity: const VisualDensity(horizontal: -4),
        //                 padding: EdgeInsets.zero,
        //                 onPressed: () {
        //                   // AnalyticsManager.resumeGenerate(pageTitle: userModel.displayName!,pageId: userModel.id!);
        //                   // state._profileCubit.updateResume();
        //                 },
        //                 icon: SvgPicture.asset('assets/svg/refresh.svg',
        //                     colorFilter: ColorFilter.mode(theme.colorScheme.onPrimary, BlendMode.srcIn), width: 12))
        //           ],
        //         ),
        //       )
        //     }
        //     //   ValueListenableBuilder(
        //     //   valueListenable: state._isUpdatingResume,
        //     //   builder: (BuildContext context,bool value, Widget? child) {
        //     //     return value ? const SizedBox(
        //     //         height: 20,
        //     //         width: 20,
        //     //         child: CircularProgressIndicator.adaptive(
        //     //           valueColor: AlwaysStoppedAnimation<Color>(kAppBlue),
        //     //           strokeWidth: 1,
        //     //         )) :
        //     //
        //     //   },
        //     // ),
        //   ],
        // ),

        // if ( userModel.tags != null &&  userModel.tags!.isNotEmpty) ...[
        //   ProfileUserTags(tags: userModel.tags),
        //   const SizedBox(
        //     height: 10,
        //   ),
        // ],
        // ProfileUserSocialsWidget(userName:  userModel.username!, badges: userModel.badges ?? []),
      ],
    );
  }
}
