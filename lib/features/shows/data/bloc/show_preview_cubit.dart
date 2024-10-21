
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/analytics/data/service/analytics_service.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_state.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_enums.dart';
import 'package:showwcase_v3/features/shows/data/models/show_broadcast_event.dart';
import 'package:showwcase_v3/features/shows/data/models/show_comment_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/shows/data/repositories/shows_broadcast_repository.dart';
import 'package:showwcase_v3/features/shows/data/repositories/shows_repository.dart';

class ShowPreviewCubit extends Cubit<ShowPreviewState> {

  final ShowsRepository showsRepository;
  final ShowsBroadcastRepository showsBroadcastRepository;
  StreamSubscription<ShowBroadcastEvent>? showBroadcastRepositoryStreamListener;
  ShowPreviewCubit({required this.showsRepository, required this.showsBroadcastRepository}): super(const ShowPreviewState()){
    _listenToShowBroadCastStreams();
  }

  // listen to updated thread streams and update thread states accordingly
  void _listenToShowBroadCastStreams() async {

    await showBroadcastRepositoryStreamListener?.cancel();
    showBroadcastRepositoryStreamListener = showsBroadcastRepository.stream.listen((showBroadcastEvent) {

      /// show updated
      if(showBroadcastEvent.action == ShowBroadcastAction.updateShow) {

        final updatedShow = showBroadcastEvent.show!;

        // find the show whose values are updated
        final showPreviews = [...state.showPreviews];
        final showIndex = showPreviews.indexWhere((element) => element.id == updatedShow.id);

        // we can't continue if thread wasn't found
        // For some subclasses of threadCubit, this thread will not be found
        if(showIndex > -1){
          final updatedShowsList = showPreviews;
          updatedShowsList[showIndex] = updatedShow;

          emit(state.copyWith(status: ShowsStatus.updateShowInProgress));
          // if Show was found in this cubit then update, and notify all listening UIs
          emit(state.copyWith(
            showPreviews: updatedShowsList,
            status: ShowsStatus.updateShowCompleted,
          ));
        }

        // check if the updated show is in recommended shows
        final recommendedShowsMap = {...state.recommendedShows};
        recommendedShowsMap.forEach((key, List<ShowModel> recommendedShows) {

          final showIndex = recommendedShows.indexWhere((element) => element.id == updatedShow.id);
          if(showIndex > -1){
            // final showFound = recommendedShows[showIndex];
            recommendedShows[showIndex] = updatedShow;
            recommendedShowsMap[key] = recommendedShows;
          }

        });

        emit(state.copyWith(status: ShowsStatus.updateShowInProgress));
        emit(state.copyWith(
          recommendedShows: recommendedShowsMap,
          status: ShowsStatus.updateShowCompleted,
        ));


      }

      /// Comment updated
      if(showBroadcastEvent.action == ShowBroadcastAction.updateComment) {

        final comment  = showBroadcastEvent.comment!;
        if(comment.projectId == null){return;}

        final showCommentsMap = {...state.comments};
        final comments = showCommentsMap[comment.projectId]!;
        final commentIndex = comments.indexWhere((element) => element.id == comment.id);
        if(commentIndex > -1) {

          comments[commentIndex] = comment;
          showCommentsMap[comment.projectId!] = comments;
          emit(state.copyWith(status: ShowsStatus.updateShowCommentsInProgress));
          emit(state.copyWith(
              status: ShowsStatus.updateShowCommentsCompleted,
              comments: showCommentsMap
          ));

        }else{
          // this is comment is a reply, add it under the parent comment
          final replyParentIndex = comments.indexWhere((element) => element.id == comment.parentId);
          if(replyParentIndex > -1) {
            final parentComment = comments[replyParentIndex];
            final parentCommentReplies = parentComment.replies ?? <ShowCommentModel>[];

            final replyIndex = parentCommentReplies.indexWhere((element) => element.id == comment.id);
            if(replyIndex > -1) {

              parentCommentReplies[replyIndex] = comment;
              final updatedComment = parentComment.copyWith(
                replies: parentCommentReplies
              );
              comments[replyParentIndex] = updatedComment;

              showCommentsMap[comment.projectId!] = comments;
              emit(state.copyWith(status: ShowsStatus.refreshShowCommentsInProgress));
              emit(state.copyWith(
                  status: ShowsStatus.refreshShowCommentsCompleted,
                  comments: showCommentsMap
              ));
            }
            // parentCommentReplies.insert(0,comment);
            // final updatedParentComment = parentComment.copyWith(
            //     replies: parentCommentReplies,
            //     totalReplies: (parentComment.totalReplies ?? 0) + 1
            // );

          }
        }

      }

      /// Show Comment Created
      if(showBroadcastEvent.action == ShowBroadcastAction.createComment){

        final comment  = showBroadcastEvent.comment!;
        if(comment.projectId == null){
          return;
        }

        final showCommentsMap = {...state.comments};
        final comments = showCommentsMap[comment.projectId] ?? <ShowCommentModel>[];


        // if its not a reply create new comment as parent
        if(comment.parentId == null){

          comments.add(comment);
          showCommentsMap[comment.projectId!] = comments;
          emit(state.copyWith(status: ShowsStatus.refreshShowCommentsInProgress));
          emit(state.copyWith(
              status: ShowsStatus.refreshShowCommentsCompleted,
              comments: showCommentsMap,
          ));

         } else {

          // this is comment is a reply, add it under the parent comment
          final replyParentIndex = comments.indexWhere((element) => element.id == comment.parentId);
          if(replyParentIndex > -1) {
            final parentComment = comments[replyParentIndex];
            final parentCommentReplies = parentComment.replies ?? <ShowCommentModel>[];
            parentCommentReplies.insert(0,comment);
            final updatedParentComment = parentComment.copyWith(
              replies: parentCommentReplies,
              totalReplies: (parentComment.totalReplies ?? 0) + 1
            );
            comments[replyParentIndex] = updatedParentComment;

            showCommentsMap[comment.projectId!] = comments;
            emit(state.copyWith(status: ShowsStatus.refreshShowCommentsInProgress));
            emit(state.copyWith(
                status: ShowsStatus.refreshShowCommentsCompleted,
                comments: showCommentsMap
            ));
          }

        }


      }

      if(showBroadcastEvent.action == ShowBroadcastAction.deleteComment) {

        final comment  = showBroadcastEvent.comment!;
        if(comment.projectId == null){return;}

        final showCommentsMap = {...state.comments};
        final comments = showCommentsMap[comment.projectId]!;

        final commentIndex = comments.indexWhere((element) => element.id == comment.id);
        if(commentIndex > -1) {

          comments.removeAt(commentIndex);
          showCommentsMap[comment.projectId!] = comments;
          emit(state.copyWith(status: ShowsStatus.refreshShowCommentsInProgress));
          emit(state.copyWith(
              status: ShowsStatus.refreshShowCommentsCompleted,
              comments: showCommentsMap
          ));

        }else {
          // if comment wasn't found then this comment could be a reply
          final replyParentIndex = comments.indexWhere((element) => element.id == comment.parentId);
          if(replyParentIndex > -1) {
            final parentComment = comments[replyParentIndex];
            final parentCommentReplies = parentComment.replies ??
                <ShowCommentModel>[];
            final replyIndex = parentCommentReplies.indexWhere((
                element) => element.id == comment.id);
            if (replyIndex > -1) {
              parentCommentReplies.removeAt(replyIndex);
              final updatedParentComment = parentComment.copyWith(
                  replies: parentCommentReplies,
                  totalReplies: (parentComment.totalReplies ?? 1) - 1
              );
              comments[replyParentIndex] = updatedParentComment;

              showCommentsMap[comment.projectId!] = comments;
              emit(state.copyWith(status: ShowsStatus.refreshShowCommentsInProgress));
              emit(state.copyWith(status: ShowsStatus.refreshShowCommentsCompleted,
                  comments: showCommentsMap
              ));
            }
          }

        }

      }

    });
  }

