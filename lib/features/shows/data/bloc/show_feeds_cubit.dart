import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_cubit.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_enums.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_state.dart';
import 'package:showwcase_v3/features/shows/data/models/show_category_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';

class ShowFeedsCubit extends ShowsCubit {

  ShowFeedsCubit({required super.showsRepository, required super.showsBroadcastRepository});

  Future<Either<String, List<ShowModel>>> fetchShowFeeds(int pageKey) {

    // we request for the default page size on the first call and subsequently we skip by the length of shows available
    // final skip = pageKey  > 0 ?  state.shows.length : pageKey;  //
    final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey;  // even if previous page returned items less than defaultPageSize, still skip by defaultPageSize
    final path = ApiConfig.fetchShows(skip: skip, limit: defaultPageSize, category: state.selectedShowCategory.category);
    return super.fetchShows(pageKey: pageKey, path: path);

  }

  //! this feature is only available on main show feeds
  void fetchShowCategories() async {

    try {

      emit(state.copyWith(status: ShowsStatus.fetchShowCategoriesInProgress));
      if(state.showCategories.length > 1) {
        emit(state.copyWith(status: ShowsStatus.fetchShowCategoriesSuccessful));
        return;
      }

      final either = await showsRepository.fetchShowCategories();

      either.fold(
              (l) =>  emit(state.copyWith(
              status: ShowsStatus.fetchShowCategoriesFailed,
              message: l.errorDescription
          )),
              (r) {

                emit(state.copyWith(status: ShowsStatus.fetchShowCategoriesInProgress));
                emit(state.copyWith(status: ShowsStatus.fetchShowCategoriesSuccessful, showCategories: [...state.showCategories, ...r]));
              }
      );

    }catch(e) {
      emit(state.copyWith(status: ShowsStatus.fetchShowCategoriesFailed, message: e.toString()));
    }
  }

  void selectShowFeedCategory(ShowCategoryModel category) {
    emit(state.copyWith(status: ShowsStatus.selectShowFeedCategoryInProgress));
    emit(state.copyWith(
        status: ShowsStatus.selectShowFeedCategoryCompleted,
        selectedShowCategory: category
    ));
  }

}