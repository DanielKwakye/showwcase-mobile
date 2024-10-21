enum ThreadStatus {
  initial,
  fetchThreadsInProgress, fetchThreadsFailed, fetchThreadsSuccessful,
  fetchThreadPollVotersInProgress, fetchThreadPollVotersFailed, fetchThreadPollVotersSuccessful,
  updateThreadsInProgress, updateThreadsCompleted, fetchThreadRepliesInProgress, fetchThreadRepliesSuccessful, fetchThreadRepliesFailed, setThreadPreviewInProgress, setThreadPreviewCompleted, removeThreadPreviewInProgress, removeThreadPreviewCompleted,
  updateThreadPreviewRepliesInProgress, updateThreadPreviewRepliesSuccessful,
  updateThreadPreviewCommentsInProgress, updateThreadPreviewCommentsSuccessful,
  reportThreadInProgress, reportThreadSuccessful, reportThreadFailed, deleteThreadInProgress, deleteThreadFailed, deleteThreadSuccessful,
  refreshThreadInProgress, refreshThreadsCompleted, fetchThreadUpVotersInProgress, fetchThreadUpVotersSuccessful, fetchThreadUpVotersFailed,
  createOrReplyThreadInProgress, createOrReplyThreadFailed, createOrReplyThreadSuccessful,
   processThreadSubmissionRequesting, processThreadSubmissionRequested, editThreadInProgress, editThreadFailed, editThreadSuccessful, deleteThreadPreviewInProgress, deleteThreadPreviewSuccessful,
  refreshThreadPreviewCommentsInProgress, refreshThreadPreviewCommentsCompleted,
  refreshThreadPreviewCommentRepliesInProgress, refreshThreadPreviewCommentRepliesCompleted,
  fetchThreadCommentRepliesInProgress
}

enum ThreadFeedActionType {
  upvote, boost, comment, bookmark, share
}

enum UpvoteActionType {
  /// action types are upvote, unvote
  upvote, unvote
}

enum BoostActionType {
  boost, unboost
}

enum ThreadComponents {
  title, message, images, code, poll, gif, video
}

enum ThreadBroadcastAction {
  create, update, delete, reply
}