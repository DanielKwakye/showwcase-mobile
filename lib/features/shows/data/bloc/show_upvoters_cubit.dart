import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_upvoters_state.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_enums.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/shows/data/repositories/shows_repository.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class ShowUpVotersCubit extends Cubit<ShowUpVotersState> {

  final ShowsRepository showsRepository;
  ShowUpVotersCubit({required this.showsRepository}) :super(const ShowUpVotersState());


  Future<Either<String, List<UserModel>>> fetchShowUpVoters({required int pageKey, required ShowModel show}) async {

    try{

      emit(state.copyWith(status: ShowsStatus.fetchShowUpVotersInProgress));
      // we request for the default page size on the first call and subsequently we skip by the length of voters available
      final skip = pageKey  > 0 ?  pageKey * defaultPageSize : pageKey;  //
      final either = await showsRepository.fetchShowUpVoters(showId: show.id!, skip: skip, limit: defaultPageSize);
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: ShowsStatus.fetchShowUpVotersFailed, message: l.errorDescription));
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
        status: ShowsStatus.fetchShowUpVotersSuccessful,
        voters: voters,
      ));

      return Right(r);

    }catch(e){
      debugPrint("customLog: $e");
      emit(state.copyWith(status: ShowsStatus.fetchShowUpVotersFailed, message: e.toString()));
      return Left(e.toString());
    }

  }

}