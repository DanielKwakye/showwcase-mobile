import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/series/presentation/widgets/series_item_projects_widget.dart';
import 'package:showwcase_v3/features/series/presentation/widgets/series_user_meta_data_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_dot_widget.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_profile_icon_widget.dart';


class SeriesItemWidget extends StatefulWidget {

  final SeriesModel seriesItem;
  final int itemIndex;
  final String pageName;
  const SeriesItemWidget({
    required this.seriesItem,
    required this.itemIndex,
    required this.pageName ,
    Key? key
  }) : super(key: key);

  @override
  State<SeriesItemWidget> createState() => _SeriesItemWidgetState();
}

class _SeriesItemWidgetState extends State<SeriesItemWidget> {

  @override
  void initState() {
    AnalyticsService.instance.sendEventSeriesImpression(seriesModel: widget.seriesItem, pageName: widget.pageName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final networkImage = getProjectImage(widget.seriesItem.coverImageKey);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        context.push(context.generateRoutePath(subLocation: seriesPreviewPage), extra:  {
          "series": widget.seriesItem
        });
        AnalyticsService.instance.sendEventSeriesTap(seriesModel: widget.seriesItem, pageName: widget.pageName);
      },
      child: SeparatedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 10,);
          },
        children: [
          /// header meta data
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserProfileIconWidget(user: widget.seriesItem.user!, size: 22,),
              const SizedBox(width: 10,),
              Expanded(
                  child: SeriesUserMetaDataWidget(user: widget.seriesItem.user!, series: widget.seriesItem,)
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
                  if(widget.seriesItem.title != null) ... {
                    Text(widget.seriesItem.title!, style: theme.textTheme.titleMedium?.copyWith(fontSize: defaultFontSize + 2, fontWeight: FontWeight.w700),),
                    const SizedBox(height: 10,),
                  },
                  if(widget.seriesItem.description != null) ... {
                    Text(widget.seriesItem.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal, color: theme.colorScheme.onPrimary,height: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5,),
                  },
                ],
              )),
              if(widget.seriesItem.coverImageKey != null) ...{
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

          /// Projects
          SeriesItemProjectsWidget(projects: widget.seriesItem.projects?.take(3).toList() ?? <ShowModel>[], seriesItem: widget.seriesItem, ),

          ///  action bar --------------------
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
                  SeparatedRow(separatorBuilder: (_, __) {
                    return const Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: CustomDotWidget(),);
                  }, children: [
                    if(widget.seriesItem.publishedDate != null) ... {
                      Text(
                        widget.seriesItem.publishedDate != null
                            ? getFormattedDateWithIntl(widget.seriesItem.publishedDate!,
                            format: 'd MMMM y')
                            : '', style: TextStyle(color: theme.colorScheme
                          .onPrimary, fontSize: 13),
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
                  final FlutterShareMe flutterShareMe = FlutterShareMe();
                  flutterShareMe.shareToSystem(msg: 'Read my Series on Showwcase \n https://showwcase.com/series/${widget.seriesItem.id}/${widget.seriesItem.slug!}');
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

              /// Bookmark .. no functionality to bookmark a series yet
              // LikeButton(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   padding: EdgeInsets.zero,
              //   isLiked: showModel.hasBookmarked ?? false,
              //   onTap: (value) {
              //     context.read<ShowsCubit>().bookmarkShow(show: showModel, isBookmark: !value);
              //     return Future.value(!value);
              //   },
              //
              //   likeBuilder: (bool isBookmarked) {
              //     /// We use align so we can manage the icon size in here
              //     return Align(
              //         alignment: Alignment.centerRight,
              //         child: isBookmarked ?
              //         SvgPicture.asset(kBookmarkFilledIconSvg, colorFilter: const ColorFilter.mode(kAppBlue, BlendMode.srcIn),  width: 13) :
              //         SvgPicture.asset(kBookmarkOutlinedIconSvg, colorFilter: ColorFilter.mode(theme.colorScheme.onPrimary, BlendMode.srcIn,),)
              //     );
              //   },
              //   bubblesColor: const BubblesColor(
              //     dotSecondaryColor: kAppBlue,
              //     dotPrimaryColor: kAppBlue,
              //   ),
              //   // countBuilder: (int? count, bool isLiked, String text){
              //   //   return Text(text, style: TextStyle(color: widget.iconColor ?? theme.colorScheme.onPrimary),);
              //   // },
              //   // countDecoration: (widget, likCount) {
              //   //   return Padding(padding: EdgeInsets.zero, child: widget,);
              //   // },
              // ),
            ],
          ),


          const Padding(
            padding: EdgeInsets.only(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                  Padding(
                    padding: EdgeInsets.only(),
                    child: Text("View Series", style: TextStyle(color: kAppBlue, fontWeight: FontWeight.w700),),
                  ),
                 Icon(Icons.keyboard_arrow_right_outlined, color: kAppBlue,)
               ],
            ),
          )


        ],
       ),
    );




    // return Column(
    //   mainAxisSize: MainAxisSize.min,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: <Widget>[
    //     Stack(
    //       clipBehavior: Clip.none,
    //       children: [
    //
    //         ClipRRect(
    //           borderRadius: BorderRadius.circular(4), // just in case an image is not found
    //           child: networkImage != '' ?
    //           GestureDetector(
    //             behavior: HitTestBehavior.translucent,
    //             onTap: () {
    //               // changeScreenWithConstructor(context, SeriesPreviewPage(seriesItem: seriesItem, itemIndex: itemIndex)).then((value) {
    //               //   onFollow(value as SeriesResponse);
    //               // });
    //             },
    //             child: ClipRRect(
    //                 borderRadius: BorderRadius.circular(4),
    //                 child: Hero(
    //                     tag: "$networkImage-$itemIndex",
    //                     child: CustomNetworkImageWidget(imageUrl: networkImage, onError: () {
    //                       Image.asset(kShowsThumbnailPlaceHolder, fit: BoxFit.fill,);
    //                     },))),
    //           )
    //               : GestureDetector(
    //               behavior: HitTestBehavior.translucent,
    //               onTap: () {
    //                 // changeScreenWithConstructor(context, SeriesPreviewPage(seriesItem: seriesItem, itemIndex: itemIndex)).then((value) {
    //                 //   onFollow(value as SeriesResponse);
    //                 // });
    //               },
    //               child: SizedBox(
    //                   width: double.infinity,
    //                   child: Image.asset(kShowsThumbnailPlaceHolder, fit: BoxFit.fill,))),
    //         ),
    //         if(seriesItem.user != null) ... {
    //           Positioned(left: 20,
    //             bottom: -40,child: GestureDetector(
    //               behavior: HitTestBehavior.opaque,
    //               onTap: () {
    //                 // changeScreenWithConstructor(context, ProfilePage(user: seriesItem.user!));
    //               },
    //               child: CustomUserAvatarWidget(
    //                 username: seriesItem.user?.username ?? '',
    //                 borderSize: 2,
    //                 networkImage: seriesItem.user!.profilePictureKey != null
    //                     ? getProfileImage(seriesItem.user!.profilePictureKey!)
    //                     : null,
    //                 borderColor: seriesItem.user!.role == "community_lead"
    //                     ? kAppGold
    //                     : theme.colorScheme.primary,
    //                 size: 80,
    //               ),
    //             ),
    //           )
    //           ,
    //         }
    //       ],
    //     ),
    //
    //     Align(
    //       alignment: Alignment.topRight,
    //       child: CustomButtonWidget(
    //         text: 'View Series', onPressed: () {
    //         // changeScreenWithConstructor(context, SeriesPreviewPage(seriesItem: seriesItem, itemIndex: itemIndex)).then((value) {
    //         //   // onFollow(value as SeriesResponse);
    //         // });
    //       }, borderRadius: 4,
    //       ),
    //     ),
    //
    //     const SizedBox(height: 10,),
    //
    //     if(seriesItem.user != null) ... [
    //
    //       GestureDetector(
    //         behavior: HitTestBehavior.translucent,
    //         onTap: () {
    //           // changeScreenWithConstructor(context, ProfilePage(user: seriesItem.user!));
    //         },
    //         child: Wrap(
    //           crossAxisAlignment: WrapCrossAlignment.center,
    //           direction: Axis.horizontal,
    //           children: [
    //             Text("${seriesItem.user!.displayName ?? ''} ",
    //                 style: TextStyle(
    //                     color:  theme.colorScheme.onBackground,
    //                     fontWeight: FontWeight.normal
    //                 )
    //             ),
    //             Text(seriesItem.user!.activity?.emoji != null && seriesItem.user!.activity!.emoji!.contains('?') ? seriesItem.user!.activity!.emoji! : '🔎', style: TextStyle(color: theme.colorScheme.onBackground),),// emoji
    //           ],
    //         ),
    //       ),
    //       const SizedBox(height: 2,),
    //       GestureDetector(
    //         behavior: HitTestBehavior.translucent,
    //         onTap: () {
    //           // changeScreenWithConstructor(context, ProfilePage(user: seriesItem.user!));
    //         },
    //         child: Wrap(
    //           crossAxisAlignment: WrapCrossAlignment.center,
    //           direction: Axis.horizontal,
    //           children: [
    //             if(seriesItem.user!.username != null) ... {
    //               Text('@${seriesItem.user!.username!}', style: TextStyle(
    //                   color: theme.colorScheme.onPrimary,
    //                   fontSize: defaultFontSize - 2,
    //                   fontWeight: FontWeight.normal)),
    //             },
    //             if(!seriesItem.user!.location.isNullOrEmpty()) ...[
    //               const SizedBox(width: 10,),
    //               const CustomDotWidget(),
    //               const SizedBox(width: 10,),
    //               SvgPicture.asset(
    //                 kLocationIconSvg,
    //                 color: theme.colorScheme.onPrimary,
    //                 width: 15,
    //               ),
    //               const SizedBox(width: 5,),
    //               Text(seriesItem.user!.location!, style: TextStyle(
    //                   color: theme.colorScheme.onPrimary,
    //                   fontSize: defaultFontSize - 2,
    //                   fontWeight: FontWeight.normal)),
    //             ]
    //           ],
    //         ),
    //       ),
    //
    //       const SizedBox(height: 15,),
    //
    //
    //     ],
    //
    //     if(seriesItem.title != null) ... {
    //       GestureDetector(
    //         behavior: HitTestBehavior.translucent,
    //         onTap: () {
    //           // changeScreenWithConstructor(context, SeriesPreviewPage(seriesItem: seriesItem, itemIndex: itemIndex)).then((value) {
    //           //   onFollow(value as SeriesResponse);
    //           // });
    //         },
    //         child: Text(seriesItem.title!, style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.bold, fontSize: defaultFontSize + 2)),
    //       ),
    //       const SizedBox(height: 5,),
    //       RichText(
    //         text:  TextSpan(
    //             text: '${seriesItem.projects?.length ?? 0} shows',
    //             style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: defaultFontSize - 2,),
    //             children: [
    //               const TextSpan(text:  ' / '),
    //               TextSpan(text:  ' ${(seriesItem.difficulty ?? '').capitalize()} '),
    //             ]
    //         ),
    //
    //       )
    //     },
    //
    //     const SizedBox(height: 10,),
    //
    //     if(seriesItem.projects != null) ... [
    //
    //       ...seriesItem.projects!.take(3).map((project) {
    //         return GestureDetector(
    //           behavior: HitTestBehavior.translucent,
    //           onTap: () {
    //             // this leads directly to the series main page
    //             // AnalyticsManager.seriesStart(pageName: 'series_preview_page', pageTitle: project.title!, seriesId: project.id!, index: seriesItem.projects!.indexOf(project), containerName: 'toc');
    //             // changeScreenWithConstructor(context, MainSeriesPage(seriesId: seriesItem.id!, initialProjectId: project.id));
    //           },
    //           child: Container(
    //             width: double.infinity,
    //             padding: const EdgeInsets.symmetric(vertical: 8),
    //             decoration: BoxDecoration(
    //                 border: Border(bottom: BorderSide(color: theme.colorScheme.outline))
    //             ),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children:  <Widget>[
    //                 Text( project.title ?? '', style: TextStyle(color: theme.colorScheme.onBackground, fontSize: defaultFontSize) ),
    //                 const SizedBox(height: 5,),
    //                 Row(
    //                   mainAxisSize: MainAxisSize.min,
    //                   children: [
    //                     if(project.category != null) ... {
    //                       Text( project.category != null ? project.category.capitalize() : '', style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: defaultFontSize - 2) ),
    //                       const SizedBox(width: 5,),
    //                     },
    //                     if(project.category != null && project.readingStats?.text != null ) ...{
    //                       const CustomDotWidget(),
    //                       const SizedBox(width: 5,),
    //                     },
    //                     if(project.readingStats?.text != null ) ... [
    //                       Text( project.readingStats?.text ?? '', style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: defaultFontSize - 3) ),
    //                       const SizedBox(width: 5,),
    //                     ]
    //                   ],
    //                 )
    //               ],
    //             ),
    //           ),
    //         );
    //       })
    //
    //     ],
    //
    //     const SizedBox(height: 10,),
    //
    //     GestureDetector(
    //       behavior: HitTestBehavior.translucent,
    //       onTap: () {
    //         // changeScreenWithConstructor(context, SeriesPreviewPage(seriesItem: seriesItem, itemIndex: itemIndex)).then((value) {
    //         //   onFollow(value as SeriesResponse);
    //         // });
    //       },
    //       child: Row(
    //         children: [
    //           Container(
    //               decoration: BoxDecoration(
    //                 color: kAppBlue.withOpacity(0.2),
    //                 borderRadius: BorderRadius.circular(4),
    //               ),
    //               padding: const EdgeInsets.all(5),
    //               child: Row(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //
    //                   SvgPicture.asset(kSeriesIconSvg, color: kAppBlue,),
    //                   const SizedBox(width: 5,),
    //                   const Text('Series', style: TextStyle(color: kAppBlue, fontWeight: FontWeight.bold), ),
    //
    //                 ],
    //               )
    //             // TextButton.icon(
    //             //     onPressed: (){
    //             //
    //             // }, icon: SvgPicture.asset(kSeriesIconSvg, color: kAppBlue,), label: const Text('Series', style: TextStyle(color: kAppBlue),)
    //             // ),
    //           ),
    //           const SizedBox(width: 10,),
    //           if(seriesItem.categories != null && seriesItem.categories!.isNotEmpty) ... {
    //             Expanded(child: RichText(
    //                 text: TextSpan(
    //                     text: '',
    //                     style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: defaultFontSize - 2),
    //                     children: [
    //                       ...seriesItem.categories!.map((e) => TextSpan(text: "${e.name ?? ''} ${seriesItem.categories!.indexOf(e) == (seriesItem.categories!.length - 1) ? '' : ', '}"))
    //                     ]
    //                 )
    //             ))
    //           }
    //
    //         ],
    //       ),
    //     ),
    //     const SizedBox(height: 10),
    //     const CustomBorderWidget()
    //
    //
    //   ],
    // );
  }
}
