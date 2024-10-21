import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_dot_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/public/public_social_widget.dart';

class PublicBasicUserInfoWidget extends StatelessWidget {

  final UserModel userModel;
  const PublicBasicUserInfoWidget({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return SeparatedColumn(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10,);
      },
      children: <Widget>[

        /// display name and verified badge ----
        Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2,),
              child: Text(
                userModel.displayName!,
                style: TextStyle(
                    color: userModel.role == "community_lead"
                        ? kAppGold : theme.colorScheme.onBackground,
                    fontWeight: FontWeight.w800,
                    fontSize: defaultFontSize + 3),overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(width: 10,),
            if( userModel.badges != null
                &&  userModel.badges!.isNotEmpty
            ) ... {
              if( userModel.badges!.contains('founding_creator')
                  ||  userModel.badges!.contains('community_lead')
              )
                const Icon(Icons.verified, color: kAppBlue,)
            }

          ],
        ),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [

            //!username
            Text(
              "@${ userModel.username!}",
              style: TextStyle(color: theme.colorScheme.onPrimary),
            ),

            //!location
            if (! userModel.location.isNullOrEmpty()) ...{
              Row(
                mainAxisSize: MainAxisSize.min,
                 children: [
                   SvgPicture.asset(
                     kLocationIconSvg,
                     colorFilter: ColorFilter.mode(theme.colorScheme.onPrimary, BlendMode.srcIn),
                     width: 15,
                   ),
                   const SizedBox(
                     width: 5,
                   ),
                   Text(
                     userModel.location!,
                     style: TextStyle(color: theme.colorScheme.onPrimary),
                   ),
                 ],
              ),
            },
            //! date joined
            if ( userModel.createdAt != null) ...{
              Row(
                mainAxisSize: MainAxisSize.min,
                 children: [
                   SvgPicture.asset(
                     kCalendarIconSvg, colorFilter: ColorFilter.mode(theme.colorScheme.onPrimary, BlendMode.srcIn),
                     width: 15,
                   ),
                   const SizedBox(
                     width: 5,
                   ),
                   Text(
                     "Joined ${getFormattedDateWithIntl( userModel.createdAt!)}",
                     style: TextStyle(color: theme.colorScheme.onPrimary),
                   )
                 ],
              ),
            }
          ],
        ),

        if (! userModel.headline.isNullOrEmpty()) ...{
          Text(
            userModel.headline ?? '',
            style: TextStyle(color: theme.colorScheme.onBackground, fontSize: defaultFontSize, height: defaultLineHeight),
          ),
        },
      if(userModel.resumeUrl != null)  GestureDetector(
          onTap: (){
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
                  "user": userModel,
                  "initialTabIndex": 1
                });
              },
              child: RichText(
                text: TextSpan(
                  text: '${ userModel.totalFollowers ?? 0} ',
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
                  "user": userModel,
                  "initialTabIndex": 2
                });
              },
              child: RichText(
                text: TextSpan(
                  text: '${ userModel.totalFollowing ?? 0} ',
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

        /// socials section ----
        PublicSocialWidget(username:  userModel.username!),

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
                Expanded(
                child: Column(
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
                  ),
                ),
                const Spacer(),
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
        ),
      ],
    );
  }
}
