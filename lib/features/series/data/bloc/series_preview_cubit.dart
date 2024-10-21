import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_enums.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_preview_state.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/series/data/models/series_reviewer_model.dart';
import 'package:showwcase_v3/features/series/data/repositories/series_repository.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_enums.dart';
import 'package:showwcase_v3/features/shows/data/models/show_broadcast_event.dart';
import 'package:showwcase_v3/features/shows/data/repositories/shows_broadcast_repository.dart';

class SeriesPreviewCubit extends Cubit<SeriesPreviewState>{

  final SeriesRepository seriesRepository;
  final ShowsBroadcastRepository showsBroadcastRepository;
  StreamSubscription<ShowBroadcastEvent>? showBroadcastRepositoryStreamListener;
  SeriesPreviewCubit({required this.seriesRepository, required this.showsBroadcastRepository}) : super(const SeriesPreviewState())  {
    _listenToShowBroadCastStreams();
  }

  // listen to updated show streams and update thread states accordingly
  void _listenToShowBroadCastStreams() async {
    await showBroadcastRepositoryStreamListener?.cancel();
    showBroadcastRepositoryStreamListener = showsBroadcastRepository.stream.listen((showBroadcastEvent) {

      if(showBroadcastEvent.action == ShowBroadcastAction.updateShow) {

        final updatedShow = showBroadcastEvent.show!;
        final seriesId = updatedShow.seriesId;

        final seriesList  = [...state.seriesPreviews];
        final seriesIndex = seriesList.indexWhere((element) => element.id == seriesId);
        if(seriesIndex < 0){
          return;
        }

        final parentSeries = seriesList[seriesIndex];
        final projectIndex = (parentSeries.projects ?? []).indexWhere((element) => element.id == updatedShow.id);
        if(projectIndex < 0){
          return;
        }

        parentSeries.projects![projectIndex] = updatedShow;

        seriesList[seriesIndex] = parentSeries;

        emit(state.copyWith(status: SeriesStatus.updateSeriesPreviewShowInProgress));
        emit(state.copyWith(
          seriesPreviews: seriesList,
          status: SeriesStatus.updateSeriesPreviewShowCompleted,
        ));

      }

    });
  }


  SeriesModel setSeriesPreview({required SeriesModel series, bool updateIfExist = true}){
    // updateIfExist, mean if Show Already Exists should it be updated
    // updateIfExist is usually true after we fetch the full show from the server

    /// This method here adds the a given show to the shows of interest
    /// Once a show is previewed it becomes a show of interest

    emit(state.copyWith(status: SeriesStatus.setSeriesPreviewInProgress,));
    final seriesPreviews = [...state.seriesPreviews];
    final int index = seriesPreviews.indexWhere((element) => element.id == series.id);
    if(index < 0){

      seriesPreviews.add(series);

    }else {

      // showPreview has already been added
      // so update it.
      if(updateIfExist) {

        seriesPreviews[index] = series;
      }

    }

    emit(state.copyWith(
        status: SeriesStatus.setSeriesPreviewCompleted,
        seriesPreviews: seriesPreviews
    ));

    // return the threadPreview for methods that needs it
    final showPreview = state.seriesPreviews.firstWhere((element) => element.id == series.id);
    return showPreview;

  }

  void fetchSeriesPreview({required int seriesId}) async {

    try {

      emit(state.copyWith(status: SeriesStatus.fetchSeriesPreviewInProgress,));

      final either = await seriesRepository.fetchSeriesPreview(seriesId: seriesId);

      either.fold((l) {

        emit(state.copyWith(status: SeriesStatus.fetchSeriesPreviewFailed, message: l.errorDescription));

      }, (r) {

        setSeriesPreview(series: r, updateIfExist: true);
        emit(state.copyWith(status: SeriesStatus.fetchSeriesPreviewSuccessful));

      });
    } catch (e) {
      emit(state.copyWith(message: e.toString(), status: SeriesStatus.fetchSeriesPreviewFailed));
    }
    
  }


  void fetchSeriesRatingStats({required int seriesId}) async {

    try {

      emit(state.copyWith(status: SeriesStatus.seriesRatingStatsFetching,));

      final either = await seriesRepository.fetchSeriesReviewStats(seriesId: seriesId);

      either.fold((l) {
        emit(state.copyWith(status: SeriesStatus.seriesRatingStatsFetchingFailed, message: l.errorDescription));
      }, (r) {

        final stats = {...state.stats};
        stats[seriesId] = r;

        emit(state.copyWith(status: SeriesStatus.seriesRatingStatsFetchingSuccessful,
            stats: stats
        ));
      });

    } catch (e) {
      emit(state.copyWith(message: e.toString(), status: SeriesStatus.seriesRatingStatsFetchingFailed));
    }
  }

  Future<void> createReview({required SeriesModel series, required String message, required int rating}) async {

    try {

      emit(state.copyWith(status:SeriesStatus.seriesRatingCreating,));

      final either = await seriesRepository.createReviewSeries(seriesId: series.id!, message: message, rating: rating);

      either.fold((l) {

        emit(state.copyWith(status: SeriesStatus.seriesRatingCreatingFailed, message: l.errorDescription));

      }, (r) {

        final reviewersMap = {...state.reviewers};
        final List<SeriesReviewerModel> reviewers = reviewersMap[series.id] ?? <SeriesReviewerModel>[];
        reviewers.insert(0, r);
        reviewersMap[series.id!] = reviewers;

        emit(state.copyWith(status: SeriesStatus.seriesRatingCreatingSuccessful,
            reviewers: reviewersMap
        ));

      });
    } catch (e) {
      emit(state.copyWith(message: e.toString(), status: SeriesStatus.seriesRatingCreatingFailed));
    }
  }

  Future<Either<String, List<SeriesReviewerModel>>> fetchSeriesRatingList({required SeriesModel seriesModel, required int pageKey})  async {

    try {

      emit(state.copyWith(status: SeriesStatus.fetchSeriesRatingListInProgress));

      final reviewersMap = {...state.reviewers};
      final List<SeriesReviewerModel> reviewers = reviewersMap[seriesModel.id] ?? <SeriesReviewerModel>[];

      final skip = pageKey  > 0 ?  defaultPageSize : pageKey;
      final either = await seriesRepository.fetchSeriesReviewList(seriesId: seriesModel.id!, skip: skip, limit: defaultPageSize);

      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: SeriesStatus.fetchSeriesRatingListFailed, message: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful
      List<SeriesReviewerModel> r = either.asRight();
      if(pageKey == 0){
        // if its first page request remove all existing threads
        reviewers.clear();
      }

      reviewers.addAll(r);

      reviewersMap[seriesModel.id!] = reviewers;

      emit(state.copyWith(status: SeriesStatus.fetchSeriesRatingListSuccessful,
          reviewers: reviewersMap
      ));

      return Right(r);

    } catch (e) {

      emit(state.copyWith(status: SeriesStatus.fetchSeriesRatingListFailed, message: e.toString()));
      return Left(e.toString());
    }


    // // we request for the default page size on the first call and subsequently we skip by the length of shows available
    // final skip = pageKey  > 0 ?  defaultPageSize : pageKey;  //
    // final path =  ApiConfig.fetchCircleMembers(userId: user.id!, skip: skip,limit: defaultPageSize);
    // return _fetchUsers(pageKey: pageKey, path: path);
    //


  }

}