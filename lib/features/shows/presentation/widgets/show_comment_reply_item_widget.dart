import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:like_button/like_button.dart';
import 'package:separated_column/separated_column.dart';
import 'package:separated_row/separated_row.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/straight_line_painter.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_cubit.dart';
import 'package:showwcase_v3/features/shows/data/models/show_comment_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_comment_message_widget.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/shows_user_meta_data_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_profile_icon_widget.dart';

import '../../../../app/routing/route_constants.dart';

class ShowCommentReplyItemWidget extends StatelessWidget {

  final ShowCommentModel reply;
  final ShowCommentModel parentComment;
  final ShowModel show;
  const ShowCommentReplyItemWidget({Key? key, required this.reply, required this.show, required this.parentComment}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          SizedBox(
            // color: Colors.yellow,
            width:  35.0,
            child: CustomPaint(
              painter: StraightLinePaint(color: theme.colorScheme.outline, strokeWidth: 1, startHeight: 40, endOffset: 0),
              child:  Align(
                alignment: Alignment.topCenter,
                child: UnconstrainedBox(
                  child: UserProfileIconWidget(
                      user: reply.user!,
                      size: 35,
                      dimension: '100x'
                  ),
                ),
              ),
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

              Row(
                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Expanded(child: ShowsUserMetaDataWidget(user: reply.user!, show: show, showMoreMenu: false, showUsername: true, withTime: reply.createdAt,),),
                   if(reply.user?.username == AppStorage.currentUserSession?.username) ... {
                     PopupMenuButton<String>(

                       padding: const EdgeInsets.only(right: 0.0,bottom: 0),
                       onSelected: (menu) {
                         if(menu == "delete"){
                           context.read<ShowPreviewCubit>().deleteComment(show: show, comment: reply, parentComment: parentComment);
                         }else if (menu == "edit") {
                           context.push(context.generateRoutePath(subLocation: showCommentsEditorPage), extra: {
                             'show': show,
                             'commentToEdit': reply,
                             'parentComment': parentComment,
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
                 ],
              ),

              ShowCommentMessageWidget(showModel: show , message: reply.message ?? '',),

              /// main reply action bar
              SeparatedRow(
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(width: 10,);
                },
                children: [
                  // upvote comment
                  LikeButton(
                    // likeCountPadding: const EdgeInsets.only(right: 3, top: 8, bottom: 10),
                    padding: EdgeInsets.zero,
                    mainAxisAlignment: MainAxisAlignment.start,
                    onTap: (value)  {
                      // if(widget.onActionItemTapped != null){
                      //   widget.onActionItemTapped!(FeedActionType.upvote);
                      // }
                      // return state._onFeedActionTapped( feedActionType: ShowActionType.upvote, toggle: !value);
                      context.read<ShowPreviewCubit>().upvoteComment(show: show, comment: reply, actionType: value ? "unvote" : "upvote", parentComment: parentComment);
                      return Future.value(!value);
                    },
                    size: 18,
                    likeCount: reply.totalUpvotes,
                    isLiked: reply.hasVoted != null && reply.hasVoted!,
                    bubblesColor: const BubblesColor(
                      dotSecondaryColor: Color(0xff8280F7),
                      dotPrimaryColor: Color(0xffE580F4),
                    ),
                    likeBuilder: (bool isLiked) {
                      /// We use align so we can manage the icon size in here
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: !isLiked ?
                        Icon(Icons.favorite_outline_sharp, color: theme.colorScheme.onPrimary, size: 18,)
                            : const Icon(Icons.favorite_rounded, color: kAppRed, size: 18),
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
                      return Padding(padding: const EdgeInsets.all(0.0), child: widget,);
                    },

                  ),


                ],
              ),
            ],
          ))

        ],
      ),
    );

  }

  PopupMenuItem<String> _buildPopupMenuItem(
      BuildContext context, String title, IconData iconData, String value) {
    return PopupMenuItem(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      value: value,
      height: 30,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 12,),
          Icon(iconData, color: theme(context).colorScheme.onBackground, size: 16,),
          // const SizedBox(width: 15,),
          const SizedBox(width: 8,),
          Text(title, style: TextStyle(color: theme(context).colorScheme.onBackground, fontSize: defaultFontSize - 1),),
          const SizedBox(width: 8,),
        ],
      ),
    );
  }

}
