import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/analytics/data/service/analytics_service.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_enums.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_state.dart';
import 'package:showwcase_v3/features/shows/data/models/show_broadcast_event.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/shows/data/repositories/shows_broadcast_repository.dart';
import 'package:showwcase_v3/features/shows/data/repositories/shows_repository.dart';

class ShowsCubit extends Cubit<ShowsState> {

  final ShowsRepository showsRepository;
  final ShowsBroadcastRepository showsBroadcastRepository;
  StreamSubscription<ShowBroadcastEvent>? showBroadcastRepositoryStreamListener;
  ShowsCubit({required this.showsRepository, required this.showsBroadcastRepository}): super(const ShowsState()){
    _listenToShowBroadCastStreams();
  }

  // listen to updated show streams and update thread states accordingly
  void _listenToShowBroadCastStreams() async {
    await showBroadcastRepositoryStreamListener?.cancel();
    showBroadcastRepositoryStreamListener = showsBroadcastRepository.stream.listen((showBroadcastEvent) {

      if(showBroadcastEvent.action == ShowBroadcastAction.updateShow) {

        final updatedShow = showBroadcastEvent.show!;

        emit(state.copyWith(status: ShowsStatus.updateShowInProgress));
        // find the thread whose values are updated
        final showIndex = state.shows.indexWhere((element) => element.id == updatedShow.id);

        // we can't continue if thread wasn't found
        // For some subclasses of threadCubit, this thread will not be found
        if(showIndex < 0){return;}

        final updatedShowsList = [...state.shows];
        updatedShowsList[showIndex] = updatedShow;

        // if thread was found in this cubit then update, and notify all listening UIs
        emit(state.copyWith(
            shows: updatedShowsList,
            status: ShowsStatus.updateShowCompleted,
            data: updatedShow
        ));
      }

    });
  }

  // Close stream subscriptions when cubit is disposed to avoid any memory leaks
  @override
  Future<void> close() async {
    await showBroadcastRepositoryStreamListener?.cancel();
    return super.close();
  }


  // This is stateless, (Does not keep the data in state) and just returns the data to the caller
  Future<ShowModel?> getShowFromId({required int showId}) async {

    try {

      final either = await showsRepository.getShowFromId(showId: showId);
      if(either.isLeft()){
        final l = either.asLeft();
        return null;
      }

      // successful

      final r = either.asRight();
      return r;

    } catch (e) {
      return null;
    }
  }

  /// Fetch shows from the server by Path

  Future<Either<String, List<ShowModel>>> fetchShows({required int pageKey, required String path, Map<String, dynamic> queryParams = const {}}) async {

    try{

      emit(state.copyWith(status: ShowsStatus.fetchShowsInProgress));

      final either = await showsRepository.fetchShows(path: path, queryParams: queryParams);
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: ShowsStatus.fetchShowsFailed, message: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful
      List<ShowModel> r = either.asRight();
      final List<ShowModel> shows = [...state.shows];
      if(pageKey == 0){
        // if its first page request remove all existing shows
        shows.clear();
      }

      shows.addAll(r);

      emit(state.copyWith(
        status: ShowsStatus.fetchShowsSuccessful,
        shows: shows,
      ));

      return Right(r);

    }catch(e){
      debugPrint("customLog: $e");
      emit(state.copyWith(status: ShowsStatus.fetchShowsFailed, message: e.toString()));
      return Left(e.toString());
    }

  }


  // This is stateless. It just fetches the show returns to the caller without keeping show In state
  Future<ShowModel?> fetchShowById({required int showId}) async {
    try{

      final either = await showsRepository.fetchShowPreview(showId: showId);
      if(either.isLeft()){
        return null;
      }
      // successful
      return either.asRight();
    }catch(e){
      return null;
    }
  }

  void reportShow({required String message, required int projectId}) async {

    try{

      emit(state.copyWith(status: ShowsStatus.reportShowInProgress));

      final either = await showsRepository.reportShow(message: message, projectId: projectId);

      either.fold(
              (l) {
                emit(state.copyWith(status: ShowsStatus.reportShowFailed, message: l.errorDescription));
          },
              (r) {

            emit(state.copyWith(status: ShowsStatus.reportShowSuccessful,
                message: "Thanks for the feedback. The reported show is now under investigation"
            ));
          }

      );
    }catch(e){
      emit(state.copyWith(status: ShowsStatus.reportShowFailed, message:e.toString()));
    }
  }


  void bookmarkShow({required ShowModel show, required bool isBookmark}) async {

    // thread id cannot be null
    if(show.id == null){
      return;
    }

    update() {
      /// The mechanism here is to broadcast the updated Show to the app so that
      /// any subClassed cubit having this show updates accordingly
      final updatedShow = show.copyWith(
          hasBookmarked: isBookmark
      );
      showsBroadcastRepository.updateShow(updatedShow: updatedShow);
    }

    reverse(String reason) {
      /// The mechanism here is to broadcast the updated Thread to the app so that
      /// any subClassed cubit having this show updates accordingly
      final updatedShow = show.copyWith(
          hasBookmarked: show.hasBookmarked
      );
      showsBroadcastRepository.updateShow(updatedShow: updatedShow);
    }

    // optimistic update
    update();

    try{

      final either = await showsRepository.bookmarkShow(showId: show.id!, isBookmark: isBookmark);
      either.fold((l) => reverse(l.errorDescription),
              (r) {
            // we do nothing again when its successful, cus we've already called the update() functionality
          }
      );
    }catch(e){
      reverse(e.toString());
    }


  }


  void upvoteShow({required ShowModel show, required bool isUpvote}) async {

    // thread id cannot be null
    if(show.id == null){
      return;
    }

    update() {
      /// The mechanism here is to broadcast the updated Show to the app so that
      /// any subClassed cubit having this show updates accordingly
      final updatedShow = show.copyWith(
          hasVoted: isUpvote,
          totalUpvotes: isUpvote == true ? ((show.totalUpvotes ?? 0) + 1) :  ((show.totalUpvotes ?? 1) - 1)
      );
      showsBroadcastRepository.updateShow(updatedShow: updatedShow);
    }

    reverse(String reason) {
      /// The mechanism here is to broadcast the updated Thread to the app so that
      /// any subClassed cubit having this show updates accordingly
      final updatedShow = show.copyWith(
          hasVoted: show.hasVoted
      );
      showsBroadcastRepository.updateShow(updatedShow: updatedShow);
    }

    // optimistic update
    update();

    try{

      final either = await showsRepository.upvoteShow(showId: show.id!, actionType: isUpvote ? "upvote" : "unvote");
      either.fold((l) => reverse(l.errorDescription),
              (r) {
                AnalyticsService.instance.sendEventShowLike(showModel: show,);
            // we do nothing again when its successful, cus we've already called the update() functionality
          }
      );
    }catch(e){
      reverse(e.toString());
    }


  }


}