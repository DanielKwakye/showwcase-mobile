import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/features/explore/data/bloc/explore_enums.dart';
import 'package:showwcase_v3/features/explore/data/bloc/explore_state.dart';
import 'package:showwcase_v3/features/explore/data/repositories/explore_repository.dart';

class ExploreCubit extends Cubit<ExploreState> {
  final ExploreRepository exploreRepository;
  ExploreCubit({required this.exploreRepository}) : super (const ExploreState());

  Future<void> fetchTrendingShows() async {

    emit(state.copyWith(
        status: ExploreStatus.fetchTrendingShowsLoading
    ));

    try {

      final either = await exploreRepository.fetchTrendingShows();
      either.fold((l) {
        emit(state.copyWith(
            status: ExploreStatus.fetchTrendingShowsFailure,
            message: l.errorDescription
        ));
      }, (r) {
        emit(state.copyWith(
            status: ExploreStatus.fetchTrendingShowsSuccess,
            trendingShows: r
        ));
      });
    } catch (e) {
      emit(state.copyWith(
          status: ExploreStatus.fetchTrendingShowsFailure,
          message: e.toString()
      ));
    }


  }

}