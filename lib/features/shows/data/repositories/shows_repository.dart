import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/features/shows/data/models/show_category_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_comment_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class ShowsRepository {

  final NetworkProvider _networkProvider;
  ShowsRepository(this._networkProvider);

  Future<Either<ApiError, List<ShowCategoryModel>>> fetchShowCategories() async {
    try {

      String path = ApiConfig.showCategories;

      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.get
      );

      if (response!.statusCode == 200) {
        final showsCategoriesResponse = List<ShowCategoryModel>.from(response.data.map((x) => ShowCategoryModel.fromJson(x)));
        return Right(showsCategoriesResponse);

      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }

    }catch(e){
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, ShowModel>> getShowFromId({required int showId}) async {
    try{

      final path = ApiConfig.fetchShowPreview(showId: showId);
      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final showsResponse = ShowModel.fromJson(response.data);
        return Right(showsResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }


    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }


  Future<Either<ApiError, List<ShowModel>>> fetchShows({required String path, Map<String, dynamic> queryParams = const {}}) async {
    // categories = blog, product, git, video, podcast, event
    try {
      // final path = ApiConfig.fetchShows(limit: limit, skip: skip, type: type, category: category, currentProjectId: currentProjectId);

      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.get,
          queryParams: queryParams
      );

      if (response!.statusCode == 200) {
        final showsResponse = List<ShowModel>.from(response.data.map((x) => ShowModel.fromJson(x))).whereNot((element) => element.id == null).toList();
        return Right(showsResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, ShowModel>> fetchShowPreview({required int showId, String? slug}) async {
    try{

      final path = ApiConfig.fetchShowPreview(showId: showId);
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

  Future<Either<ApiError, bool>> reportShow({required String message, required int projectId}) async {
    try {
      var response = await _networkProvider.call(
          path: ApiConfig.complaints,
          method: RequestMethod.post,
          body: {
            "message": message,
            "projectId": projectId
          });
      if (response!.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(ApiError(errorDescription: response.data['error'] ?? "Unable to submit report"));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, void>> bookmarkShow(
      {required int showId, required bool isBookmark}) async {

    try {
      String path = ApiConfig.bookmark;

      var response = await _networkProvider.call(
          path: path, method: isBookmark ? RequestMethod.post : RequestMethod.delete,
          body: {'projectId': showId});

      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, void>> upvoteShow({required int showId, required String actionType})
  async {

    try {
      final path = ApiConfig.upvote(actionType: actionType);
      var response = await _networkProvider.call(path: path, method: RequestMethod.post,
          body: {"projectId": showId}
      );
      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, List<UserModel>>> fetchShowUpVoters({required int showId, int limit = 25, int skip = 0}) async {
    try{

      final path = ApiConfig.fetchShowUpVoters(showId: showId, limit: limit, skip: skip);
      var response = await _networkProvider.call(path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        List<UserModel> users = List<UserModel>.from(response.data.map((x) => UserModel.fromJson(x)));
        return Right(users);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }

    }on DioException catch(e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, ShowCommentModel>> createShowComment({required String message, required int projectId, int? parentId}) async {
    try {

      String path = ApiConfig.createComment;
      final body = {
        "message": message,
        "projectId": projectId,
        "parentId": parentId
      };

      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.post,
          body: body
      );

      if (response!.statusCode == 200) {
        final createCommentResponse = ShowCommentModel.fromJson(response.data);
        return Right(createCommentResponse);

      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioException catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, void>> upvoteComment({required int commentId, required String actionType}) async {
    try {
      final path = ApiConfig.upvote(actionType: actionType);
      var response = await _networkProvider.call(path: path, method: RequestMethod.post,
          body: {"commentId": commentId}
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

  Future<Either<ApiError, void>> deleteShowComment({required int commentId}) async {
    try {
      final path =  ApiConfig.deleteComment(commentId);
      var response = await _networkProvider.call(path: path, method: RequestMethod.delete);
      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioException catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, void>> updateShowComment({required ShowCommentModel updatedComment}) async {
    try {
      final path = ApiConfig.updateComment(updatedComment.id!);
      final body = updatedComment.toJson();
      var response = await _networkProvider.call(path: path, method: RequestMethod.put,
          body: body
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

  Future<Either<ApiError, List<ShowCommentModel>>> fetchShowComments({required int showId, int limit = 25, int skip = 0}) async {

    try{

      final path = ApiConfig.fetchShowComments(limit: limit, skip: skip, showId: showId);
      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.get
      );

      if (response!.statusCode == 200) {

        final responseList = List<ShowCommentModel>.from(response.data.map((x) => ShowCommentModel.fromJson(x)));
        return Right(responseList);

      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }

    } on DioException catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }


}