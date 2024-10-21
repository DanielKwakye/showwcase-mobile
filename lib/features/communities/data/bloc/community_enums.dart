enum CommunityStatus {
  initial,
  fetchSuggestedCommunitiesInProgress, fetchSuggestedCommunitiesFailed, fetchSuggestedCommunitiesSuccessful,
  joinLeaveCommunityInProgress, joinLeaveCommunityFailed, joinLeaveCommunitySuccessful,
  featureUnfeatureCommunityInProgress, featureUnfeatureCommunityFailed, featureUnfeatureCommunitySuccessful,
  addCommunityToCommunitiesOfInterestInProgress, addCommunityToCommunitiesOfInterestCompleted,
  userCommunitiesLoading, userCommunitiesError, userCommunitiesSuccess, resetCommunityStateCompleted, resetCommunityStateInProgress,
  searchCommunitiesInProgress, searchCommunitiesFailed, searchCommunitiesSuccessful,
  fetchCommunityTagsInProgress, fetchCommunityTagsFailed, fetchCommunityTagsSuccessful,
  fetchCommunityMembersInProgress, fetchCommunityMembersFailed, fetchCommunityMembersSuccessful,
  fetchCommunityDetailsInProgress, fetchCommunityDetailsFailed, fetchCommunityDetailsSuccessful,
  selectCommunityThreadTagCompleted,selectCommunityThreadTagInProgress ,
  fetchActiveCommunitiesInProgress, fetchActiveCommunitiesFailed, fetchActiveCommunitiesSuccessful,
  fetchGrowingCommunitiesInProgress, fetchGrowingCommunitiesFailed, fetchGrowingCommunitiesSuccessful,
  fetchProposedCommunitiesInProgress, fetchProposedCommunitiesFailed, fetchProposedCommunitiesSuccessful, fetchCommunitiesInProgress, fetchCommunitiesFailed, fetchCommunitiesSuccessful, setCommunityPreviewCompleted, setCommunityPreviewInProgress, updateCommunityInProgress, updateCommunityCompleted,

}

enum CommunityJoinLeaveAction {
  join, leave
}
enum FeatureUnfeatureCommunityAction {
  feature, unfeature
}
enum ChipPosition { above, below }

String getStringForEnum(CommunityUpdateType enumValue) {
  switch (enumValue) {
    case CommunityUpdateType.category:
      return 'Category';
    case CommunityUpdateType.communityName:
      return 'Community Name';
    case CommunityUpdateType.description:
      return 'Community Description';
    case CommunityUpdateType.dateCreated:
      return '';
    case CommunityUpdateType.about:
      return 'Community About';
    case CommunityUpdateType.social:
      return '';
    case CommunityUpdateType.communityTags:
      return 'Tags';
    case CommunityUpdateType.interests:
      return 'Community Interests';
    default:
      return '';
  }
}


enum CommunityUpdateType {
  category,
  communityName,
  description,
  dateCreated,
  about,
  social,
  communityTags,
  interests,
}

enum CommunityBroadcastAction {
  updateCommunity
}