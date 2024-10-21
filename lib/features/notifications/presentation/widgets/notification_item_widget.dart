import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_enums.dart';
import 'package:showwcase_v3/features/notifications/data/models/notification_model.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_community_ownership_transfer.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_edit_guestbook.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_initial_post_widget.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_new_community_invite.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_new_community_member.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_new_follower_widget.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_new_guestbook.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_new_mention.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_new_poll_vote_widget.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_new_project_comment_upvote.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_new_project_invite.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_new_project_upvote.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_new_thread_boost_widget.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_new_thread_reply.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_new_thread_vote_widget.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_new_worked_with_invite.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_role_changed.dart';

class NotificationItemWidget extends StatelessWidget {

  final NotificationModel notificationResponse;

  const NotificationItemWidget({
    Key? key, required this.notificationResponse
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch(notificationResponse.type) {
      case NotificationTypes.newThreadUpvote:
        return NotificationNewThreadVoteWidget(notificationResponse: notificationResponse);
      case NotificationTypes.newReply:
        return NotificationNewThreadReplyWidget(notificationResponse: notificationResponse);
      case NotificationTypes.threadMention:
        return NotificationNewMentionWidget(notificationResponse: notificationResponse);
      case NotificationTypes.threadBoost:
        return NotificationNewThreadBoostWidget(notificationResponse: notificationResponse);
      case NotificationTypes.newProjectWorkedwithInvite:
        return NotificationNewProjectInviteWidget(notificationResponse: notificationResponse);
      case NotificationTypes.newFollower:
        return NotificationNewFollowerWidget(notificationResponse: notificationResponse);
      case NotificationTypes.initialPost:
        return NotificationInitialPostWidget(notificationResponse: notificationResponse);
      case NotificationTypes.newWorkedwithInvite:
        return NotificationNewWorkedWithInvite(notificationResponse: notificationResponse,);
      case NotificationTypes.newCommunityMember:
        return NotificationNewCommunityMemberWidget(notificationResponse: notificationResponse,);
      case NotificationTypes.newPollVote:
        return NotificationNewPollVoteWidget(notificationResponse: notificationResponse,);
        case NotificationTypes.communityInvite:
        return NotificationNewCommunityInviteWidget(notificationResponse: notificationResponse,);
        case NotificationTypes.communityRoleChanged:
        return NotificationCommunityRoleChanged(notificationResponse: notificationResponse,);
        case NotificationTypes.editGuestbookEntry:
        return NotificationEditGuestbook(notificationResponse: notificationResponse,);
        case NotificationTypes.newGuestbookEntry:
        return NotificationNewGuestbook(notificationResponse: notificationResponse,);
        case NotificationTypes.newCommentUpvote:
        return NotificationNewProjectCommentUpvote(notificationResponse: notificationResponse,);
        case NotificationTypes.communityOwnershipTransfer:
        return NotificationCommunityOwnershipTransfer(notificationResponse: notificationResponse,);
        case NotificationTypes.newProjectUpvote:
        return NotificationNewProjectUpvote(notificationResponse: notificationResponse,);
      default:
        return const SizedBox.shrink();
    }
  }

}
