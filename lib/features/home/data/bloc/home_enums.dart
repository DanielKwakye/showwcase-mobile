enum HomeStatus {
  initial, onOpenDrawerRequestInProgress, onOpenDrawerRequestCompleted,
  onActiveIndexTappedInProgress, onActiveIndexTappedCompleted, onPageScrollInProgress, onPageScrollCompleted, onCloseDrawerRequestInProgress, onCloseDrawerRequestCompleted,
  enablePageLoadInProgress, enablePageLoad,
  dismissPageLoadInProgress,dismissPageLoad, redirectLinkToPageInProgress, redirectLinkToPageRequested, requestSystemOverlayUpdateInProgress, requestSystemOverlayUpdateCompleted;

}

enum PageScrollDirection {
  down, up
}