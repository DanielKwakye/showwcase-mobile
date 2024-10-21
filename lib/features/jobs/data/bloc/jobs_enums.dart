enum JobStatus{
  initial, jobsFilterToggled,
  jobsFetching,
  jobsFetchedSuccessful,
  jobsFetchError,
  jobsFetchUpdatingFilters,
  jobsFiltersFetching,
  jobsFiltersFetchedSuccessful,
  jobsFiltersFetchError,
  jobsPreviewFetching,
  jobsPreviewFetchingError,
  jobsPreviewFetchingSuccessful,
  togglingJobsFilter,
  companiesFetching,
  companiesFetchedSuccessful,
  companiesFetchError,
  companiesJobsFetching,
  companiesJobsFetchedSuccessful,
  companiesJobsFetchError,

  recommendedJobsFetching,
  recommendedJobsFetchingSuccessful,
  recommendedJobsFetchingError,

  popularJobsFetching,
  popularJobsFetchingSuccessful,
  popularJobsFetchingError, fetchJobsInProgress, fetchJobsFailed, fetchJobsSuccessful, setJobPreviewInProgress, setJobPreviewCompleted, updateJobInProgress, updateJobCompleted, refreshBookmarksInProgress, refreshBookmarks,
}

enum JobCategory {recommended, popular, newArrivals}

enum JobFeedActionType {bookmark, unBookmark}

enum JobBroadcastAction {update}