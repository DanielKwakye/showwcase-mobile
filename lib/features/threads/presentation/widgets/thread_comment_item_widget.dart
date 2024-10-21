import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:like_button/like_button.dart';
import 'package:separated_column/separated_column.dart';
import 'package:separated_row/separated_row.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/horizontal_cuved_line_painter.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_enums.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_preview_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_preview_state.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_comment_reply_item_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_content_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_user_meta_data_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_profile_icon_widget.dart';

class ThreadCommentItemWidget extends StatelessWidget {

  final ThreadModel thread;
  final ThreadModel comment;
  final bool hideViewAllCommentsButton;
  const ThreadCommentItemWidget({Key? key, required this.comment, required this.thread, this.hideViewAllCommentsButton = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // context.push(context.generateRoutePath(subLocation: threadPreviewPage), extra: comment);
        context.push(threadEditorPage,extra: {
          'threadToReply': comment.copyWith(
              parent: thread
          ),
          'community': comment.community
        });
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20 / 2),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Container(width: 1, color: theme.colorScheme.outline,),

                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [


                        // Comment area
                        SeparatedColumn(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 10,);
                          },
                          children: [

                            /// header meta data
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: threadSymmetricPadding, bottom: 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Expanded(child: ThreadUserMetaDataWidget(
                                    thread: comment,
                                    hideDisplayName: true,
                                    pageName: threadPreviewPage,
                                  ),),

                                  if(comment.user?.username == AppStorage.currentUserSession?.username) ... {
                                    PopupMenuButton<String>(

                                      padding: const EdgeInsets.only(right: 0.0,bottom: 0),
                                      onSelected: (menu) async {
                                        if(menu == "delete"){
                                          deleteReply(context);
                                        }else if (menu == "edit") {
                                          context.push(threadEditorPage, extra: {
                                            "threadToEdit": comment,
                                            "threadToReply": thread,
                                            "community": comment.community,
                                          });
                                        }
                                      },
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                          topLeft: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0),
                                        ),
                                      ),
                                      itemBuilder: (ctx) => [
                                        _buildPopupMenuItem(context, 'Delete comment', Icons.close, "delete"),
                                        const PopupMenuDivider(),
                                        _buildPopupMenuItem(context, 'Edit comment', Icons.edit, "edit"),
                                      ],
                                      child: Container(
                                        height: 24,
                                        width: 24,
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                            Icons.more_horiz,
                                            color:theme.colorScheme.onPrimary.withOpacity(0.7)
                                        ),
                                      ),
                                    )
                                  }
                                  // ThreadMoreMenuAction(
                                  //   thread: comment,
                                  //   paddingRight: 10,
                                  // ),
                                ],
                              ),
                            ),

                            //! Content ---------------
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 10),
                              child: ThreadContentWidget(thread: comment,),
                            ),

                            // /// Action Bar

                            /// main comment action bar
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: SeparatedRow(
                                separatorBuilder: (BuildContext context, int index) {
                                  return const SizedBox(width: 15,);
                                },
                                children: [
                                  // upvote comment
                                  // FittedBox(
                                  //   child: LikeButton(
                                  //     // likeCountPadding: const EdgeInsets.only(right: 3, top: 8, bottom: 10),
                                  //     padding: EdgeInsets.zero,
                                  //     mainAxisAlignment: MainAxisAlignment.start,
                                  //     onTap: (value)  {
                                  //       // if(widget.onActionItemTapped != null){
                                  //       //   widget.onActionItemTapped!(FeedActionType.upvote);
                                  //       // }
                                  //       // return state._onFeedActionTapped( feedActionType: ShowActionType.upvote, toggle: !value);
                                  //
                                  //       // context.read<ShowPreviewCubit>().upvoteComment(show: show, comment: reply, actionType: value ? "unvote" : "upvote", parentComment: parentComment);
                                  //       return Future.value(!value);
                                  //     },
                                  //     size: 18,
                                  //     likeCount: comment.totalUpvotes,
                                  //     isLiked: comment.hasVoted != null && comment.hasVoted!,
                                  //     bubblesColor: const BubblesColor(
                                  //       dotSecondaryColor: Color(0xff8280F7),
                                  //       dotPrimaryColor: Color(0xffE580F4),
                                  //     ),
                                  //     likeBuilder: (bool isLiked) {
                                  //       /// We use align so we can manage the icon size in here
                                  //       return Align(
                                  //         alignment: Alignment.centerLeft,
                                  //         child: !isLiked ?
                                  //         Icon(Icons.keyboard_arrow_up_rounded, color: theme.colorScheme.onPrimary, size: 21 + 4,) :
                                  //         const Icon(Icons.keyboard_arrow_up_rounded, color: kAppRed, size: 21 + 4),
                                  //       );
                                  //     },
                                  //     // countBuilder: (int? count, bool isLiked, String text){
                                  //     //   return Text(text, style: TextStyle(color:
                                  //     //   isLiked ? kAppRed :
                                  //     //   (widget.iconColor ?? iconColor),
                                  //     //       fontSize: defaultFontSize - 2
                                  //     //   ),
                                  //     //     textAlign: TextAlign.center,
                                  //     //
                                  //     //   );
                                  //     // },
                                  //     countDecoration: (widget, likCount) {
                                  //       return Padding(padding: const EdgeInsets.all(0.0), child: widget,);
                                  //     },
                                  //
                                  //   ),
                                  // ),
                                  LikeButton(
                                    size: 26,
                                    padding: EdgeInsets.zero,
                                    onTap: (value) {
                                      final toggle = !value;
                                      context.read<ThreadCubit>().upvoteThread(thread: comment, actionType: toggle ? UpvoteActionType.upvote : UpvoteActionType.unvote);
                                      return Future.value(toggle);
                                    },
                                    likeCount: comment.totalUpvotes,
                                    isLiked: comment.hasVoted ?? false,
                                    bubblesColor: const BubblesColor(
                                      dotSecondaryColor: Color(0xff8280F7),
                                      dotPrimaryColor: Color(0xffE580F4),
                                    ),
                                    likeBuilder: (bool liked) {
                                      // return SvgPicture.asset(kCommentIconSvg, color:  theme.colorScheme.onPrimary);
                                      return Align(
                                        alignment: Alignment.centerLeft,
                                        // child: !liked ?
                                        // Icon(Icons.keyboard_arrow_up_rounded, color: theme.colorScheme.onPrimary, size: 21 + 2,) :
                                        // const Icon(Icons.keyboard_arrow_up_rounded, color: kAppRed, size: 21 + 2),
                                        child:  SvgPicture.asset(!liked ? kBoostOutlineIconSvg : kBoostIconSvg,
                                          colorFilter: ColorFilter.mode(!liked  ?theme.colorScheme.onPrimary : kAppRed , BlendMode.srcIn,),
                                          height: 18,
                                        ),
                                      );
                                      // return liked ? Icon(Icons.keyboard_arrow_up_rounded, color: theme.colorScheme.onPrimary, size: 21 + 4,) :
                                      //         const Icon(Icons.keyboard_arrow_up_rounded, color: kAppRed, size: 21 + 4);
                                    },
                                    countBuilder: (int? count, bool liked, String text){
                                      return Text(text, style: TextStyle(color: liked? kAppRed : theme.colorScheme.onPrimary,));
                                    },
                                    countDecoration: (widget, likCount) {
                                      return Padding(padding: const EdgeInsets.only(left: 0), child: widget,);
                                    },
                                  ),

                                  // Send
                                  // LikeButton(
                                  //   padding: EdgeInsets.zero,
                                  //   // mainAxisAlignment: MainAxisAlignment.center,
                                  //   likeCountPadding: const EdgeInsets.only(right:  3, top: 8, bottom: 10),
                                  //   onTap: (value) {
                                  //
                                  //     // if(widget.onActionItemTapped != null){
                                  //     //   widget.onActionItemTapped!(FeedActionType.comment);
                                  //     //   return Future.value(false);
                                  //     // }
                                  //     // state._onFeedActionTapped( feedActionType: ThreadFeedActionType.comment, toggle: false);
                                  //     return Future.value(false);
                                  //   },
                                  //   // likeCount: widget.thread.totalReplies != null && (widget.thread.totalReplies??0) > 0 ? (widget.thread.totalReplies??0) : null,
                                  //   //likeCount: widget.thread.totalReplies,
                                  //   bubblesColor: const BubblesColor(
                                  //     dotSecondaryColor: Colors.transparent,
                                  //     dotPrimaryColor: Colors.transparent,
                                  //   ),
                                  //   likeBuilder: (bool isCommented) {
                                  //     /// We use align so we can manage the icon size in here
                                  //     //return (widget.thread.totalReplies != null && (widget.thread.totalReplies??0) > 0) ? SvgPicture.asset(kCommentFilledIconSvg, color: widget.iconColor ?? kAppBlue,) :
                                  //     return Align(
                                  //       alignment: Alignment.center,
                                  //       child: SvgPicture.asset(kSendIconSvg, colorFilter: ColorFilter.mode(theme.colorScheme.onPrimary, BlendMode.srcIn), height: 21,),
                                  //     );
                                  //   },
                                  //   // countBuilder: (int? count, bool isCommented, String text){
                                  //   //   // return Text(text, style: TextStyle(color: widget.iconColor ?? (( count != null && count > 0 ) ? kAppBlue : iconColor),));
                                  //   //   return Text(text, style: TextStyle(color: widget.iconColor ?? iconColor, fontSize: defaultFontSize - 2));
                                  //   // },
                                  //   countDecoration: (widget, likCount) {
                                  //     return Padding(padding: const EdgeInsets.only(left: 0), child: widget,);
                                  //   },
                                  // ),

                                  // Comment
                                  LikeButton(
                                    size: 16,
                                    padding: EdgeInsets.zero,
                                    onTap: (value) {
                                      // return state._onActionBarItemTapped( comment: commentState, feedActionType: FeedActionType.comment, toggle: false);
                                      context.push(threadEditorPage,extra: {
                                        'threadToReply': comment.copyWith(
                                          parent: thread
                                        ),
                                        'community': comment.community
                                      });
                                      return Future.value(null);
                                    },
                                    likeCount: comment.totalReplies,
                                    bubblesColor: const BubblesColor(
                                      dotSecondaryColor: Colors.transparent,
                                      dotPrimaryColor: Colors.transparent,
                                    ),
                                    likeBuilder: (_) {
                                      return SvgPicture.asset(kCommentIconSvg, colorFilter:  ColorFilter.mode(theme.colorScheme.onPrimary, BlendMode.srcIn));
                                    },
                                    countBuilder: (int? count, bool isLiked, String text){
                                      return Text(text, style: TextStyle(color: theme.colorScheme.onPrimary,));
                                    },
                                    countDecoration: (widget, likCount) {
                                      return Padding(padding: const EdgeInsets.only(left: 3), child: widget,);
                                    },
                                  ),


                                ],
                              ),
                            ),


                            if((comment.totalReplies != null && comment.totalReplies! > 0)) ... {

                              // view all comments //////

                              if(!hideViewAllCommentsButton) ... {
                                BlocBuilder<ThreadPreviewCubit, ThreadPreviewState>(
                                  builder: (context, threadPreviewState) {
                                    if(threadPreviewState.status == ThreadStatus.fetchThreadCommentRepliesInProgress && threadPreviewState.data == comment.id) {
                                      return const Padding(
                                          padding: EdgeInsets.only(left: 25, top: 0, bottom: 5),
                                          child: CustomAdaptiveCircularIndicator()
                                      );
                                    }
                                    return BlocSelector<ThreadPreviewCubit, ThreadPreviewState, List<ThreadModel>>(
                                      selector: (threadState){
                                        return threadState.threadCommentReplies[comment.id] ?? <ThreadModel>[];
                                      },
                                      builder: (context, List<ThreadModel> replyList) {

                                        if(replyList.isNotEmpty) {
                                          return const SizedBox.shrink();
                                        }

                                        return GestureDetector(
                                          onTap: () {
                                            context.read<ThreadPreviewCubit>().fetchThreadCommentReplies(pageKey: 0, thread: thread, comment: comment);
                                          },
                                          behavior: HitTestBehavior.opaque,
                                          child:  Container(
                                            width: double.maxFinite,
                                            padding: const EdgeInsets.only(left: 25, top: 0, bottom: 5),
                                            child: const Text("View all replies",
                                              style: TextStyle(color: kAppBlue, fontSize: 14),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                    ;
                                  },
                                )
                              }


                            },

                          ],
                        ),

                        /// Comment Replies Section ---------
                        BlocSelector<ThreadPreviewCubit, ThreadPreviewState, List<ThreadModel>>(
                          selector: (threadState){
                              return threadState.threadCommentReplies[comment.id] ?? <ThreadModel>[];
                          },
                          builder: (context, List<ThreadModel> replyList) {

                            if(replyList.isEmpty) {
                              return const SizedBox.shrink();
                            }

                              return SeparatedColumn(separatorBuilder: (BuildContext context, int index) {
                                return const SizedBox(height: 7,);
                              }, children: [
                                ...replyList.map((reply) {


                                  return BlocSelector<ThreadPreviewCubit, ThreadPreviewState, ThreadModel>(
                                    key: ValueKey(reply.id),
                                    selector: (threadPreviewState) {
                                      return threadPreviewState.threadCommentReplies[comment.id]!.firstWhere((element) => element.id == reply.id);
                                    },
                                    builder: (context, reactiveReply) {
                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Container(
                                            width: 23, height: 23,
                                            margin: const EdgeInsets.only(top: 0),
                                            child: CustomPaint(
                                              painter: HorizontalCurvedLinePainter(color: theme.colorScheme.outline),
                                            ),
                                            // color: theme.colorScheme.outline, margin: const EdgeInsets.only(top: 35 / 2 ),
                                          ),

                                          Expanded(child: GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                context.push(threadEditorPage,extra: {
                                                  'threadToReply': comment.copyWith(
                                                      parent: thread
                                                  ),
                                                  'community': comment.community
                                                });
                                              },
                                              child: ThreadCommentReplyItemWidget(reply: reactiveReply, parentComment: comment, thread: thread,))
                                          )
                                        ],
                                      );
                                    },
                                  )
                                  ;

                                })
                              ],);


                          },
                        )

                        // if((comment.replies  ?? [] ).isNotEmpty) ... {
                        //   const SizedBox(height: 0,),
                        //
                        //
                        // }
                      ],
                    ),
                  ))

                ],
              ),
            ),
          ),

          UserProfileIconWidget(
              user: comment.user!,
              size: 20,
              dimension: '100x'
          ),

        ],
      )
      // Container(
      //   padding: const EdgeInsets.symmetric(horizontal: threadSymmetricPadding),
      //   child: IntrinsicHeight(
      //     child: Row(
      //       crossAxisAlignment: CrossAxisAlignment.stretch,
      //       children: [
      //
      //         SizedBox(
      //           // color: Colors.yellow,
      //           width:  35.0,
      //           child: CustomPaint(
      //             painter: StraightLinePaint(color: theme(context).colorScheme.outline, strokeWidth: 1, startHeight: 40, endOffset: 15),
      //             child:  Align(
      //               alignment: Alignment.topCenter,
      //               child: UnconstrainedBox(
      //                 child: UserProfileIconWidget(
      //                     user: thread.user!,
      //                     size: 35,
      //                     dimension: '100x'
      //                 ),
      //               ),
      //             ),
      //           ),
      //
      //         ),
      //
      //         const SizedBox(width: 8,),
      //
      //         Expanded(child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: <Widget>[
      //
      //             /// Replies header ----
      //
      //             Row(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //
      //                 Expanded(child: ThreadUserMetaDataWidget(
      //                   thread: thread,
      //                 ),),
      //
      //                 ThreadMoreMenuAction(
      //                   thread: thread,
      //                   paddingRight: 10,
      //                 ),
      //               ],
      //             ),
      //             /// Main content
      //
      //             const SizedBox(height: 10,),
      //
      //             SeparatedColumn(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               separatorBuilder: (BuildContext context, int index) {
      //               return const SizedBox(height: 10,);
      //             },
      //               children: [
      //                 //! Title section
      //                 if(!thread.title.isNullOrEmpty())...{
      //                   Padding(
      //                       padding: const EdgeInsets.symmetric(horizontal: 0),
      //                       child: Text(thread.title ?? '', style: TextStyle(
      //                           height: defaultLineHeight,
      //                           fontSize: defaultFontSize + 2,
      //                           fontWeight: FontWeight.w700,
      //                           color: Theme.of(context).colorScheme.onBackground)
      //                       )
      //                   )
      //
      //                 },
      //
      //                 // /// Message Section
      //                 if(!thread.message.isNullOrEmpty())...{
      //
      //                   ThreadMessageWidget(
      //                     threadModel: thread,
      //                   )
      //                   // if(isContainingAnyLink(thread.message) && thread.linkPreviewMeta == null)AnyLinkPreviewWidget(message:thread.message!,)
      //
      //                 },
      //
      //                 /// Link preview section
      //                 if(thread.linkPreviewMeta != null )...{
      //                   CustomLinkPreviewWidget(linkPreviewMeta: thread.linkPreviewMeta!,
      //                     onTap: (url) => context.push(context.generateRoutePath(subLocation: threadBrowserPage,), extra: {
      //                       "url": url,
      //                       "thread": thread
      //                     }),
      //                   ),
      //                 }else if(!thread.message.isNullOrEmpty() && isContainingAnyLink(thread.message)) ...{
      //                   CustomAnyLinkPreviewWidget(message:thread.message!, onTap: (url){
      //                     context.push(context.generateRoutePath(subLocation: threadBrowserPage), extra: {
      //                       "url": url,
      //                       "thread": thread
      //                     });
      //                   },)
      //                 },
      //
      //                 /// Images section
      //                 if((thread.images ?? []).isNotEmpty) ...{
      //                   CustomImagesWidget(
      //                     images: thread.images ?? [],
      //                     onTap: (index, images){
      //                       context.push(context.generateRoutePath(subLocation: "thread-images-preview"), extra: {
      //                         'thread': thread,
      //                         'galleryItems': images,
      //                         'initialPageIndex': index
      //                       });
      //                     },
      //                   ),
      //                 },
      //
      //                 /// Gif section
      //                 if(thread.gif != null) ...{
      //                   CustomGifWidget(url: thread.gif?.tiny?.url ?? '', onTap: () {
      //                     context.push(context.generateRoutePath(subLocation: "thread-images-preview"), extra: {
      //                       'thread': thread,
      //                       'galleryItems': [thread.gif?.tiny?.url ?? ''],
      //                       'initialPageIndex': 0
      //                     });
      //                   },),
      //                 },
      //
      //
      //                 /// Code section
      //                 if(!thread.code.isNullOrEmpty()) ...{
      //                   CustomCodeViewWidget(tag: thread.id.toString(), code: thread.code ?? '',
      //                     codeLanguage: thread.codeLanguage,
      //                     onTap: () {
      //                       context.push(context.generateRoutePath(subLocation: "thread-code-preview"), extra: {
      //                         'thread': thread,
      //                         'code': thread.code,
      //                         'tag': thread.id.toString()
      //                       });
      //                     },
      //                   ),
      //                 },
      //
      //
      //                 /// Action Bar
      //                 Padding(
      //                   padding: const EdgeInsets.only(right: 10, top: 0),
      //                   child: ThreadFeedActionBarWidget(
      //                     thread: thread,
      //                   ),
      //                 ),
      //               ],
      //             )
      //
      //           ],
      //         )),
      //
      //         // const SizedBox(width: 8,),
      //         //
      //         // if(showFeedActionBar) ... {
      //         //   ThreadMoreMenuAction<T>(
      //         //     thread: thread,
      //         //     entryId: entryId,
      //         //   ),
      //         // }
      //
      //
      //       ],
      //
      //     ),
      //   ),
      // ),
    );
  }

  void deleteReply(BuildContext context) {
    showConfirmDialog(context, onConfirmTapped: () async {
      final homeCubit = context.read<HomeCubit>();
      homeCubit.enablePageLoad();
      await context.read<ThreadCubit>().deleteThread(thread: comment.copyWith(
          parent: thread,
          parentId: thread.id
      ));
      homeCubit.dismissPageLoad();
    }, title: "Delete comment ?");
  }

  PopupMenuItem<String> _buildPopupMenuItem(
      BuildContext context, String title, IconData iconData, String value) {

    final theme = Theme.of(context);

    return PopupMenuItem(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      value: value,
      height: 30,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 12,),
          Icon(iconData, color: theme.colorScheme.onBackground, size: 16,),
          // const SizedBox(width: 15,),
          const SizedBox(width: 8,),
          Text(title, style: TextStyle(color: theme.colorScheme.onBackground, fontSize: defaultFontSize - 1),),
          const SizedBox(width: 8,),
        ],
      ),
    );
  }


}