  ShowModel setShowPreview({required ShowModel show, bool updateIfExist = true}){
    // updateIfExist, mean if Show Already Exists should it be updated
    // updateIfExist is usually true after we fetch the full show from the server

    /// This method here adds the a given show to the shows of interest
    /// Once a show is previewed it becomes a show of interest

    emit(state.copyWith(status: ShowsStatus.setShowPreviewInProgress,));
    final showPreviews = [...state.showPreviews];
    final int index = showPreviews.indexWhere((element) => element.id == show.id);
    if(index < 0){

      showPreviews.add(show);

    }else {

      // showPreview has already been added
      // so update it.
      if(updateIfExist) {

        showPreviews[index] = show;
      }

    }

    emit(state.copyWith(
        status: ShowsStatus.setShowPreviewCompleted,
        showPreviews: showPreviews
    ));

    // return the threadPreview for methods that needs it
    final showPreview = state.showPreviews.firstWhere((element) => element.id == show.id);
    return showPreview;

  }

  /// Fetch all show preview components --------
  Future<Either<String, ShowModel>> fetchShowsPreview({required int showId}) async {

    try {

      emit(state.copyWith(status: ShowsStatus.fetchShowsPreviewInProgress,));

      final either = await showsRepository.fetchShowPreview(showId: showId);

      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: ShowsStatus.fetchShowsPreviewFailed, message: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful

      final r = either.asRight();
      final showPreviews = [...state.showPreviews];
      final int index = showPreviews.indexWhere((element) => element.id == r.id);
      final existingShow = showPreviews[index];

      //as at 11/08/2023 the api does not return any info about hasBookmarked and hasVoted in fetching showPreview
      // so we default to the value in state
      final showPreview = r.copyWith(
          hasBookmarked: existingShow.hasBookmarked ?? r.hasBookmarked,
          hasVoted: existingShow.hasVoted ?? r.hasVoted
      );
      setShowPreview(show: showPreview, updateIfExist: true);

      emit(state.copyWith(status: ShowsStatus.fetchShowsPreviewSuccessful,));

      return Right(showPreview);

    } catch (e) {
      emit(state.copyWith(message: e.toString(), status: ShowsStatus.fetchShowsPreviewFailed));
      return Left(e.toString());
    }
  }


