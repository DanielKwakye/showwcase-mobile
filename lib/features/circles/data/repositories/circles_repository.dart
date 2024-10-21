import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/features/circles/data/bloc/circles_enums.dart';
import 'package:showwcase_v3/features/circles/data/models/circle_reason_model.dart';
import 'package:showwcase_v3/features/circles/data/models/send_circle_model.dart';

class CirclesRepository {

  final NetworkProvider networkProvider;
  CirclesRepository(this.networkProvider);



  Future<Either<ApiError, void>> handleCircleInvite({int? userId, String? action}) async{

    try {

      final body = {
        "userId": userId,
        "action": action,
      };

      var response = await networkProvider.call(
          path: ApiConfig.sendCircleInvite,
          method:  RequestMethod.put,
          body:body
      );

      if (response!.statusCode == 200) {
        return const Right(null);

      } else {

        return Left(ApiError(errorDescription: response.data['error']));

      }
    } on DioException catch (e) {

      return Left(ApiError(errorDescription: e.toString()));

    }

  }

  Future<Either<ApiError, List<CircleReasonModel>>> fetchCircleReasons() async{
    try {

      var response = await networkProvider.call(
          path: ApiConfig.reasons,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final circleReasonResponse = List<CircleReasonModel>.from(
            response.data.map((x) => CircleReasonModel.fromJson(x)));

        return Right(circleReasonResponse);

      } else {

        return Left(ApiError(errorDescription: response.data['error']));

      }
    } on DioException catch (e) {

      return Left(ApiError(errorDescription: e.toString()));

    }

  }

  Future<Either<ApiError, void>> sendCircleInvite({required SendCircleModel sendCircleRequest, bool? isUpdate}) async{

    try {

      var response = await networkProvider.call(
          path: ApiConfig.sendCircleInvite,
          method: (isUpdate != null && isUpdate)  ? RequestMethod.put  : RequestMethod.post,
          body: sendCircleRequest.toJson()
      );

      if (response!.statusCode == 200) {
        return const Right(null);

      } else {

        return Left(ApiError(errorDescription: response.data['error']));

      }
    } on DioException catch (e) {

      return Left(ApiError(errorDescription: e.toString()));

    }
  }
  
}