import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:like_button/like_button.dart';
import 'package:separated_column/separated_column.dart';
import 'package:separated_row/separated_row.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/analytics/data/service/analytics_service.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_dot_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_cubit.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/shows_user_meta_data_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_profile_icon_widget.dart';

class ShowItemWidget extends StatefulWidget {

  final ShowModel showModel;
  final bool showPublishedDate;
  final bool showReadStats;
  final bool showActionBar;
  final Function()? onTap;
  final String pageName;
  ShowItemWidget({Key? key, required this.showModel, this.showPublishedDate = true,
    this.showReadStats = true,
    this.showActionBar = true,
    this.onTap,
    required this.pageName,
  }) : super(key: key ?? ValueKey(showModel.id));

  @override
  State<ShowItemWidget> createState() => _ShowItemWidgetState();
}

class _ShowItemWidgetState extends State<ShowItemWidget> {

  @override
  void initState() {
    AnalyticsService.instance.sendEventShowsImpression(showModel: widget.showModel,pageName: widget.pageName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final networkImage = getProfileImage(widget.showModel.coverImage);
    // AnalyticsService.instance.sendEventShowsImpression(showModel: showModel,pageName: pageName);
    // AnalyticsService.instance.sendEventShowCopyLink(showModel: showModel,pageName: pageName);


    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap != null ? widget.onTap?.call() : () {
        context.push(context.generateRoutePath(subLocation: showPreviewPage), extra: widget.showModel);
        AnalyticsService.instance.sendEventShowTap(showModel: widget.showModel,  pageName: widget.pageName);
        // AnalyticsService.instance.sendEventShowCopyLink(showModel: showModel,pageName: pageName);
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
              UserProfileIconWidget(user: widget.showModel.user!, size: 22, dimension: '100x',),
              const SizedBox(width: 10,),
              Expanded(
                  child: ShowsUserMetaDataWidget(user: widget.showModel.user!, show: widget.showModel,)
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
                  if(widget.showModel.title != null) ... {
                    Text(widget.showModel.title!, style: theme.textTheme.titleMedium?.copyWith(fontSize: defaultFontSize + 2, fontWeight: FontWeight.w700),),
                    const SizedBox(height: 10,),
                  },
                  if(widget.showModel.projectSummary != null) ... {
                    Text(widget.showModel.projectSummary!,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal, color: theme.colorScheme.onPrimary,height: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5,),
                  },
                ],
              )),
              if(widget.showModel.coverImage != null) ...{
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
                      maxWidthDiskCache: size.width.round(),
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
          if(widget.showModel.workedwiths  != null) ...[

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.showModel.workedwiths!.map((workedwith) {
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
          if(widget.showActionBar) ...{
            Row(
              //mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: SeparatedRow(
                  mainAxisSize: MainAxisSize.min,
                  separatorBuilder: (BuildContext ctx, int index) {
                    return const SizedBox(width: 5,);
                  },
                  children: [
                    // if (!categoryName.isNullOrEmpty()) ...{
                    //   Container(
                    //     // margin: const EdgeInsets.only(right: 10),
                    //     padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                    //     decoration: BoxDecoration(
                    //       color: backgroundColor,
                    //       borderRadius: BorderRadius.circular(16),
                    //       border: Border.all(
                    //           color: foregroundColor.withOpacity(0.3), width: 0.5),
                    //     ),
                    //     child: SeparatedRow(
                    //       separatorBuilder: (BuildContext context, int index) {
                    //         return const SizedBox(
                    //           width: 5,
                    //         );
                    //       },
                    //       children: [
                    //         if(!icon.isNullOrEmpty()) ... {
                    //           SvgPicture.asset(
                    //             icon!,
                    //             colorFilter: ColorFilter.mode(foregroundColor, BlendMode.srcIn),
                    //             width: 18,
                    //           ),
                    //         },
                    //         if(!categoryName.isNullOrEmpty()) ... {
                    //           Padding(
                    //             padding: const EdgeInsets.only(right: 5),
                    //             child: Text(categoryName!, style: TextStyle(color: foregroundColor,fontWeight: FontWeight.w600,fontSize: 12)),
                    //           ),
                    //         }
                    //       ],
                    //     ),
                    //   ),
                    // },
                    SeparatedRow(separatorBuilder: (_, __) {
                      return const Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: CustomDotWidget(),);
                    }, children: [
                      if( widget.showPublishedDate && widget.showModel.publishedDate != null) ... {
                        Text(
                          widget.showModel.publishedDate != null
                              ? getFormattedDateWithIntl(widget.showModel.publishedDate!,
                              format: 'd MMMM y')
                              : '', style: TextStyle(color: theme.colorScheme
                            .onPrimary, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,),
                      },
                      if(widget.showReadStats && widget.showModel.readingStats != null && widget.showModel.readingStats!.time != 0) ... {
                        Text(
                          widget.showModel.readingStats!.text ?? '',
                          style: TextStyle(
                              color: theme.colorScheme.onPrimary, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,),

                      },
                    ],)
                  ],
                )),

                /// share
                LikeButton(
                  mainAxisAlignment: MainAxisAlignment.end,
                  padding: EdgeInsets.zero,
                  isLiked: false,
                  onTap: (value) {
                    // context.read<ShowsCubit>().bookmarkShow(show: showModel, isBookmark: !value);
                    final FlutterShareMe flutterShareMe = FlutterShareMe();
                    flutterShareMe.shareToSystem(msg: 'Read my Show on Showwcase \n https://showwcase.com/show/${widget.showModel.id}/${widget.showModel.slug!}');
                    return Future.value(value);
                  },

                  likeBuilder: (_) {
                    /// We use align so we can manage the icon size in here
                    return Align(
                        alignment: Alignment.centerRight,
                        child: SvgPicture.asset(kShareIconSvg, colorFilter: ColorFilter.mode(theme.colorScheme.onPrimary, BlendMode.srcIn,), width: 15,)
                    );
                  },
                  // bubblesColor: const BubblesColor(
                  //   dotSecondaryColor: kAppBlue,
                  //   dotPrimaryColor: kAppBlue,
                  // ),
                  // countBuilder: (int? count, bool isLiked, String text){
                  //   return Text(text, style: TextStyle(color: widget.iconColor ?? theme.colorScheme.onPrimary),);
                  // },
                  // countDecoration: (widget, likCount) {
                  //   return Padding(padding: EdgeInsets.zero, child: widget,);
                  // },
                ),
                LikeButton(
                  mainAxisAlignment: MainAxisAlignment.end,
                  padding: EdgeInsets.zero,
                  isLiked: widget.showModel.hasBookmarked ?? false,
                  onTap: (value) {
                    context.read<ShowsCubit>().bookmarkShow(show: widget.showModel, isBookmark: !value);
                    AnalyticsService.instance.sendEventShowBookmarks(showModel: widget.showModel,pageName: widget.pageName);
                    return Future.value(!value);
                  },

                  likeBuilder: (bool isBookmarked) {
                    /// We use align so we can manage the icon size in here
                    return Align(
                        alignment: Alignment.centerRight,
                        child: isBookmarked ?
                        SvgPicture.asset(kBookmarkFilledIconSvg, colorFilter: const ColorFilter.mode(kAppBlue, BlendMode.srcIn),  width: 13) :
                        SvgPicture.asset(kBookmarkOutlinedIconSvg, colorFilter: ColorFilter.mode(theme.colorScheme.onPrimary, BlendMode.srcIn,),)
                    );
                  },
                  bubblesColor: const BubblesColor(
                    dotSecondaryColor: kAppBlue,
                    dotPrimaryColor: kAppBlue,
                  ),
                  // countBuilder: (int? count, bool isLiked, String text){
                  //   return Text(text, style: TextStyle(color: widget.iconColor ?? theme.colorScheme.onPrimary),);
                  // },
                  // countDecoration: (widget, likCount) {
                  //   return Padding(padding: EdgeInsets.zero, child: widget,);
                  // },
                ),
              ],
            )
          },

        ],
      ),
    );

  }
}
