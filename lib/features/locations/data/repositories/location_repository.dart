import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';

class LocationRepository {

  final NetworkProvider _networkProvider;
  LocationRepository(this._networkProvider);

  Future<Either<ApiError, List<String>?>> searchLocations({required String keyword}) async {

    try{
      var response = await _networkProvider.call(path: ApiConfig.fetchCitySuggestion(keyword), method: RequestMethod.get);
      if(response!.statusCode == 200){
        final cities =  List<String>.from(response.data.map((x) => x));
        return Right(cities);
      }else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch(e){
      return Left(ApiError(errorDescription: e.toString()));
    }

  }


}