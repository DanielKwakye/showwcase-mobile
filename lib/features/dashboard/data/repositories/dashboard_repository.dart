import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/features/dashboard/data/models/dashboard_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';


class DashboardRepository   {

  final NetworkProvider networkProvider ;

  DashboardRepository(this.networkProvider);

  Future<Either<ApiError, DashboardModel>> getDashboardStat({required int? startDate,required int? endDate})async {
    try {
      final path = ApiConfig.fetchDashboardStat(endDate:endDate ,startDate: startDate);
      var response = await networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final dashboardResponse =  DashboardModel.fromJson(response.data);
        return Right(dashboardResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<ShowModel>>> getDashboardShows({int limit = 25, int skip = 0})async {
    try {
      final path = ApiConfig.fetchDashboardShows(skip: skip, limit: limit);
      var response = await networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final List<ShowModel> showsResponse = List<ShowModel>.from(response.data.map((x) => ShowModel.fromJson(x)));
        return Right(showsResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<ThreadModel>>> getDashboardThreads({int limit = 25, int skip = 0}) async{
    try {
      final path = ApiConfig.fetchDashboardThreads(skip: skip, limit: limit);
      var response = await networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final List<ThreadModel> threadsResponse = List<ThreadModel>.from(response.data.map((x) => ThreadModel.fromJson(x)));
        return Right(threadsResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

}