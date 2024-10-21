import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';

class ExploreRepository {
  final NetworkProvider networkProvider;
  ExploreRepository(this.networkProvider);

  Future<Either<ApiError, List<ShowModel>>> fetchTrendingShows() async {
    try {
      final path = ApiConfig.topShows(limit: 5);

      var response = await networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final topResponse = List<ShowModel>.from(
            response.data.map((x) => ShowModel.fromJson(x)));

        return Right(topResponse);

      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }
}