import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/analytics/data/service/analytics_service.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_enums.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_state.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_broadcast_event.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_editor_request.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_poll_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_poll_option_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_poll_vote_model.dart';
import 'package:showwcase_v3/features/threads/data/repositories/thread_broadcast_repository.dart';
import 'package:showwcase_v3/features/threads/data/repositories/thread_repository.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';


class ThreadCubit extends Cubit<ThreadState> {

  final ThreadRepository threadRepository;
  final ThreadBroadcastRepository threadBroadcastRepository;

  StreamSubscription<ThreadBroadcastEvent>? threadBroadcastRepositoryStreamListener;
  ThreadCubit(this.threadRepository, {required this.threadBroadcastRepository}): super(const ThreadState()){
    _listenToThreadBroadCastStreams();
  }

  // listen to updated thread streams and update thread states accordingly
  void _listenToThreadBroadCastStreams() async {
    await threadBroadcastRepositoryStreamListener?.cancel();
    threadBroadcastRepositoryStreamListener = threadBroadcastRepository.stream.listen((threadBroadcastEvent) {

      /// update thread event
      if(threadBroadcastEvent.action == ThreadBroadcastAction.update) {

        final updatedThread = threadBroadcastEvent.thread;
        emit(state.copyWith(status: ThreadStatus.updateThreadsInProgress));

        final threadList = [...state.threads];
        // find the thread whose values are updated
        final threadIndex = threadList.indexWhere((element) => element.id == updatedThread.id);

        // we can't continue if thread wasn't found
        // For some subclasses of threadCubit, this thread will not be found
        if(threadIndex < 0){
          // before you return check if updatedThread is a thread reply
          if(updatedThread.parentId != null) {
            final parentThreadIndex = threadList.indexWhere((element) => element.id == updatedThread.parentId);
            if(parentThreadIndex > -1) {
              final parentThreadFound = threadList[parentThreadIndex];
              final threadReplies = [...parentThreadFound.replies ?? <ThreadModel>[]];
              final threadReplyIndex = threadReplies.indexWhere((element) => element.id == updatedThread.id);

              // if the parent thread has this as thread reply, the update
              if(threadReplyIndex > -1) {

                threadReplies[threadReplyIndex] = updatedThread;

                threadList[parentThreadIndex] = parentThreadFound.copyWith(
                    replies: threadReplies
                );
                emit(state.copyWith(
                    threads: threadList,
                    status: ThreadStatus.updateThreadsCompleted,
                    data: updatedThread
                ));
                return;
              }

            }
          }

          return;
        }

        threadList[threadIndex] = updatedThread;

        // if thread was found in this cubit then update, and notify all listening UIs
        emit(state.copyWith(
            threads: threadList,
            status: ThreadStatus.updateThreadsCompleted,
            data: updatedThread
        ));


      }

      /// delete thread event
      else if(threadBroadcastEvent.action == ThreadBroadcastAction.delete){

        final threadToDelete = threadBroadcastEvent.thread;

        final threadList = [...state.threads];
        // find the thread whose values are updated
        final threadIndex = threadList.indexWhere((element) => element.id == threadToDelete.id);
        if(threadIndex > -1){
          // its a main threads
          threadList.removeAt(threadIndex);
        }else{
          // attempt to remove the given thread from the thread replies
          if(threadToDelete.parentId != null){
            final parentThreadIndex = threadList.indexWhere((element) => element.id == threadToDelete.parentId);
            if(parentThreadIndex > -1) {
              final parentThreadFound = threadList[parentThreadIndex];
              final threadReplies = [...parentThreadFound.replies ?? <ThreadModel>[]];
              final threadReplyIndex = threadReplies.indexWhere((element) => element.id == threadToDelete.id);
              if(threadReplyIndex > -1){
                threadReplies.removeAt(threadReplyIndex);
              }
              final totalReplies = (parentThreadFound.totalReplies ?? 1) - 1;
              threadList[parentThreadIndex] = parentThreadFound.copyWith(
                  replies: threadReplies,
                  totalReplies: totalReplies == 0 ? null : totalReplies
              );
            }

          }
        }

        emit(state.copyWith(status: ThreadStatus.refreshThreadInProgress));
        emit(state.copyWith(status: ThreadStatus.refreshThreadsCompleted, threads: threadList,));

      }

      /// Thread replies
      else if(threadBroadcastEvent.action == ThreadBroadcastAction.reply) {

        final thread = threadBroadcastEvent.thread;

        emit(state.copyWith(status: ThreadStatus.updateThreadsInProgress));

        //! check if its a reply to a main thread
        final threadList = [...state.threads];
        final parentThreadIndex = threadList.indexWhere((element) => element.id == thread.parentId);
        if(parentThreadIndex > -1) {
          final parentThreadFound = threadList[parentThreadIndex];
          final threadReplies = [...parentThreadFound.replies ?? <ThreadModel>[]];

          // add to thread replies
          threadReplies.add(thread);

          final totalReplies = (parentThreadFound.totalReplies ?? 0) + 1;

          threadList[parentThreadIndex] = parentThreadFound.copyWith(
              replies: threadReplies,
              totalReplies: totalReplies
          );

          emit(state.copyWith(
              status: ThreadStatus.updateThreadsCompleted,
              threads: threadList
          ));

          }
        else {
          //! check if this thread is a reply to another reply (first ancestor reply)
          if(thread.parent?.parentId != null){
            final firstAncestorParentId = thread.parent?.parentId;
            final firstAncestorParentIndex = threadList.indexWhere((element) => element.id == firstAncestorParentId);
            if(firstAncestorParentIndex > -1) {
              final firstAncestorParentThreadFound = threadList[firstAncestorParentIndex];
              final firstAncestorParentThreadReplies = [...( firstAncestorParentThreadFound.replies ?? <ThreadModel>[] )];
              final parentThreadIndex = firstAncestorParentThreadReplies.indexWhere((element) => element.id == thread.parentId);
              if(parentThreadIndex > -1){
                final parentThreadFound = firstAncestorParentThreadReplies[parentThreadIndex];

                final totalReplies = (parentThreadFound.totalReplies ?? 0) + 1;
                final threadReplies = [...(parentThreadFound.replies ?? <ThreadModel>[])];
                threadReplies.add(thread);

                firstAncestorParentThreadReplies[parentThreadIndex] = parentThreadFound.copyWith(
                    replies: threadReplies,
                    totalReplies: totalReplies
                );

                threadList[firstAncestorParentIndex] = firstAncestorParentThreadFound.copyWith(
                  replies: firstAncestorParentThreadReplies
                );

                emit(state.copyWith(
                    status: ThreadStatus.updateThreadsCompleted,
                    threads: threadList
                ));
              }
            }

          }

        }

      }

    });
  }

