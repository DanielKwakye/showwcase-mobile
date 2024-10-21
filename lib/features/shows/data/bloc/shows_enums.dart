enum ShowsStatus {
  initial,
  fetchShowCategoriesInProgress, fetchShowCategoriesFailed, fetchShowCategoriesSuccessful, fetchShowsInProgress, fetchShowsFailed, fetchShowsSuccessful, selectShowFeedCategoryInProgress, selectShowFeedCategoryCompleted, reportShowInProgress, reportShowFailed, reportShowSuccessful, updateShowCompleted, updateShowInProgress, setShowPreviewInProgress, setShowPreviewCompleted, fetchShowsPreviewInProgress, fetchShowsPreviewFailed, fetchShowsPreviewSuccessful, fetchRecommendedShowsFailed, fetchRecommendedShowsSuccessful, fetchRecommendedShowsInProgress,
  fetchShowUpVotersInProgress, fetchShowUpVotersFailed, fetchShowUpVotersSuccessful, createShowCommentInProgress, createShowCommentFailed, createShowCommentSuccessful, refreshShowCommentsInProgress, refreshShowCommentsCompleted, fetchShowCommentsInProgress, fetchShowCommentsFailed, fetchShowCommentsSuccessful, deleteShowCommentSuccessful, updateShowCommentsInProgress, updateShowCommentsCompleted, deleteCommentInProgress, deleteCommentFailed, deleteCommentSuccessful, updateCommentFailed, updateCommentSuccessful, updateCommentInProgress
}

enum UpvoteActionType {
  /// action types are upvote, unvote
  upvote, unvote
}

enum ShowActionType {
  upvote, comment, bookmark
}

enum ShowBroadcastAction {
  createComment, updateShow, deleteComment, updateComment
}