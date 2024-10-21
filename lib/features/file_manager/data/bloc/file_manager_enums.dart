enum FileManagerStatus {
  initial, uploadImageInProgress, uploadImageFailed, uploadImageSuccessful, setFileItemInProgress, setFileItemCompleted,
  fetchVideoFromMediaIdInProgress, fetchVideoFromMediaIdFailed, fetchVideoFromMediaIdSuccessful,
  fetchTrendingGifsInProgress, fetchTrendingGifsFailed, fetchTrendingGifsSuccessful, searchGifsInProgress, searchGifsFailed, searchGifsSuccessful, uploadVideoInProgress, uploadVideoSuccessful, uploadVideoFailed,
  clearFilesGroupInProgress, clearFilesGroupCompleted, clearFileItemInProgress, clearFileItemCompleted
}

enum FileItemStatus {
  inProgress, failed, successful
}

enum VideoSrcStatus {
  ready, loading, error
}