  Future<Either<String, List<ShowModel>>> fetchRecommendedShows({required int pageKey,  required int currentProjectId}) async {

    try{

      final recommendedShows = {...state.recommendedShows};
      final List<ShowModel> shows = recommendedShows[currentProjectId] ?? <ShowModel>[];

      emit(state.copyWith(status: ShowsStatus.fetchRecommendedShowsInProgress));

      final skip = pageKey  > 0 ?  shows.length : pageKey;  //
      final path = ApiConfig.fetchShows(skip: skip, limit: defaultPageSize, currentProjectId: currentProjectId);
      final either = await showsRepository.fetchShows(path: path);
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: ShowsStatus.fetchShowsFailed, message: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful
      List<ShowModel> r = either.asRight();
      if(pageKey == 0){
        // if its first page request remove all existing shows
        shows.clear();
      }

      shows.addAll(r);
      recommendedShows[currentProjectId] = shows;

      emit(state.copyWith(
        status: ShowsStatus.fetchRecommendedShowsSuccessful,
        recommendedShows: recommendedShows,
      ));

      return Right(r);

    }catch(e){
      debugPrint("customLog: $e");
      emit(state.copyWith(status: ShowsStatus.fetchRecommendedShowsFailed, message: e.toString()));
      return Left(e.toString());
    }

  }


  Future<void> createShowComment({required String message, required ShowModel show, ShowCommentModel? parentComment}) async {

    try{

      emit(state.copyWith(status: ShowsStatus.createShowCommentInProgress));

      final either = await showsRepository.createShowComment(message: message, projectId: show.id!, parentId: parentComment?.id);

      if(either.isLeft()) {
        final l = either.asLeft();
        emit(state.copyWith(status: ShowsStatus.createShowCommentFailed, message: l.errorDescription));
        return;
      }

      // successful
      final r = either.asRight();
      // inform other cubits to add comment
      showsBroadcastRepository.addComment(comment: r.copyWith(parentId: parentComment?.id));
      if(parentComment == null){
        final updatedShow = show.copyWith(
            totalComments: (show.totalComments ?? 0) + 1
        );
        showsBroadcastRepository.updateShow(updatedShow: updatedShow);
      }

      emit(state.copyWith(status: ShowsStatus.createShowCommentSuccessful));
      AnalyticsService.instance.sendEventShowComments(showModel: show,showCommentModel: parentComment!,);


    } catch (e) {
      emit(state.copyWith(status: ShowsStatus.createShowCommentFailed, message: e.toString()));
    }
  }

