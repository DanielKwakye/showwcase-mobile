enum CircleStatus {
  initial, fetchCollaboratorsInProgress, fetchCollaboratorsFailed, fetchCollaboratorsSuccessful,
  fetchFollowersInProgress, fetchFollowersFailed, fetchFollowersSuccessful,
  fetchFollowingFailed, fetchFollowingSuccessful, fetchFollowingInProgress,
  updateUserInProgress, updateUserCompleted,
  handleCircleInviteInProgress, handleCircleInviteCompleted,handleCircleInviteFailed,
  sendCircleInviteInProgress, sendCircleInviteCompleted, sendCircleInviteFailed,
  fetchCircleReasonsInProgress, fetchCircleReasonsCompleted, fetchCircleReasonsFailed,

}

enum CirclesBroadcastAction {
  circleRequestAccepted, circleRequestRejected
}