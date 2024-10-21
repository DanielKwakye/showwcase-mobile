import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_enums.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_preview_state.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_broadcast_event.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/data/repositories/thread_broadcast_repository.dart';

import '../repositories/thread_repository.dart';

class ThreadPreviewCubit extends Cubit<ThreadPreviewState> {

  final ThreadRepository threadRepository;
  final ThreadBroadcastRepository threadBroadcastRepository;
  StreamSubscription<ThreadBroadcastEvent>? threadBroadcastRepositoryStreamListener;
  ThreadPreviewCubit(this.threadRepository, {required this.threadBroadcastRepository}): super(const ThreadPreviewState()) {
    _listenToThreadBroadCastStreams();
  }


  void _listenToThreadBroadCastStreams() async {
    await threadBroadcastRepositoryStreamListener?.cancel();
    threadBroadcastRepositoryStreamListener = threadBroadcastRepository.stream.listen((threadBroadcastEvent) {

      /// update thread event
      if(threadBroadcastEvent.action == ThreadBroadcastAction.update){

        final updatedThread = threadBroadcastEvent.thread;

        // find the thread whose values are updated
        final threadPreviews = [...state.threadPreviews];
        final threadIndex = threadPreviews.indexWhere((element) => element.id == updatedThread.id);

        // For some subclasses of threadCubit, this thread will not be found
        if(threadIndex > -1){
          setThreadPreview(thread: updatedThread);
        }

        // check if updated thread can be found in thread comments

        final threadCommentsMap = {...state.threadComments};
        if(threadCommentsMap.containsKey(updatedThread.parentId)){
          final comments = threadCommentsMap[updatedThread.parentId]!;
          final threadCommentIndex = comments.indexWhere((element) => element.id == updatedThread.id);
          if(threadCommentIndex > -1){
            comments[threadCommentIndex] = updatedThread;
            threadCommentsMap[updatedThread.parentId!] = comments;
            emit(state.copyWith(status: ThreadStatus.updateThreadPreviewCommentsInProgress,));
            emit(state.copyWith(status: ThreadStatus.updateThreadPreviewCommentsSuccessful,
                threadComments: threadCommentsMap
            ));
          }

        }

        // check if updated thread can be found in a thread comment replies

        final threadCommentRepliesMap = {...state.threadCommentReplies};
        if(threadCommentRepliesMap.containsKey(updatedThread.parentId)){
          final replies = threadCommentRepliesMap[updatedThread.parentId]!;
          final threadReplyIndex = replies.indexWhere((element) => element.id == updatedThread.id);
          if(threadReplyIndex > -1){
            replies[threadReplyIndex] = updatedThread;
            threadCommentRepliesMap[updatedThread.parentId!] = replies;
            emit(state.copyWith(status: ThreadStatus.updateThreadPreviewRepliesInProgress,));
            emit(state.copyWith(status: ThreadStatus.updateThreadPreviewRepliesSuccessful,
                threadCommentReplies: threadCommentRepliesMap
            ));
          }

        }

      }

      /// delete thread event
      else if(threadBroadcastEvent.action == ThreadBroadcastAction.delete){

        final threadToDelete = threadBroadcastEvent.thread;
        final threadPreviews = [...state.threadPreviews];
        final threadCommentsMap = {...state.threadComments};
        final threadCommentRepliesMap = {...state.threadCommentReplies};

        // find the thread whose values are updated
        final threadIndex = threadPreviews.indexWhere((element) => element.id == threadToDelete.id);

        // For some subclasses of threadPreviewCubit, this thread will not be found
        if(threadIndex > -1){
          // thread to delete found in thread previews

          // remove its equivalent thread replies from memory
          if(threadCommentsMap.containsKey(threadToDelete.parentId)){
            threadCommentsMap.removeWhere((key, value) => key == threadToDelete.parentId);
          }

          // then remove thread from thread preview
          threadPreviews.removeAt(threadIndex);

          emit(state.copyWith(status: ThreadStatus.deleteThreadPreviewInProgress,));
          emit(state.copyWith(status: ThreadStatus.deleteThreadPreviewSuccessful,
              threadPreviews: threadPreviews,
              threadComments: threadCommentsMap,
              data: threadToDelete
          ));

        }


        // check if thread to delete can be found in thread comments
        if(threadCommentsMap.containsKey(threadToDelete.parentId)){

          final comments = threadCommentsMap[threadToDelete.parentId]!;
          comments.removeWhere((element) => element.id == threadToDelete.id);

          threadCommentsMap[threadToDelete.parentId!] = comments;

          emit(state.copyWith(status: ThreadStatus.refreshThreadPreviewCommentsInProgress,));
          emit(state.copyWith(status: ThreadStatus.refreshThreadPreviewCommentsCompleted,
            threadComments: threadCommentsMap,
          ));

          // reduce thread preview totalReplies count
          final threadParentIndex = threadPreviews.indexWhere((element) => element.id == threadToDelete.parentId);
          if(threadParentIndex > -1){
            final threadPreviewFound = threadPreviews[threadParentIndex];
            final updatedThread = threadPreviewFound.copyWith(
                totalReplies: (threadPreviewFound.totalReplies ?? 1) - 1
            );
            setThreadPreview(thread: updatedThread);
          }


        }


        // check if the thread to delete can be found in a comment's replies
        if(threadCommentRepliesMap.containsKey(threadToDelete.parentId)) {
          final replies = threadCommentRepliesMap[threadToDelete.parentId]!;
          final threadToDeleteIndex = replies.indexWhere((element) => element.id == threadToDelete.id);
          if(threadToDeleteIndex > -1) {
            replies.removeAt(threadToDeleteIndex);

            threadCommentRepliesMap[threadToDelete.parentId!] = replies;

            emit(state.copyWith(status: ThreadStatus.refreshThreadPreviewCommentRepliesInProgress,));
            emit(state.copyWith(status: ThreadStatus.refreshThreadPreviewCommentRepliesCompleted,
              threadCommentReplies: threadCommentRepliesMap,
            ));
          }


        }

        // reduce the comment count
        final parentComments = threadCommentsMap[threadToDelete.parent?.parentId];
        if(parentComments != null){

          final parentCommentFoundIndex = parentComments.indexWhere((element) => element.id == threadToDelete.parentId);

          if(parentCommentFoundIndex > -1){
            final parentCommentFound = parentComments[parentCommentFoundIndex];
            final updatedParentCommentFound = parentCommentFound.copyWith(
                totalReplies: (parentCommentFound.totalReplies ?? 1) - 1
            );
            parentComments[parentCommentFoundIndex] = updatedParentCommentFound;
            threadCommentsMap[threadToDelete.parent!.parentId!] = parentComments;
            emit(state.copyWith(status: ThreadStatus.refreshThreadPreviewCommentsInProgress,));
            emit(state.copyWith(status: ThreadStatus.refreshThreadPreviewCommentsCompleted,
              threadComments: threadCommentsMap,
            ));
          }


        }

      }

      /// Reply thread event
      else if(threadBroadcastEvent.action == ThreadBroadcastAction.reply) {

        final thread = threadBroadcastEvent.thread;

        final threadCommentsMap = {...state.threadComments};

        if(threadCommentsMap.containsKey(thread.parentId)) {

          final comments = <ThreadModel>[...threadCommentsMap[thread.parentId]!];
          comments.add(thread);

          threadCommentsMap[thread.parentId!] = comments;

          emit(state.copyWith(status: ThreadStatus.refreshThreadPreviewCommentsInProgress,));
          emit(state.copyWith(status: ThreadStatus.refreshThreadPreviewCommentsCompleted,
            threadComments: threadCommentsMap,
          ));

          // increase the thread preview count
          final threadPreviews = [...state.threadPreviews];

          // find the thread whose values are updated
          final threadParentIndex = threadPreviews.indexWhere((element) => element.id == thread.parentId);
          if(threadParentIndex > -1){
            final threadPreviewFound = threadPreviews[threadParentIndex];
            final updatedThread = threadPreviewFound.copyWith(
              totalReplies: (threadPreviewFound.totalReplies ?? 0) + 1
            );
            setThreadPreview(thread: updatedThread);
          }

        }


        //! check if this thread is a reply to another comment (first ancestor reply)

        final threadCommentRepliesMap = {...state.threadCommentReplies};
        if(threadCommentRepliesMap.containsKey(thread.parentId)) {

          final replies = <ThreadModel>[...threadCommentRepliesMap[thread.parentId]!];
          replies.add(thread);

          threadCommentRepliesMap[thread.parentId!] = replies;

          emit(state.copyWith(status: ThreadStatus.refreshThreadPreviewCommentRepliesInProgress,));
          emit(state.copyWith(status: ThreadStatus.refreshThreadPreviewCommentRepliesCompleted,
            threadCommentReplies: threadCommentRepliesMap,
          ));

        }

        // increase the comment count
        final parentComments = threadCommentsMap[thread.parent?.parentId];
        if(parentComments != null){

          final parentCommentFoundIndex = parentComments.indexWhere((element) => element.id == thread.parentId);

          if(parentCommentFoundIndex > -1){
            final parentCommentFound = parentComments[parentCommentFoundIndex];
            final updatedParentCommentFound = parentCommentFound.copyWith(
                totalReplies: (parentCommentFound.totalReplies ?? 0) + 1
            );
            parentComments[parentCommentFoundIndex] = updatedParentCommentFound;
            threadCommentsMap[thread.parent!.parentId!] = parentComments;
            emit(state.copyWith(status: ThreadStatus.refreshThreadPreviewCommentsInProgress,));
            emit(state.copyWith(status: ThreadStatus.refreshThreadPreviewCommentsCompleted,
              threadComments: threadCommentsMap,
            ));
          }


        }

          // if(thread.parent?.parentId != null){
          //   final firstAncestorParentId = thread.parent?.parentId;
          //   if(threadCommentsMap.containsKey(firstAncestorParentId)) {
          //     final replies = <ThreadModel>[...threadCommentsMap[firstAncestorParentId]!];
          //     final parentReplyIndex = replies.indexWhere((element) => element.id == thread.parentId);
          //     if(parentReplyIndex > - 1) {
          //       final parentReplyThread = replies[parentReplyIndex];
          //
          //       final updatedParentReplyThread = parentReplyThread.copyWith(
          //           totalReplies: (parentReplyThread.totalReplies ?? 0) + 1,
          //           replies: (<ThreadModel>[...parentReplyThread.replies ?? <ThreadModel>[]])..add(thread)
          //       );
          //
          //       replies[parentReplyIndex] = updatedParentReplyThread;
          //       threadCommentsMap[firstAncestorParentId!] = replies;
          //
          //       emit(state.copyWith(status: ThreadStatus.refreshThreadPreviewCommentsInProgress,));
          //       emit(state.copyWith(status: ThreadStatus.refreshThreadPreviewCommentsCompleted,
          //         threadComments: threadCommentsMap,
          //       ));
          //     }
          //
          //   }
          // }
        }




    });

  }

