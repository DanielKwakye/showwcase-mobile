import 'package:json_annotation/json_annotation.dart';

enum NotificationCategory { all, mentions, requests, community }

enum NotificationStatus {
  initial, markNotificationAsReadInProgress, markNotificationAsReadFailed, markNotificationAsReadSuccessful, fetchNotificationsInProgress, fetchNotificationsFailed, fetchNotificationsSuccessful,
  fetchingNotificationTotal, fetchingNotificationTotalSuccessful, fetchingNotificationTotalError,
}

/// The convection here is, the variable should always be the camelCase version of the @JasonValue (snake_case).
/// eg. new_thread_upvote -> newThreadUpvote (correct)
/// eg. new_thread_upvote -> newThreadUpVote (wrong) : because  newThreadUpVote (camel case) converts to new_thread_up_vote not (new_thread_upvote)
enum NotificationTypes {
  @JsonValue("new_reply") newReply,
  @JsonValue("new_thread_upvote") newThreadUpvote,
  @JsonValue("thread_boost") threadBoost,
  @JsonValue("thread_mention") threadMention,
  @JsonValue("new_follower") newFollower,
  @JsonValue("new_workedwith_invite") newWorkedwithInvite,
  @JsonValue("new_project_workedwith_invite") newProjectWorkedwithInvite,
  @JsonValue("new_comment") newComment,
  @JsonValue("initial_post") initialPost,
  @JsonValue("new_community_member") newCommunityMember,
  @JsonValue("new_poll_vote") newPollVote,
  @JsonValue("community_invite") communityInvite,
  @JsonValue("community_role_changed") communityRoleChanged,
  @JsonValue("new_comment_upvote") newCommentUpvote,
  @JsonValue("new_project_upvote") newProjectUpvote,
  @JsonValue("edit_guestbook_entry") editGuestbookEntry,
  @JsonValue("new_guestbook_entry") newGuestbookEntry,
  @JsonValue("community_ownership_transfer") communityOwnershipTransfer,
}