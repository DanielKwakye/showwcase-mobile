import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:like_button/like_button.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_cubit.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_enums.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';

class ShowsActionBarWidget extends StatefulWidget {

  final ShowModel showModel;
  final Color? iconColor;
  final Color? separatorColor;
  final bool showUpvoters;
  const ShowsActionBarWidget({Key? key,
    required this.showModel,
    this.iconColor,
    this.separatorColor,
    this.showUpvoters = true
  }) : super(key: key);

  @override
  ShowsActionBarWidgetController createState() => ShowsActionBarWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ShowsActionBarWidgetView extends WidgetView<ShowsActionBarWidget, ShowsActionBarWidgetController> {

  const _ShowsActionBarWidgetView(ShowsActionBarWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    const iconSize = 20.0;
    const spacingBetweenIconAndCount = EdgeInsets.only(left: 0);


    bool shouldJustify  = checkBooleans((widget.showModel.totalUpvotes??0) > 0 , (widget.showModel.totalComments??0) > 0 );
    bool shouldReduceHeight = checkIfThreadHasAnyMetric((widget.showModel.totalUpvotes??0) > 0  , (widget.showModel.totalComments??0) > 0);
    final iconColor = widget.iconColor ?? theme.colorScheme.onPrimary;
    return SizedBox(
      height:  45,
      width: width(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           const SizedBox(height: 10,),
          //   const CustomBorderWidget(),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 0),
          //   child: Row(
          //     mainAxisAlignment: shouldJustify ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
          //     children: [
          //       if((widget.showModel.totalUpvotes??0) > 0)  GestureDetector(
          //         onTap: (){
          //           if(widget.showUpvoters) {
          //             context.push(context.generateRoutePath(subLocation: showUpVotersPage), extra: widget.showModel);
          //           }
          //         },
          //         child: Padding(
          //           padding: const EdgeInsets.only(top: 10,bottom: 10,right: 10),
          //           child: RichText(
          //             text: TextSpan(
          //               text: (formatHumanReadable(widget.showModel.totalUpvotes ?? 0)).toString(),
          //               style: theme.textTheme.bodyMedium?.copyWith(
          //                   color: widget.iconColor ?? theme.colorScheme.onPrimary,
          //                   fontWeight: FontWeight.w600),
          //               children: <TextSpan>[
          //                 if ((widget.showModel.totalUpvotes ?? 0) > 1) ...{
          //                   TextSpan(
          //                       text: ' Likes',
          //                       style: TextStyle(
          //                           color: widget.iconColor ?? theme.colorScheme.onPrimary,fontWeight: FontWeight.w400,fontSize: defaultFontSize - 1)),
          //                 },
          //                 if ((widget.showModel.totalUpvotes ?? 0) == 1) ...{
          //                   TextSpan(
          //                       text: ' Like',
          //                       style: TextStyle(
          //                           color: widget.iconColor ?? theme.colorScheme.onPrimary,fontWeight: FontWeight.w400,fontSize: defaultFontSize - 1)),
          //                 },
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //
          //       if((widget.showModel.totalComments??0) > 0)  GestureDetector(
          //         onTap: (){
          //           if(widget.showUpvoters) {
          //             context.push(context.generateRoutePath(subLocation: showCommentsPage), extra: widget.showModel);
          //           }
          //         },
          //         child: Padding(
          //           padding: const EdgeInsets.only(top: 10,bottom: 10,right: 10),
          //           child: RichText(
          //             text: TextSpan(
          //               text: (formatHumanReadable(widget.showModel.totalComments ?? 0)),
          //               style: theme.textTheme.bodyMedium?.copyWith(
          //                   color: widget.iconColor ?? theme.colorScheme.onPrimary,
          //                   fontWeight: FontWeight.w600),
          //               children: <TextSpan>[
          //                 if ((widget.showModel.totalComments ?? 0) > 1) ...{
          //                   TextSpan(
          //                       text: ' Comments',
          //                       style: TextStyle(
          //                           color: widget.iconColor ?? theme.colorScheme.onPrimary,fontWeight: FontWeight.w400,fontSize: defaultFontSize - 1)),
          //                 },
          //                 if ((widget.showModel.totalComments ?? 0) == 1) ...{
          //                   TextSpan(
          //                       text: ' Comment',
          //                       style: TextStyle(
          //                           color: widget.iconColor ?? theme.colorScheme.onPrimary,fontWeight: FontWeight.w400,fontSize: defaultFontSize - 1)),
          //                 },
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //       // if(threadResponse.views! > 0)  Padding(
          //       //   padding: const EdgeInsets.only(top: 10,bottom: 10),
          //       //     child: RichText(
          //       //       text: TextSpan(
          //       //         text: (formatHumanReadable(threadResponse.views ?? 0)),
          //       //         style: TextStyle(
          //       //             color: theme.colorScheme.onBackground,
          //       //             fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis),
          //       //         children: <TextSpan>[
          //       //           if ((threadResponse.views ?? 0) > 1) ...{
          //       //             TextSpan(
          //       //                 text: ' Views',
          //       //                 style: TextStyle(
          //       //                     color: theme.colorScheme.onPrimary,fontWeight: FontWeight.w400)),
          //       //           },
          //       //           if ((threadResponse.views ?? 0) == 1) ...{
          //       //             TextSpan(
          //       //                 text: ' View',
          //       //                 style: TextStyle(
          //       //                     color: theme.colorScheme.onPrimary,fontWeight: FontWeight.w400)),
          //       //           },
          //       //         ],
          //       //       ),
          //       //     ),
          //       //   ),
          //     ],
          //   ),
          // ),
          // if(shouldReduceHeight)
          //   CustomBorderWidget(top: 2, bottom: 5, left: 0, right: 0, color: widget.separatorColor,),
          // const SizedBox(height: 10,),

          /// Ensure the tappable area fill the whole width of the expanded
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Like
                LikeButton(
                  // likeCountPadding: const EdgeInsets.only(right: 3, top: 8, bottom: 10),
                  padding: EdgeInsets.zero,
                  mainAxisAlignment: MainAxisAlignment.start,
                  onTap: (value)  {
                    // if(widget.onActionItemTapped != null){
                    //   widget.onActionItemTapped!(FeedActionType.upvote);
                    // }
                    return state._onFeedActionTapped( feedActionType: ShowActionType.upvote, toggle: !value);
                  },
                  // size: iconSize,
                  //likeCount: threadResponse.totalUpvotes,
                  isLiked: widget.showModel.hasVoted != null && widget.showModel.hasVoted!,
                  bubblesColor: const BubblesColor(
                    dotSecondaryColor: Color(0xff8280F7),
                    dotPrimaryColor: Color(0xffE580F4),
                  ),
                  likeBuilder: (bool isLiked) {
                    /// We use align so we can manage the icon size in here
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: !isLiked ?
                      Icon(Icons.favorite_outline_sharp, color: widget.iconColor ?? iconColor, size: iconSize,)
                          : const Icon(Icons.favorite_rounded, color: kAppRed, size: iconSize),
                    );
                  },
                  // countBuilder: (int? count, bool isLiked, String text){
                  //   return Text(text, style: TextStyle(color:
                  //   isLiked ? kAppRed :
                  //   (widget.iconColor ?? iconColor),
                  //       fontSize: defaultFontSize - 2
                  //   ),
                  //     textAlign: TextAlign.center,
                  //
                  //   );
                  // },
                  countDecoration: (widget, likCount) {
                    return Padding(padding: spacingBetweenIconAndCount, child: widget,);
                  },

                ),
                // spacing,

                /// Share
                LikeButton(
                  mainAxisAlignment: MainAxisAlignment.end,
                  padding: EdgeInsets.zero,
                  isLiked: false,
                  onTap: (value) {
                  final FlutterShareMe flutterShareMe = FlutterShareMe();
                  flutterShareMe.shareToSystem(msg: 'Read my Show on Showwcase \n https://showwcase.com/show/${widget.showModel.id}/${widget.showModel.slug!}');
                  return Future.value(value);
                  },

                  likeBuilder: (_) {
                      /// We use align so we can manage the icon size in here
                      return Align(
                          alignment: Alignment.centerRight,
                          child: SvgPicture.asset(kShareIconSvg, colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn,), width: 15,)
                      );
                  },
                ),

                /// Comment
                LikeButton(
                  padding: EdgeInsets.zero,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  likeCountPadding: const EdgeInsets.only(right:  3, top: 8, bottom: 10),
                  onTap: (value) {

                    // if(widget.onActionItemTapped != null){
                    //   widget.onActionItemTapped!(FeedActionType.comment);
                    //   return Future.value(false);
                    // }

                    state._onFeedActionTapped( feedActionType: ShowActionType.comment, toggle: false);
                    return Future.value(value);
                  },
                  // likeCount: widget.thread.totalReplies != null && (widget.thread.totalReplies??0) > 0 ? (widget.thread.totalReplies??0) : null,
                  //likeCount: widget.thread.totalReplies,
                  bubblesColor: const BubblesColor(
                    dotSecondaryColor: Colors.transparent,
                    dotPrimaryColor: Colors.transparent,
                  ),
                  likeBuilder: (bool isCommented) {
                    /// We use align so we can manage the icon size in here
                    //return (widget.thread.totalReplies != null && (widget.thread.totalReplies??0) > 0) ? SvgPicture.asset(kCommentFilledIconSvg, color: widget.iconColor ?? kAppBlue,) :
                    return Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(kCommentOutlinedIconSvg, colorFilter: ColorFilter.mode(widget.iconColor ?? iconColor, BlendMode.srcIn), height: 16,),
                    );
                  },
                  // countBuilder: (int? count, bool isCommented, String text){
                  //   // return Text(text, style: TextStyle(color: widget.iconColor ?? (( count != null && count > 0 ) ? kAppBlue : iconColor),));
                  //   return Text(text, style: TextStyle(color: widget.iconColor ?? iconColor, fontSize: defaultFontSize - 2));
                  // },
                  // countDecoration: (widget, likCount) {
                  //   return Padding(padding: spacingBetweenIconAndCount, child: widget,);
                  // },
                ),

                /// Bookmark
                LikeButton(
                  mainAxisAlignment: MainAxisAlignment.end,
                  padding: EdgeInsets.zero,
                  isLiked: widget.showModel.hasBookmarked != null && widget.showModel.hasBookmarked!,
                  onTap: (value) {
                    return state._onFeedActionTapped(feedActionType: ShowActionType.bookmark, toggle: !value);
                  },

                  likeBuilder: (bool isBookmarked) {
                    /// We use align so we can manage the icon size in here
                    return Align(
                        alignment: Alignment.centerRight,
                        child: isBookmarked ?
                        SvgPicture.asset(kBookmarkFilledIconSvg, colorFilter: const ColorFilter.mode(kAppBlue, BlendMode.srcIn),  width: 13) :
                        SvgPicture.asset(kBookmarkOutlinedIconSvg, colorFilter: ColorFilter.mode(widget.iconColor ?? iconColor, BlendMode.srcIn,),)

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
                )
                // spacing,

                // const Spacer(),

              ],
            ),
          ),
          //const SizedBox(height: 5,),
        ],
      ),
    );

  }

  bool checkBooleans(bool a, bool b) {
    int trueCount = 0;
    if (a) {
      trueCount++;
    }
    // if (b) {
    //   trueCount++;
    // }

    // if (d) {
    //   trueCount++;
    // }
    // return trueCount >= 3;
    return trueCount > 1;
  }

  bool checkIfThreadHasAnyMetric(bool a, bool b) {
    // if (!a && !b && !c && !d) {
    //   return false;
    // }

    if (!a
        && !b
    ) {
      return false;
    }
    return true;
  }


}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ShowsActionBarWidgetController extends State<ShowsActionBarWidget> {

  late ShowsCubit showsCubit;


  @override
  Widget build(BuildContext context) => _ShowsActionBarWidgetView(this);

  @override
  void initState() {
    super.initState();

    showsCubit = context.read<ShowsCubit>();
  }

  Future<bool> _onFeedActionTapped({required ShowActionType feedActionType, required bool toggle}) async {

    switch(feedActionType) {

      case ShowActionType.upvote:
        showsCubit.upvoteShow(show: widget.showModel, isUpvote: toggle);
        break;

      case ShowActionType.bookmark:
        showsCubit.bookmarkShow(show: widget.showModel, isBookmark: toggle);
        break;

      case ShowActionType.comment:
        context.push(context.generateRoutePath(subLocation: showCommentsPage), extra: widget.showModel);
        break;
      default:
        break;
    }

    return toggle;

  }


  @override
  void dispose() {
    super.dispose();
  }

}