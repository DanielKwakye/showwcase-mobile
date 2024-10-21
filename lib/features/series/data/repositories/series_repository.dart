import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/series/data/models/series_review_stats_model.dart';
import 'package:showwcase_v3/features/series/data/models/series_reviewer_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';

class SeriesRepository {

  final NetworkProvider _networkProvider;
  SeriesRepository(this._networkProvider);

  Future<Either<ApiError, List<SeriesModel>>> fetchSeries({required String path}) async {
    try {

      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final seriesList = List<SeriesModel>.from(
            response.data.map((x) => SeriesModel.fromJson(x)));
        return Right(seriesList);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }


  Future<Either<ApiError, ShowModel>> fetchSeriesProject({required int projectId}) async {
    try{

      final path = ApiConfig.fetchSeriesProjectPreview(projectId: projectId);
      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final showsResponse = ShowModel.fromJson(response.data);
        return Right(showsResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }


    } on DioException catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, SeriesModel>> fetchSeriesPreview({required int seriesId}) async {

    try{

      final path = ApiConfig.fetchSeriesPreview(seriesId: seriesId);
      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final seriesResponse = SeriesModel.fromJson(response.data);
        return Right(seriesResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }


    } on DioException catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, List<SeriesReviewerModel>>> fetchSeriesReviewList({required int seriesId, required int limit, required int skip}) async {
    try{

      final path = ApiConfig.fetchSeriesRatingList(seriesId: seriesId, limit: limit, skip: skip);
      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final reviewListResponse = List<SeriesReviewerModel>.from(response.data.map((x) => SeriesReviewerModel.fromJson(x)));
        return Right(reviewListResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }


    } on DioException catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, SeriesReviewerModel>> createReviewSeries({required int seriesId, required String message, required int rating }) async {


    try{

      final path = ApiConfig.reviewSeries;
      var response = await _networkProvider.call(
          path: path,
          body: {
            "seriesId": seriesId,
            "message": message,
            "rating": rating
          },
          method: RequestMethod.post);

      if (response!.statusCode == 200) {
         final reviewer = SeriesReviewerModel.fromJson(response.data);
         return Right(reviewer);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }


    } on DioException catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, List<SeriesModel>>> fetchProfileSeries({required String userName,required int limit, required int skip})async {
    try {
      final path = ApiConfig.fetchProfileSeries(limit: limit, skip: skip, userName: userName,);
      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final seriesResponse = List<SeriesModel>.from(
            response.data.map((x) => SeriesModel.fromJson(x)));
        return Right(seriesResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioException catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, void>> markProjectAsComplete({required int projectId}) async {
    try {
      final path = ApiConfig.markProjectAsComplete(projectId: projectId);
      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.put);

      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioException catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, bool>> reportSeries({required String message, required int seriesId}) async {
    try {
      var response = await _networkProvider.call(
          path: ApiConfig.complaints,
          method: RequestMethod.post,
          body: {
            "message": message,
            "seriesId": seriesId
          });
      if (response!.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(ApiError(errorDescription: response.data['error'] ?? "Unable to submit report"));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, SeriesReviewStatsModel>> fetchSeriesReviewStats({required int seriesId}) async {

    try{

      final path = ApiConfig.fetchSeriesRatingStats(seriesId: seriesId);
      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final reviewStatsResponse = SeriesReviewStatsModel.fromJson(response.data);
        return Right(reviewStatsResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }


    }  catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }





}