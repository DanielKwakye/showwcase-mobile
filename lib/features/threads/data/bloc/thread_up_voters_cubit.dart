import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_enums.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_up_voters_state.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/data/repositories/thread_repository.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class ThreadUpVotersCubit  extends Cubit<ThreadUpVotersState> {

  final ThreadRepository threadRepository;
  ThreadUpVotersCubit(this.threadRepository): super(const ThreadUpVotersState());

  Future<Either<String, List<UserModel>>> fetchThreadUpVoters({required int pageKey, required ThreadModel thread}) async {

    try{

      emit(state.copyWith(status: ThreadStatus.fetchThreadUpVotersInProgress));
      // we request for the default page size on the first call and subsequently we skip by the length of voters available
      final skip = pageKey  > 0 ?  pageKey * defaultPageSize : pageKey;  //
      final either = await threadRepository.fetchUpVoters(threadId: thread.id!, skip: skip, limit: defaultPageSize);
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: ThreadStatus.fetchThreadUpVotersFailed, message: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful
      List<UserModel> r = either.asRight();
      final List<UserModel> voters = [...state.voters];
      if(pageKey == 0){
        // if its first page request remove all existing threads
        voters.clear();
      }

      voters.addAll(r);

      emit(state.copyWith(
        status: ThreadStatus.fetchThreadUpVotersSuccessful,
        voters: voters,
      ));

      return Right(r);

    }catch(e){
      debugPrint("customLog: $e");
      emit(state.copyWith(status: ThreadStatus.fetchThreadUpVotersFailed, message: e.toString()));
      return Left(e.toString());
    }

  }

}