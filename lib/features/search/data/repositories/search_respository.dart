
import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/features/search/data/models/top_search_model.dart';

class SearchRepository {

  final NetworkProvider _networkProvider;
  SearchRepository(this._networkProvider);

  Future<Either<ApiError, TopSearchModel>> search({required String text, int limit = 25, int skip = 0}) async {
    try {
      final path = ApiConfig.search(limit: limit, skip: skip, type: 'top', text: text);

      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        // final topResponse = List<TopSearchResponse>.from(
        //     response.data.map((x) => TopSearchResponse.fromJson(x)));
        final topResponse = TopSearchModel.fromJson(response.data);
        return Right(topResponse);

      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

}