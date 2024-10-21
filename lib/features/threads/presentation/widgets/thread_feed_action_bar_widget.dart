import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:like_button/like_button.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_enums.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';

class ThreadFeedActionBarWidget extends StatefulWidget {

  final ThreadModel thread;
  final Color? iconColor;
  final Color? separatorColor;
  final bool showUpvoters;
  final bool hideActions;
  const ThreadFeedActionBarWidget({Key? key, required this.thread, this.iconColor, this.separatorColor, this.showUpvoters = true, this.hideActions = false}) : super(key: key);

  @override
  ThreadFeedActionBarWidgetController createState() => ThreadFeedActionBarWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ThreadFeedActionBarWidgetView extends WidgetView<ThreadFeedActionBarWidget, ThreadFeedActionBarWidgetController> {

  const _ThreadFeedActionBarWidgetView(ThreadFeedActionBarWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const iconSize = 20.0;
    const spacingBetweenIconAndCount = EdgeInsets.only(left: 0);

    bool shouldJustify  = checkBooleans((widget.thread.totalUpvotes??0) > 0 , (widget.thread.totalBoosts??0) > 0 , (widget.thread.totalReplies??0) > 0 ,( widget.thread.views??0) > 0 );
    bool shouldReduceHeight = checkIfThreadHasAnyMetric((widget.thread.totalUpvotes??0) > 0 , (widget.thread.totalBoosts??0) > 0 , (widget.thread.totalReplies??0) > 0 , (widget.thread.views??0) > 0 );
    final iconColor = widget.iconColor ?? theme.colorScheme.onPrimary;
    return SizedBox(
      height: widget.hideActions ? 40 : shouldReduceHeight ? 78 : 45,
      width: width(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: 20,),
          //   const CustomBorderWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: shouldJustify ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
              children: [
                if((widget.thread.totalUpvotes??0) > 0)  GestureDetector(
                  onTap: (){
                    if(widget.showUpvoters) {
                      context.push(context.generateRoutePath(subLocation: threadUpVotersPage), extra: widget.thread);
                    }
                    // if(widget.inPreviewMode){
                    //   changeScreenWithConstructor(context, ThreadUpVotersWidget(
                    //     thread: threadResponse,
                    //     votersCount: threadResponse.totalUpvotes ?? 0,
                    //   ), rootNavigator: true, fullscreenDialog: true);
                    // }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10,bottom: 10,right: 10),
                    child: RichText(
                      text: TextSpan(
                        text: (formatHumanReadable(widget.thread.totalUpvotes ?? 0)).toString(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: widget.iconColor ?? theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          if ((widget.thread.totalUpvotes ?? 0) > 1) ...{
                            TextSpan(
                                text: ' Upvotes',
                                style: TextStyle(
                                    color: widget.iconColor ?? theme.colorScheme.onPrimary,fontWeight: FontWeight.w400,fontSize: defaultFontSize - 1)),
                          },
                          if ((widget.thread.totalUpvotes ?? 0) == 1) ...{
                            TextSpan(
                                text: ' Upvote',
                                style: TextStyle(
                                    color: widget.iconColor ?? theme.colorScheme.onPrimary,fontWeight: FontWeight.w400,fontSize: defaultFontSize - 1)),
                          },
                        ],
                      ),
                    ),
                  ),
                ),
                if((widget.thread.totalBoosts??0) > 0)   Padding(
                  padding: const EdgeInsets.only(top: 10,bottom: 10,right: 10),
                  child: RichText(
                    text: TextSpan(
                      text: (formatHumanReadable(widget.thread.totalBoosts ?? 0)).toString(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: widget.iconColor ?? theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600),
                      children: <TextSpan>[
                        if ((widget.thread.totalBoosts ?? 0) > 1) ...{
                          TextSpan(
                              text: ' Boosts',
                              style: TextStyle(
                                  color: widget.iconColor ?? theme.colorScheme.onPrimary,fontWeight: FontWeight.w400,fontSize: defaultFontSize - 1)),
                        },
                        if ((widget.thread.totalBoosts ?? 0) == 1) ...{
                          TextSpan(
                              text: ' Boost',
                              style: TextStyle(
                                  color: widget.iconColor ?? theme.colorScheme.onPrimary,fontWeight: FontWeight.w400,fontSize: defaultFontSize - 1)),
                        },
                      ],
                    ),
                  ),
                ),
                if((widget.thread.totalReplies??0) > 0)  Padding(
                  padding: const EdgeInsets.only(top: 10,bottom: 10,right: 10),
                  child: RichText(
                    text: TextSpan(
                      text: (formatHumanReadable(widget.thread.totalReplies ?? 0)),
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: widget.iconColor ?? theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600),
                      children: <TextSpan>[
                        if ((widget.thread.totalReplies ?? 0) > 1) ...{
                          TextSpan(
                              text: ' Comments',
                              style: TextStyle(
                                  color: widget.iconColor ?? theme.colorScheme.onPrimary,fontWeight: FontWeight.w400,fontSize: defaultFontSize - 1)),
                        },
                        if ((widget.thread.totalReplies ?? 0) == 1) ...{
                          TextSpan(
                              text: ' Comment',
                              style: TextStyle(
                                  color: widget.iconColor ?? theme.colorScheme.onPrimary,fontWeight: FontWeight.w400,fontSize: defaultFontSize - 1)),
                        },
                      ],
                    ),
                  ),
                ),
                // if(threadResponse.views! > 0)  Padding(
                //   padding: const EdgeInsets.only(top: 10,bottom: 10),
                //     child: RichText(
                //       text: TextSpan(
                //         text: (formatHumanReadable(threadResponse.views ?? 0)),
                //         style: TextStyle(
                //             color: theme.colorScheme.onBackground,
                //             fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis),
                //         children: <TextSpan>[
                //           if ((threadResponse.views ?? 0) > 1) ...{
                //             TextSpan(
                //                 text: ' Views',
                //                 style: TextStyle(
                //                     color: theme.colorScheme.onPrimary,fontWeight: FontWeight.w400)),
                //           },
                //           if ((threadResponse.views ?? 0) == 1) ...{
                //             TextSpan(
                //                 text: ' View',
                //                 style: TextStyle(
                //                     color: theme.colorScheme.onPrimary,fontWeight: FontWeight.w400)),
                //           },
                //         ],
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
          if(shouldReduceHeight && !widget.hideActions)
               CustomBorderWidget(top: 2, bottom: 5, left: 0, right: 0, color: widget.separatorColor,),
          // const SizedBox(height: 10,),

          /// Ensure the tappable area fill the whole width of the expanded
          if(!widget.hideActions)  ... {
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Like (Upvote)
                  LikeButton(
                    // likeCountPadding: const EdgeInsets.only(right: 3, top: 8, bottom: 10),
                    padding: EdgeInsets.zero,
                    mainAxisAlignment: MainAxisAlignment.start,
                    onTap: (value)  {
                      // if(widget.onActionItemTapped != null){
                      //   widget.onActionItemTapped!(FeedActionType.upvote);
                      // }
                      return state._onFeedActionTapped( feedActionType: ThreadFeedActionType.upvote, toggle: !value);
                    },
                    // size: iconSize + 2,
                    //likeCount: threadResponse.totalUpvotes,
                    isLiked: widget.thread.hasVoted != null && widget.thread.hasVoted!,
                    bubblesColor: const BubblesColor(
                      dotSecondaryColor: Color(0xff8280F7),
                      dotPrimaryColor: Color(0xffE580F4),
                    ),
                    likeBuilder: (bool isLiked) {
                      /// We use align so we can manage the icon size in here
                      return Align(
                          alignment: Alignment.centerLeft,
                          child:  SvgPicture.asset(!isLiked ? kBoostOutlineIconSvg : kBoostIconSvg,
                            colorFilter: ColorFilter.mode(!isLiked ?
                            widget.iconColor ?? iconColor : kAppRed, BlendMode.srcIn,),
                            height: 20,
                          )
                        // child: !isLiked ?
                        // Icon(Icons.keyboard_arrow_up_rounded, color: widget.iconColor ?? iconColor, size: iconSize + 12,) :
                        // const Icon(Icons.keyboard_arrow_up_rounded, color: kAppRed, size: iconSize + 12),
                        // Icon(Icons.favorite_outline_sharp, color: widget.iconColor ?? iconColor, size: iconSize,) :
                        // const Icon(Icons.favorite_rounded, color: kAppRed, size: iconSize),
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

                  /// Boost
                  // LikeButton(
                  //   padding: EdgeInsets.zero,
                  //   // mainAxisAlignment: MainAxisAlignment.center,
                  //   likeCountPadding: const EdgeInsets.only(right:  3, top: 8, bottom: 10),
                  //   // size: iconSize,
                  //   isLiked: widget.thread.hasBoosted != null && widget.thread.hasBoosted!,
                  //   //likeCount: threadResponse.totalBoosts,
                  //   // likeCount: state.boostTread.totalBoosts == null || state.boostTread.totalBoosts == 0 ? null : state.boostTread.totalBoosts!,
                  //   onTap: (value) {
                  //
                  //     // if(widget.onActionItemTapped != null){
                  //     //   widget.onActionItemTapped!(FeedActionType.boost);
                  //     // }
                  //
                  //     return state._onFeedActionTapped(feedActionType: ThreadFeedActionType.boost, toggle: !value);
                  //   },
                  //   bubblesColor: const BubblesColor(
                  //     dotSecondaryColor: kAppGreen,
                  //     dotPrimaryColor: kAppGreen,
                  //   ),
                  //   likeBuilder: (bool isBoosted) {
                  //     /// We use align so we can manage the icon size in here
                  //     return Align(
                  //       alignment: Alignment.centerLeft,
                  //       child: SvgPicture.asset(!isBoosted ? kBoostOutlineIconSvg : kBoostIconSvg,
                  //           colorFilter: ColorFilter.mode(!isBoosted ?
                  //           widget.iconColor ?? iconColor : kAppGreen, BlendMode.srcIn,),
                  //         height: 20,
                  //       ),
                  //     );
                  //   },
                  //   // countBuilder: (int? count, bool isLiked, String text){
                  //   //   return Text(text, style: TextStyle(color:
                  //   //   isLiked ? kAppGreen :
                  //   //   widget.iconColor ?? iconColor, fontSize: defaultFontSize - 2),);
                  //   // },
                  //   countDecoration: (widget, likCount) {
                  //     return Padding(padding: spacingBetweenIconAndCount, child: widget,);
                  //   },
                  // ),
                  // spacing,

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

                      state._onFeedActionTapped( feedActionType: ThreadFeedActionType.comment, toggle: false);
                      return Future.value(false);
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

                  /// Send message
                  LikeButton(
                    padding: EdgeInsets.zero,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    likeCountPadding: const EdgeInsets.only(right:  3, top: 8, bottom: 10),
                    onTap: (value) {

                      // if(widget.onActionItemTapped != null){
                      //   widget.onActionItemTapped!(FeedActionType.comment);
                      //   return Future.value(false);
                      // }

                      state._onFeedActionTapped( feedActionType: ThreadFeedActionType.share, toggle: false);
                      return Future.value(false);
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
                        child: SvgPicture.asset(kSendIconSvg, colorFilter: ColorFilter.mode((widget.iconColor ?? iconColor), BlendMode.srcIn), height: 23,),
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
                    isLiked: widget.thread.hasBookmarked != null && widget.thread.hasBookmarked!,
                    onTap: (value) {
                      return state._onFeedActionTapped(feedActionType: ThreadFeedActionType.bookmark, toggle: !value);
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
          }

          //const SizedBox(height: 5,),
        ],
      ),
    );
  }


  bool checkBooleans(bool a, bool b, bool c, bool d) {
    int trueCount = 0;
    if (a) {
      trueCount++;
    }
    if (b) {
      trueCount++;
    }
    if (c) {
      trueCount++;
    }
    // if (d) {
    //   trueCount++;
    // }
    // return trueCount >= 3;
    return trueCount > 2;
  }

  bool checkIfThreadHasAnyMetric(bool a, bool b, bool c, bool d) {
    // if (!a && !b && !c && !d) {
    //   return false;
    // }

    if (!a && !b && !c) {
      return false;
    }
    return true;
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ThreadFeedActionBarWidgetController extends State<ThreadFeedActionBarWidget> {

  late ThreadCubit threadCubit;
  final FlutterShareMe flutterShareMe = FlutterShareMe();
  @override
  Widget build(BuildContext context) => _ThreadFeedActionBarWidgetView(this);

  @override
  void initState() {
    super.initState();
    threadCubit = context.read<ThreadCubit>();
  }

  Future<bool> _onFeedActionTapped({required ThreadFeedActionType feedActionType, required bool toggle}) async {

    switch(feedActionType) {

      case ThreadFeedActionType.upvote:
        threadCubit.upvoteThread(thread: widget.thread, actionType: toggle ? UpvoteActionType.upvote : UpvoteActionType.unvote);
        break;

      case ThreadFeedActionType.boost:
        threadCubit.boostThread(thread: widget.thread, actionType: toggle ? BoostActionType.boost : BoostActionType.unboost);
        break;

      case ThreadFeedActionType.share:

        final link = "${ApiConfig.websiteUrl}/thread/${widget.thread.id}";
        flutterShareMe.shareToSystem(msg: link);
        break;

      case ThreadFeedActionType.bookmark:
        threadCubit.bookmarkThread(thread: widget.thread, isBookmark: toggle );
        break;

      case ThreadFeedActionType.comment:
        context.push(threadEditorPage, extra: {
          'threadToReply': widget.thread,
          'community': widget.thread.community
        });
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