import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/search/data/bloc/search_enums.dart';
import 'package:showwcase_v3/features/search/data/bloc/search_state.dart';
import 'package:showwcase_v3/features/search/data/repositories/search_respository.dart';

class SearchCubit extends Cubit<SearchState> {

  final SearchRepository searchRepository;
  // listen to updates from ThreadRepository, UserRepository, CommunityRepository, ShowRepository
  // and update data in TopResponse

  SearchCubit({required this.searchRepository}): super(const SearchState()) {
    //
  }

  void search ({ required String searchText }) async {
    // searchRepository.searchTop(text: searchText);

    try {

      emit(state.copyWith(status: SearchStatus.searchInProgress));

      final either = await searchRepository.search(text: searchText, limit: 5);
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: SearchStatus.searchFailed,
            message: l.errorDescription
        ));
        return;
      }


      // successful
      final r = either.asRight();
      emit(state.copyWith(status:  SearchStatus.searchSuccessful,
          topSearch: r,
      ));

    } catch (e) {
      emit(state.copyWith(status: SearchStatus.searchFailed,
          message: e.toString()
      ));
    }

  }


}