  // Close stream subscriptions when cubit is disposed to avoid any memory leaks
  @override
  Future<void> close() async {
    await threadBroadcastRepositoryStreamListener?.cancel();
    return super.close();
  }

  ThreadModel setThreadPreview({required ThreadModel thread}){

    /// This method here adds the a given thread to the threads of interest
    /// Once a thread is previewed it becomes a thread of interest

    emit(state.copyWith(status: ThreadStatus.setThreadPreviewInProgress,));
    final threadPreviews = [...state.threadPreviews];
    final int index = threadPreviews.indexWhere((element) => element.id == thread.id);
    if(index < 0){

      threadPreviews.add(thread);

    }else {

      // threadPreview has already been added
      // so update it.

      final existingThread = threadPreviews[index];
      final existingThreadReplies = existingThread.replies;
      final updatedThread = thread.copyWith(replies: existingThreadReplies);
      threadPreviews[index] = updatedThread;

    }

    emit(state.copyWith(
        status: ThreadStatus.setThreadPreviewCompleted,
        threadPreviews: threadPreviews
    ));

    // return the threadPreview for methods that needs it
    final threadPreview = state.threadPreviews.firstWhere((element) => element.id == thread.id);
    return threadPreview;

  }

  // We do this to free memory space
  void removeThreadFromPreviews({required ThreadModel thread}){
    emit(state.copyWith(status: ThreadStatus.removeThreadPreviewInProgress,));
    final threadPreviews = [...state.threadPreviews];
    final int index = threadPreviews.indexWhere((element) => thread.id == thread.id);
    if(index > 0) {
      threadPreviews.removeAt(index);
    }
    emit(state.copyWith(
        status: ThreadStatus.removeThreadPreviewCompleted,
        threadPreviews: threadPreviews
    ));

  }



