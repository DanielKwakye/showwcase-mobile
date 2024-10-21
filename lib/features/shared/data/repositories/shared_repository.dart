import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_link_preview_meta_model.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_social_link_model.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_twitter_model.dart';


class SharedRepository {

  final NetworkProvider _networkProvider;
  const SharedRepository(this._networkProvider);

  Future<Either<ApiError, List<SharedSocialLinkIconModel>>> fetchSocialLinkIcons() async {
    try{
      var response = await _networkProvider.call(path: ApiConfig.socials, method: RequestMethod.get);
      if (response!.statusCode == 200){
        final List<SharedSocialLinkIconModel> socialListResponse  = List<SharedSocialLinkIconModel>.from(response.data.map((x) => SharedSocialLinkIconModel.fromJson(x)));
        return Right(socialListResponse);
      }else{
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }on DioError catch(e){
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, SharedTwitterModel>> fetchTwitterDetails({required String tweetId}) async {
    try{
      final path = ApiConfig.fetchTwitterDetails(tweetId: tweetId);
      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.get
      );

      if (response!.statusCode == 200) {
        final twitterResponse = SharedTwitterModel.fromJson(response.data);
        return Right(twitterResponse);
      } else {
        return Left(ApiError(errorDescription: "Unable to fetch twitter block"));
      }

    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, SharedLinkPreviewMetaModel>> fetchPreviewMetaDataFromUrl({required String url}) async {
    try {
      final path = ApiConfig.fetchUrlMeta(url);
      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        if(response.data['error'] != null) {
          return Left(ApiError(errorDescription: 'Preview not found'));
        }
        final linkPreviewMetaData = SharedLinkPreviewMetaModel.fromJson(response.data);
        return Right(linkPreviewMetaData);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }   on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

}