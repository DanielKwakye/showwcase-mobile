import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_enums.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_poll_voters_state.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_voter_model.dart';
import 'package:showwcase_v3/features/threads/data/repositories/thread_repository.dart';

class ThreadPollVotersCubit extends Cubit<ThreadPollVotersState> {

  final ThreadRepository threadRepository;
  ThreadPollVotersCubit(this.threadRepository): super(const ThreadPollVotersState());

  Future<Either<String, List<ThreadVoterModel>>> fetchThreadPollVoters({required int pageKey, required ThreadModel thread}) async {

    try{

      emit(state.copyWith(status: ThreadStatus.fetchThreadPollVotersInProgress));
      // we request for the default page size on the first call and subsequently we skip by the length of voters available
      final skip = pageKey  > 0 ?  state.voters.length : pageKey;  //
      final either = await threadRepository.fetchPollVoters(threadId: thread.id, pollId: thread.pollId, skip: skip, limit: defaultPageSize);
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: ThreadStatus.fetchThreadPollVotersFailed, message: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful
      List<ThreadVoterModel> r = either.asRight();
      final List<ThreadVoterModel> voters = [...state.voters];
      if(pageKey == 0){
        // if its first page request remove all existing threads
        voters.clear();
      }

      voters.addAll(r);

      emit(state.copyWith(
        status: ThreadStatus.fetchThreadPollVotersSuccessful,
        voters: voters,
      ));

      return Right(r);

    }catch(e){
      debugPrint("customLog: $e");
      emit(state.copyWith(status: ThreadStatus.fetchThreadPollVotersFailed, message: e.toString()));
      return Left(e.toString());
    }

  }



}