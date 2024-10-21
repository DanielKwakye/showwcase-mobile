import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/shows_user_meta_data_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_profile_icon_widget.dart';

class DashboardItemWidget extends StatelessWidget {

  final ShowModel showModel;
  final bool showPublishedDate;
  final bool showReadStats;
  const DashboardItemWidget({Key? key, required this.showModel, this.showPublishedDate = true, this.showReadStats = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final networkImage = getProfileImage(showModel.coverImage);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.push(context.generateRoutePath(subLocation: showPreviewPage), extra: showModel);
      },
      child: SeparatedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 10,);
        },
        children: <Widget>[

          /// header meta data
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserProfileIconWidget(user: showModel.user!, size: 22,),
              const SizedBox(width: 10,),
              Expanded(
                  child: ShowsUserMetaDataWidget(user: showModel.user!, show: showModel,)
              )
            ],
          ),


          /// body
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if(showModel.title != null) ... {
                    Text(showModel.title!, style: theme.textTheme.titleMedium?.copyWith(fontSize: defaultFontSize + 2, fontWeight: FontWeight.w700),),
                    const SizedBox(height: 10,),
                  },
                  if(showModel.projectSummary != null) ... {
                    Text(showModel.projectSummary!,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal, color: theme.colorScheme.onPrimary,height: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5,),
                  },
                ],
              )),
              if(showModel.coverImage != null) ...{
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  width: 120,
                  height: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: networkImage,
                      errorWidget: (context, url, error) =>
                          Container(
                            color: kAppBlue,
                          ),
                      placeholder: (ctx, url) => Container(
                        color: kAppBlue,
                      ),
                      cacheKey: networkImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              }else ... {
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: 120,
                    height: 70,
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10)
                    // ),
                    child: Image.asset(kShowsThumbnailPlaceHolder),
                  ),
                ),

              }
            ],
          ),

          /// collaborators if available
          if(showModel.workedwiths  != null) ...[

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: showModel.workedwiths!.map((workedwith) {
                  final user = UserModel.fromJson(workedwith.colleague!.toJson());
                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: CustomUserAvatarWidget(username: user.username ?? "Showwcase", size: 30, borderSize: 2, networkImage: user.profilePictureKey != null ? getProfileImage(user.profilePictureKey!) : null,),
                  );
                }
                ).toList(),
              ),
            ),
            // UsersHorizontalStackWidget(users: List<User>.from(show.workedwiths!.map((x) => User.fromJson(x.colleague!.toJson()))),),

          ],


          ///  action bar --------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 5,),
              Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  [
                      const Text('Impressions',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),),
                      const SizedBox(height: 5,),
                      Text('${(showModel.views ?? 0 ) + (showModel.visits ?? 0)}',style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
                    ],
                  )),
              const SizedBox(width: 20,),
              Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  [
                      const Text('Views',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),),
                      const SizedBox(height: 5,),
                      Text('${showModel.views}',style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
                    ],
                  )),
              const SizedBox(width: 20,),
              const Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Interactions',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),),
                      SizedBox(height: 5,),
                      Text('0',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
                    ],
                  )),
              const SizedBox(width: 20,),
              const Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Engagement',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),),
                      SizedBox(height: 5,),
                      Text('0',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
                    ],
                  )),
            ],
          ),

        ],
      ),
    );

  }
}