  void upvoteComment({required ShowModel show, required ShowCommentModel comment, required String actionType, ShowCommentModel? parentComment}) async {

    /// action types are upvote, unvote
    bool voted = actionType == "upvote";

    // optimistic update
    void update() {

      final updatedComment = comment.copyWith(hasVoted: voted,
          totalUpvotes: voted ? (comment.totalUpvotes ?? 0 ) + 1 : (comment.totalUpvotes ?? 1 ) - 1,
          projectId: show.id,
          parentId: parentComment?.id
      );
      showsBroadcastRepository.updateComment(comment: updatedComment);

    }

    // reverse update
    void reverse() {
      // reverse to the previous hasVoted value
      final updatedComment = comment.copyWith(hasVoted: show.hasVoted, totalUpvotes: (comment.totalUpvotes ?? 1 ) - 1);
      showsBroadcastRepository.updateComment(comment: updatedComment);
    }

    try {

      // initial update
      update();

      final either = await showsRepository.upvoteComment(commentId: comment.id!, actionType: actionType);
      either.fold(
              (l) => reverse(), // reverse if there's any error
              (r) => null
      );

    } catch (e) {
      debugPrint(e.toString());
      reverse(); // reverse optimistic update if a server error occurred
    }
  }

  Future<Either<String, List<ShowCommentModel>>> fetchShowComments({required int pageKey, required int projectId}) async {

    try{

      emit(state.copyWith(status: ShowsStatus.fetchShowCommentsInProgress));

      // final skip = pageKey  > 0 ?  state.threadPreviews.length : pageKey;  //
      final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey; // even if previous page returned items less than defaultPageSize, still skip by defaultPageSize
      final either = await showsRepository.fetchShowComments(showId: projectId, limit: defaultPageSize, skip: skip);

      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: ShowsStatus.fetchShowCommentsFailed, message: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful
      List<ShowCommentModel> r = either.asRight();
      final showCommentsMap = {...state.comments};
      final comments =  showCommentsMap.containsKey(projectId) ? showCommentsMap[projectId]! : <ShowCommentModel>[];

      if(pageKey == 0){
        // if its first page request remove all existing shows
        comments.clear();
      }

      // we add up to the thread replies here
      comments.addAll(r);

      showCommentsMap[projectId] = comments;

      emit(state.copyWith(status: ShowsStatus.fetchShowCommentsSuccessful,
        comments: showCommentsMap,
      ));

      return Right(r);


    }catch(e){
      debugPrint("customLog: $e");
      emit(state.copyWith(status:  ShowsStatus.fetchShowCommentsFailed, message: e.toString()));
      return Left(e.toString());
    }

  }

  Future<String?> deleteComment({required ShowModel show, required ShowCommentModel comment, ShowCommentModel? parentComment}) async {

    try {

      emit(state.copyWith(status: ShowsStatus.deleteCommentInProgress,));

      final either = await showsRepository.deleteShowComment(commentId: comment.id!);

      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: ShowsStatus.deleteCommentFailed,));
        return l.errorDescription;
      }

      // successful
      // final r = either.asRight();
      showsBroadcastRepository.removeComment(comment: comment.copyWith(
        projectId: show.id,
        parentId: parentComment?.id
      ));
      if(parentComment == null){
        final updatedShow = show.copyWith(
            totalComments: (show.totalComments ?? 1) - 1
        );
        showsBroadcastRepository.updateShow(updatedShow: updatedShow);
      }

      emit(state.copyWith(status: ShowsStatus.deleteCommentSuccessful,));
      return null;

    }catch(e) {
      emit(state.copyWith(status: ShowsStatus.deleteCommentFailed,));
      return e.toString();
    }

  }


  Future<String?> updateComment({required ShowModel show, required ShowCommentModel comment, ShowCommentModel? parentComment}) async {

    try {

      emit(state.copyWith(status: ShowsStatus.updateCommentInProgress,));

      final either = await showsRepository.updateShowComment(updatedComment: comment);

      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: ShowsStatus.updateCommentFailed,));
        return l.errorDescription;
      }

      // successful
      // final r = either.asRight();
      showsBroadcastRepository.updateComment(comment: comment.copyWith(
        projectId: show.id,
        parentId: parentComment?.id
      ));
      emit(state.copyWith(status: ShowsStatus.updateCommentSuccessful,));
      return null;

    }catch(e) {
      emit(state.copyWith(status: ShowsStatus.updateCommentFailed,));
      return e.toString();
    }

  }

}