  /// Fetch threads from the server by Path
  Future<Either<String, List<ThreadModel>>> fetchThreadComments({required ThreadModel parentThread, required int pageKey,}) async {

    try{

      //! parent thread id should never be null
      if(parentThread.id == null){
        return const Left("Invalid parent thread");
      }

      emit(state.copyWith(status: ThreadStatus.fetchThreadRepliesInProgress));

      // final skip = pageKey  > 0 ?  state.threadPreviews.length : pageKey;  //
      final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey; // even if previous page returned items less than defaultPageSize, still skip by defaultPageSize
      final either = await threadRepository.fetchThreadComments(threadId: parentThread.id, limit: defaultPageSize, skip: skip);
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: ThreadStatus.fetchThreadRepliesFailed, message: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful
      List<ThreadModel> r = either.asRight();
      final threadCommentsMap = {...state.threadComments};
      final comments =  threadCommentsMap.containsKey(parentThread.id) ? threadCommentsMap[parentThread.id]! : <ThreadModel>[];

      if(pageKey == 0){
        // if its first page request remove all existing threads
        comments.clear();
      }

      // we add up to the thread replies here
      comments.addAll(r);

      threadCommentsMap[parentThread.id!] = comments;

      emit(state.copyWith(
        status: ThreadStatus.fetchThreadRepliesSuccessful,
        threadComments: threadCommentsMap,
      ));

      return Right(r);

    }catch(e){
      debugPrint("customLog: $e");
      emit(state.copyWith(status: ThreadStatus.fetchThreadRepliesFailed, message: e.toString()));
      return Left(e.toString());
    }

  }