  // Close stream subscriptions when cubit is disposed to avoid any memory leaks
  @override
  Future<void> close() async {
    await threadBroadcastRepositoryStreamListener?.cancel();
    return super.close();
  }


  // This is stateless, (Does not keep the data in state) and just returns the data to the caller
  Future<ThreadModel?> getThreadFromId({required int threadId}) async {

    try {

      final either = await threadRepository.fetchThreadFromId(threadId: threadId);
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

  /// Fetch threads from the server by Path
  ///
  Future<Either<String, List<ThreadModel>>> fetchThreads({required int pageKey, required String path}) async {

    try{

      emit(state.copyWith(status: ThreadStatus.fetchThreadsInProgress));
      final either = await threadRepository.fetchThreads(path: path);
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: ThreadStatus.fetchThreadsFailed, message: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful
      List<ThreadModel> r = either.asRight();
      final List<ThreadModel> threads = [...state.threads];
      if(pageKey == 0){
        // if its first page request remove all existing threads
        threads.clear();
      }

      threads.addAll(r);

      emit(state.copyWith(
        status: ThreadStatus.fetchThreadsSuccessful,
        threads: threads,
      ));

      return Right(r);

    }catch(e){
      debugPrint("customLog: $e");
      emit(state.copyWith(status: ThreadStatus.fetchThreadsFailed, message: e.toString()));
      return Left(e.toString());
    }

  }


  /// upvote thread
  void upvoteThread({required ThreadModel thread, required UpvoteActionType actionType}) async {

    // thread id cannot be null
    if(thread.id == null){
      return;
    }

    update() {

      /// The mechanism here is to broadcast the updated Thread to the app so that
      /// any subClassed cubit having this thread updates accordingly

      if (actionType == UpvoteActionType.upvote) {

        final updatedThread = thread.copyWith(
          totalUpvotes: (thread.totalUpvotes ?? 0) + 1,
          hasVoted: true
        );

        threadBroadcastRepository.updateThread(thread: updatedThread);

      } else {

        final updatedThread = thread.copyWith(
            totalUpvotes: (thread.totalUpvotes ?? 1)  - 1,
            hasVoted: false
        );

        threadBroadcastRepository.updateThread(thread: updatedThread);

      }

    }

    reverse(String reason) {


      /// The mechanism here is to broadcast the updated Thread to the app so that
      /// any subClassed cubit having this thread updates accordingly


      if (actionType == UpvoteActionType.upvote) {
        // if action was upvote and it api call failed

        final updatedThread = thread.copyWith(
            totalUpvotes: (thread.totalUpvotes ?? 1) - 1,
            hasVoted: false
        );

        threadBroadcastRepository.updateThread(thread: updatedThread);

      } else {

        // if action was unvote and it api call failed

        final updatedThread = thread.copyWith(
            totalUpvotes: (thread.totalUpvotes ?? 0) + 1,
            hasVoted: true
        );

        threadBroadcastRepository.updateThread(thread: updatedThread);

      }


    }


    // optimistic update
    update();

    try{

      final either = await threadRepository.upvoteThread(threadId: thread.id!, actionType: actionType);
      either.fold((l) => reverse(l.errorDescription),
              (r) {
                // we do nothing again when its successful, cus we've already called the update() functionality
              }
      );

    }catch(e){
      reverse(e.toString());
    }

  }

  /// boost thread
  void boostThread({required ThreadModel thread, required BoostActionType actionType}) async {

    // thread id cannot be null
    if(thread.id == null){
      return;
    }

    update() {

      /// The mechanism here is to broadcast the updated Thread to the app so that
      /// any subClassed cubit having this thread updates accordingly

      if (actionType == BoostActionType.boost) {

        final updatedThread = thread.copyWith(
          totalBoosts: (thread.totalBoosts ?? 0) + 1,
          hasBoosted: true
        );

        threadBroadcastRepository.updateThread(thread: updatedThread);

      } else {

        final updatedThread = thread.copyWith(
            totalBoosts: (thread.totalBoosts ?? 1)  - 1,
            hasBoosted: false
        );

        threadBroadcastRepository.updateThread(thread: updatedThread);

      }

    }

    reverse(String reason) {


      /// The mechanism here is to broadcast the updated Thread to the app so that
      /// any subClassed cubit having this thread updates accordingly


      if (actionType == BoostActionType.boost) {
        // if action was boost and it api call failed

        final updatedThread = thread.copyWith(
            totalBoosts: (thread.totalBoosts ?? 1) - 1,
            hasBoosted: false
        );

        threadBroadcastRepository.updateThread(thread: updatedThread);

      } else {

        // if action was unboost and it api call failed

        final updatedThread = thread.copyWith(
            totalBoosts: (thread.totalBoosts ?? 0) + 1,
            hasBoosted: true
        );

        threadBroadcastRepository.updateThread(thread: updatedThread);

      }


    }


    // optimistic update
    update();

    try{

      final either = await threadRepository.boostThread(threadId: thread.id!, actionType: actionType);
      either.fold((l) => reverse(l.errorDescription),
              (r) {
                // we do nothing again when its successful, cus we've already called the update() functionality
              }
      );

    }catch(e){
      reverse(e.toString());
    }

  }


  /// bookmark thread
  void bookmarkThread({required ThreadModel thread, required bool isBookmark}) async {

    // thread id cannot be null
    if(thread.id == null){
      return;
    }

    update() {
      /// The mechanism here is to broadcast the updated Thread to the app so that
      /// any subClassed cubit having this thread updates accordingly
      final updatedThread = thread.copyWith(
          hasBookmarked: isBookmark
      );
      threadBroadcastRepository.updateThread(thread: updatedThread);
    }

    reverse(String reason) {
      /// The mechanism here is to broadcast the updated Thread to the app so that
      /// any subClassed cubit having this thread updates accordingly
        final updatedThread = thread.copyWith(
            hasBookmarked: thread.hasBookmarked
        );
        threadBroadcastRepository.updateThread(thread: updatedThread);
    }


    // optimistic update
    update();

    try{

      final either = await threadRepository.bookmarkThread(threadId: thread.id!, isBookmark: isBookmark);
      either.fold((l) => reverse(l.errorDescription),
              (r) {
                // we do nothing again when its successful, cus we've already called the update() functionality
              }
      );
    }catch(e){
      reverse(e.toString());
    }

  }


  void castVote({required ThreadModel thread, int? pollId, int? pollOptionId}) async {

    // we'll use the already existing poll if voting fails
    final existingPoll = thread.poll;

    update() {

      final userId = AppStorage.currentUserSession!.id!;

      // to the user in the vote obj
      final vote = ThreadPollVoteModel(
        userId: userId,
        optionId: pollOptionId,
        pollId: pollId,
      );

      // increase the total votes for the option which was voted for
      final options = (thread.poll?.options ?? <ThreadPollOptionModel>[]);
      final optionIndex = options.indexWhere((element) => element.id == pollOptionId);
      if(optionIndex > -1){
        final selectedOption = options[optionIndex];
        options[optionIndex] = selectedOption.copyWith(
          totalVotes: (selectedOption.totalVotes ?? 0) + 1
        );
      }

      // add the currently loggedInUser to the voters
      final List<UserModel> voters = thread.poll?.voters ?? <UserModel>[];
      final currentUser = AppStorage.currentUserSession;
      // if currently logged in user is not already part of the voters add him
      final exists = voters.indexWhere((element) => element.id == currentUser?.id);
      if(exists < 0){
        voters.add(currentUser!);
      }

      // update poll
      final poll = thread.poll?.copyWith(
          totalVotes: (thread.poll?.totalVotes ?? 0) + 1,
          vote: vote,
          options: options,
          voters: voters
      );

      final updatedThread = thread.copyWith(
        poll: poll
      );

      threadBroadcastRepository.updateThread(thread: updatedThread);

    }

    // if api call fails, the we revert to the previous poll state
    reverse(String reason) {
      final updatedThread = thread.copyWith(
          poll: existingPoll
      );
      threadBroadcastRepository.updateThread(thread: updatedThread);
    }



    // optimistic update
    update();

    try{

      final either = await threadRepository.votePoll(threadId: thread.id!, pollId: pollId, optionId: pollOptionId);
      either.fold((l) => reverse(l.errorDescription),
              (r) {
            // we do nothing again when its successful, cus we've already called the update() functionality
          }
      );
    }catch(e){
      reverse(e.toString());
    }

  }

  Future<String?> reportThread({required String message, required threadId}) async {

    try{

      emit(state.copyWith(status: ThreadStatus.reportThreadInProgress));

      final either = await threadRepository.reportThread(message: message, threadId: threadId);

      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: ThreadStatus.reportThreadFailed, message: l.errorDescription));
        return l.errorDescription;
      }

      emit(state.copyWith(status: ThreadStatus.reportThreadSuccessful));
      return null;

    }catch(e){
      // sharedCubit.showPageError(error: );
      emit(state.copyWith(status: ThreadStatus.reportThreadFailed, message: e.toString()));
      return e.toString();

    }
  }

  Future<String?> deleteThread({required ThreadModel thread}) async {

    try{

      emit(state.copyWith(status: ThreadStatus.deleteThreadInProgress));

      final either = await threadRepository.deleteThread(threadId: thread.id!);

      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: ThreadStatus.deleteThreadFailed, message: l.errorDescription));
        return l.errorDescription;
      }

      emit(state.copyWith(status: ThreadStatus.deleteThreadSuccessful));
      threadBroadcastRepository.removeThread(thread: thread);
      return null;

    }catch(e){
      // sharedCubit.showPageError(error: );
      emit(state.copyWith(status: ThreadStatus.reportThreadFailed, message: e.toString()));
      return e.toString();

    }
  }

  // this method notifies the widget capable of processing thread to begin processing
  // the widget will upload any images and videos if necessary, then call [submitThread] method
  void processThreadSubmission({required ThreadEditorRequest request,}) async {
    emit(state.copyWith(status: ThreadStatus.processThreadSubmissionRequesting,));
    emit(state.copyWith(status: ThreadStatus.processThreadSubmissionRequested, data: request));
  }


  /// create edit and reply thread
  Future<Either<String, ThreadModel>> createOrReplyThread({required ThreadEditorRequest createThreadRequest,}) async {

    try {

      emit(state.copyWith(status: ThreadStatus.createOrReplyThreadInProgress,));
      Either<ApiError, ThreadModel> either  = await threadRepository.createOrReplyThread(createThreadRequest: createThreadRequest);

      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: ThreadStatus.createOrReplyThreadFailed, message: l.errorDescription));
        return Left(l.errorDescription);
      }

      final r = either.asRight();
      // successful
      emit(state.copyWith(status: ThreadStatus.createOrReplyThreadSuccessful));
      if(!(createThreadRequest.scheduled ?? false)) {

        threadBroadcastRepository.addThread(thread: r.copyWith(
          parent: createThreadRequest.threadToReply,
          community: createThreadRequest.community
        ));

      }
      AnalyticsService.instance.sendEventThreadPost(threadModel: r);
      return Right(r);

    } catch (e) {
      emit(state.copyWith(status: ThreadStatus.createOrReplyThreadFailed, message: e.toString()));
      return Left(e.toString());
    }
  }

  Future<Either<String, ThreadModel>> editThread({required ThreadEditorRequest createThreadRequest,}) async {

    try {

      emit(state.copyWith(status: ThreadStatus.editThreadInProgress,));
      Either<ApiError, ThreadModel> either  = await threadRepository.editThread(createThreadRequest: createThreadRequest, threadId: createThreadRequest.threadToEdit?.id);

      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: ThreadStatus.editThreadFailed, message: l.errorDescription));
        return Left(l.errorDescription);
      }

      final r = either.asRight();
      // successful
      emit(state.copyWith(status: ThreadStatus.editThreadSuccessful));
      if(!(createThreadRequest.scheduled ?? false)) {
        threadBroadcastRepository.updateThread(thread: r.copyWith(
            parent: createThreadRequest.threadToReply
        ));
      }
      return Right(r);

    } catch (e) {
      emit(state.copyWith(status: ThreadStatus.editThreadFailed, message: e.toString()));
      return Left(e.toString());
    }
  }

}