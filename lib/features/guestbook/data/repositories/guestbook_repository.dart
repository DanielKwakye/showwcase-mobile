
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/features/guestbook/data/models/create_guestbook_model.dart';
import 'package:showwcase_v3/features/guestbook/data/models/guestbook_model.dart';

class GuestBookRepository {
  final NetworkProvider networkProvider;

  GuestBookRepository(this.networkProvider);

  Future<Either<ApiError, void>> deleteGuestbook({required String userName, required int guestBookId}) async{

    try {
      final path = ApiConfig.editAndDeleteGuestbook( userName: userName, guestBookID: guestBookId);
      var response = await networkProvider.call(path: path, method: RequestMethod.delete,);
      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, CreateGuestbookModel>> editGuestbook({required String userName, required String message, required int guestBookId}) async{

    try {
      final path = ApiConfig.editAndDeleteGuestbook( userName: userName, guestBookID: guestBookId);
      var response = await networkProvider.call(path: path, method: RequestMethod.put, body: {"message": message});
      if (response!.statusCode == 200) {
        final likeResponse = CreateGuestbookModel.fromJson(response.data);
        return Right(likeResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<GuestBookModel>>> fetchProfileGuestbook({int limit = 25, int skip = 0, required String userName}) async{
    try {
      final path = ApiConfig.fetchProfileGuestbook(limit: limit, skip: skip, userName: userName);
      var response = await networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final guestBookResponse = List<GuestBookModel>.from(response.data.map((x) => GuestBookModel.fromJson(x)));
        return Right(guestBookResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, CreateGuestbookModel>> createGuestbook({required String userName,required String message}) async{
    try {
      final path = ApiConfig.createGuestbook( userName: userName);
      var response = await networkProvider.call(path: path, method: RequestMethod.post,
          body: {"message": message}
      );
      if (response!.statusCode == 200) {
        final likeResponse = CreateGuestbookModel.fromJson(response.data);
        return Right(likeResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }
}