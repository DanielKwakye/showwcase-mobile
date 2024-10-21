import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_enums.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_state.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/series/data/repositories/series_repository.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_enums.dart';
import 'package:showwcase_v3/features/shows/data/models/show_broadcast_event.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/shows/data/repositories/shows_broadcast_repository.dart';

class SeriesCubit extends Cubit<SeriesState> {

  final SeriesRepository seriesRepository;
  final ShowsBroadcastRepository showsBroadcastRepository;
  StreamSubscription<ShowBroadcastEvent>? showBroadcastRepositoryStreamListener;
  SeriesCubit( {required this.seriesRepository, required this.showsBroadcastRepository}): super(const SeriesState()) {
    _listenToShowBroadCastStreams();
  }

  // listen to updated show streams and update thread states accordingly
  void _listenToShowBroadCastStreams() async {
    await showBroadcastRepositoryStreamListener?.cancel();
    showBroadcastRepositoryStreamListener = showsBroadcastRepository.stream.listen((showBroadcastEvent) {

      if(showBroadcastEvent.action == ShowBroadcastAction.updateShow) {

        final updatedShow = showBroadcastEvent.show!;
        final seriesId = updatedShow.seriesId;

        final seriesList  = [...state.series];
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

        emit(state.copyWith(status: SeriesStatus.updateSeriesShowInProgress));
        emit(state.copyWith(
            series: seriesList,
            status: SeriesStatus.updateSeriesShowCompleted,
        ));

      }

    });
  }

  // This is stateless, (Does not keep the data in state) and just returns the data to the caller
  Future<SeriesModel?> getSeriesById({required int seriesId}) async {

    try {

      final either = await seriesRepository.fetchSeriesPreview(seriesId: seriesId);
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

  Future<Either<String, List<SeriesModel>>> fetchSeries({required int pageKey, required String path}) async {

    try {
      emit(state.copyWith(status: SeriesStatus.fetchSeriesInProgress));

      final either = await seriesRepository.fetchSeries(path: path);

      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: SeriesStatus.fetchSeriesFailed, message: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful
      List<SeriesModel> r = either.asRight();
      final List<SeriesModel> series = [...state.series];
      if(pageKey == 0){
        // if its first page request remove all existing shows
        series.clear();
      }

      series.addAll(r);

      emit(state.copyWith(
        status: SeriesStatus.fetchSeriesSuccessful,
        series: series,
      ));

      return Right(r);

    } catch (e) {
      emit(state.copyWith(status: SeriesStatus.fetchSeriesFailed, message: e.toString()));
      return Left(e.toString());
    }
  }

  void reportSeries({required String message, required int seriesId}) async {

    try{

      emit(state.copyWith(status: SeriesStatus.reportSeriesInProgress));

      final either = await seriesRepository.reportSeries(message: message, seriesId: seriesId);

      either.fold(
              (l) {
            emit(state.copyWith(status: SeriesStatus.reportSeriesFailed, message: l.errorDescription));
          },
              (r) {

            emit(state.copyWith(status: SeriesStatus.reportSeriesSuccessful,
                message: "Thanks for the feedback. The reported show is now under investigation"
            ));
          }

      );
    }catch(e){
      emit(state.copyWith(status: SeriesStatus.reportSeriesFailed, message:e.toString()));
    }
  }

  void markSeriesProjectAsComplete({required SeriesModel seriesModel, required ShowModel showModel}) async {

    try{

      emit(state.copyWith(status: SeriesStatus.markProjectAsCompleteInProgress));

      final either = await seriesRepository.markProjectAsComplete(projectId: showModel.id!);

      either.fold(
              (l) {
            emit(state.copyWith(status: SeriesStatus.markProjectAsCompleteFailed, message: l.errorDescription));
          },
              (r) {


            final updatedShow = showModel.copyWith(
              hasCompleted: true,
              seriesId: seriesModel.id
            );
            showsBroadcastRepository.updateShow(updatedShow: updatedShow);
            emit(state.copyWith(status: SeriesStatus.markProjectAsCompleteSuccessful,));

          }

      );
    }catch(e){
      emit(state.copyWith(status: SeriesStatus.markProjectAsCompleteFailed, message:e.toString()));
    }
  }

}