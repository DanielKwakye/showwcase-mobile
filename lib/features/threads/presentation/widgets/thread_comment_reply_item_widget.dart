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
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_cubit.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_content_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_user_meta_data_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_profile_icon_widget.dart';

import '../../data/bloc/thread_enums.dart';

class ThreadCommentReplyItemWidget extends StatelessWidget {

  final ThreadModel reply;
  final ThreadModel parentComment;
  final ThreadModel thread;
  const ThreadCommentReplyItemWidget({Key? key, required this.reply, required this.parentComment, required this.thread}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.push(threadEditorPage,extra: {
          'threadToReply': parentComment.copyWith(
              parent: thread
          ),
          'usernameToReply': reply.user?.username,
          'community': parentComment.community
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(
            // color: Colors.yellow,
            width:  20.0,
            child: UnconstrainedBox(
                child: UserProfileIconWidget(
                    user: reply.user!,
                    size: 20,
                    dimension: '100x'
                )

            ),

          ),
          const SizedBox(width: 8,),
          Expanded(child: SeparatedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 10,);
            },
            children: [

              /// header meta data

              Padding(
                  padding: const EdgeInsets.only(right: threadSymmetricPadding),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: ThreadUserMetaDataWidget(thread: reply, hideDisplayName: true,pageName: 'thread_comment_reply'),),
                      if(reply.user?.username == AppStorage.currentUserSession?.username) ... {
                        PopupMenuButton<String>(

                          padding: const EdgeInsets.only(right: 0.0,bottom: 0),
                          onSelected: (menu) async {
                            if(menu == "delete"){
                              deleteReply(context);
                            }else if (menu == "edit") {
                              context.push(threadEditorPage, extra: {
                                "threadToEdit": reply,
                                "threadToReply": parentComment,
                                "community": parentComment.community,
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
                            _buildPopupMenuItem(context, 'Delete reply', Icons.close, "delete"),
                            const PopupMenuDivider(),
                            _buildPopupMenuItem(context, 'Edit reply', Icons.edit, "edit"),
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
                    ],
                  ),
              ),

              ///
              Padding(
                  padding: const EdgeInsets.only(right: 11),
                  child: ThreadContentWidget(thread: reply),
              ),

              /// main reply action bar
              SeparatedRow(

                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(width: 10,);
                },

                children: [

                  // upvote comment
                  LikeButton(
                    size: 26,
                    padding: EdgeInsets.zero,
                    onTap: (value) {
                      final toggle = !value;
                      context.read<ThreadCubit>().upvoteThread(thread: reply, actionType: toggle ? UpvoteActionType.upvote : UpvoteActionType.unvote);
                      return Future.value(toggle);
                    },
                    likeCount: reply.totalUpvotes,
                    isLiked: reply.hasVoted != null && reply.hasVoted!,
                    bubblesColor: const BubblesColor(
                      dotSecondaryColor: Color(0xff8280F7),
                      dotPrimaryColor: Color(0xffE580F4),
                    ),
                    likeBuilder: (bool liked) {
                      // return SvgPicture.asset(kCommentIconSvg, color:  theme.colorScheme.onPrimary);
                      return Align(
                        alignment: Alignment.centerLeft,
                        child:
                        SvgPicture.asset(!liked ? kBoostOutlineIconSvg : kBoostIconSvg,
                          colorFilter: ColorFilter.mode(!liked  ?theme.colorScheme.onPrimary : kAppRed , BlendMode.srcIn,),
                          height: 18,
                        ),
                      );
                      // return liked ? Icon(Icons.keyboard_arrow_up_rounded, color: theme.colorScheme.onPrimary, size: 21 + 4,) :
                      //         const Icon(Icons.keyboard_arrow_up_rounded, color: kAppRed, size: 21 + 4);
                    },
                    countBuilder: (int? count, bool liked, String text){
                      return Text(text, style: TextStyle(color: liked ? kAppRed : theme.colorScheme.onPrimary,));
                    },
                    countDecoration: (widget, likCount) {
                      return Padding(padding: const EdgeInsets.only(left: 0), child: widget,);
                    },
                  ),

                  // Send
                  IgnorePointer(
                    ignoring: true, // we set ignore pointer because the onTap has been handled by the entire commentReplyWidget
                    child: LikeButton(
                      padding: EdgeInsets.zero,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      likeCountPadding: const EdgeInsets.only(right:  3, top: 8, bottom: 10),
                      onTap: (value) {

                        // if(widget.onActionItemTapped != null){
                        //   widget.onActionItemTapped!(FeedActionType.comment);
                        //   return Future.value(false);
                        // }
                        // state._onFeedActionTapped( feedActionType: ThreadFeedActionType.comment, toggle: false);
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
                          child: SvgPicture.asset(kCommentIconSvg, colorFilter: ColorFilter.mode(theme.colorScheme.onPrimary, BlendMode.srcIn), height: 18,),
                        );
                      },
                      // countBuilder: (int? count, bool isCommented, String text){
                      //   // return Text(text, style: TextStyle(color: widget.iconColor ?? (( count != null && count > 0 ) ? kAppBlue : iconColor),));
                      //   return Text(text, style: TextStyle(color: widget.iconColor ?? iconColor, fontSize: defaultFontSize - 2));
                      // },
                      countDecoration: (widget, likCount) {
                        return Padding(padding: const EdgeInsets.only(left: 0), child: widget,);
                      },
                    ),
                  ),

                ],
              ),

            ],
          ))

        ],
      ),
    );
  }

  void deleteReply(BuildContext context) {
    showConfirmDialog(context, onConfirmTapped: () async {
      final homeCubit = context.read<HomeCubit>();
      homeCubit.enablePageLoad();
      await context.read<ThreadCubit>().deleteThread(thread: reply.copyWith(
          parent: parentComment,
          parentId: parentComment.id
      ));
      homeCubit.dismissPageLoad();
    }, title: "Delete reply ?");
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
