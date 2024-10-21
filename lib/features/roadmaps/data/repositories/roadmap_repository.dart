import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_model.dart';
import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_readers_model.dart';

class RoadmapRepository {

  final NetworkProvider _networkProvider;
  RoadmapRepository(this._networkProvider);

  Future<Either<ApiError, List<RoadmapModel>>> fetchRoadmaps() async{
    try {

      var response = await _networkProvider.call(
          path: ApiConfig.fetchRoadmaps,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final roadmapsResponse = List<RoadmapModel>.from(
            response.data.map((x) => RoadmapModel.fromJson(x)));
        return Right(roadmapsResponse);

      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }


  Future<Either<ApiError, RoadmapReadersModel>> fetchRoadmapReadersList({required int roadmapId, int limit = 3}) async{
    try {

      var response = await _networkProvider.call(
          path: ApiConfig.fetchRoadmapReadersList(roadmapId: roadmapId, limit: limit),
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final roadmapsResponse = RoadmapReadersModel.fromJson(response.data);
        return Right(roadmapsResponse);

      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, RoadmapModel>> fetchRoadmapsPreview({required int roadmapId}) async{
    try {

      var response = await _networkProvider.call(
          path: ApiConfig.fetchRoadmapPreview(roadmapId: roadmapId),
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final roadmapsResponse = RoadmapModel.fromJson(response.data);
        return Right(roadmapsResponse);

      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }


}