  Future<Either<String, List<ThreadModel>>> fetchThreadCommentReplies({required int pageKey, required ThreadModel thread, required ThreadModel comment}) async {

    try {

      emit(state.copyWith(status: ThreadStatus.fetchThreadCommentRepliesInProgress,
        data: comment.id
      ));

      // final skip = pageKey  > 0 ?  state.threadPreviews.length : pageKey;  //
      final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey; // even if previous page returned items less than defaultPageSize, still skip by defaultPageSize
      final either = await threadRepository.fetchThreadCommentReplies(limit: defaultPageSize, skip: skip, commentId: comment.id);
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: ThreadStatus.fetchThreadRepliesFailed, message: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful
      List<ThreadModel> r = either.asRight();

      final threadCommentsRepliesMap = {...state.threadCommentReplies};
      final commentReplies =  threadCommentsRepliesMap.containsKey(comment.id) ? threadCommentsRepliesMap[comment.id]! : <ThreadModel>[];

      if(pageKey == 0){
        // if its first page request remove all existing threads
        commentReplies.clear();
      }

      // we add up to the thread replies here
      commentReplies.addAll(r);

      threadCommentsRepliesMap[comment.id!] = commentReplies;

      emit(state.copyWith(
        status: ThreadStatus.fetchThreadRepliesSuccessful,
        threadCommentReplies: threadCommentsRepliesMap,
      ));

      return Right(r);



    }catch(e){
      debugPrint("customLog: $e");
      emit(state.copyWith(status: ThreadStatus.fetchThreadRepliesFailed, message: e.toString()));
      return Left(e.toString());
    }

  }

}