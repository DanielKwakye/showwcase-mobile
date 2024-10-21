import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_enums.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_editor_request.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_voter_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class ThreadRepository {
  final NetworkProvider _networkProvider;
  ThreadRepository(this._networkProvider);

  Future<Either<ApiError, List<ThreadModel>>> fetchThreads({required String path}) async {
    try {

      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final List<ThreadModel> threadsResponse = List<ThreadModel>.from(response.data.map((x) {
          return ThreadModel.fromJson(x);
        })).map((item) {

          ThreadModel threadItem = item;
          if((item.isAnonymous ?? false) && item.user?.username == null){
            threadItem = threadItem.copyWith(
                user: const UserModel(
                    id: anonymousPostUserId,
                    username: "Community Member",
                    profileCoverImageKey: anonymousPostUserImage
                )
            );
          }
          return threadItem;

        }).where((item) {
          if(item.user?.id == null || item.user?.username == null) {
            return false;
          }
          if(item.message == "[Message has been deleted]") {
            return false;
          }
          return true;
        }).toList();
        return Right(threadsResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }  catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, ThreadModel>> fetchThreadFromId({required int threadId}) async {
    try {
      final path = ApiConfig.fetchThreadPreview(threadId: threadId);
      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final thread = ThreadModel.fromJson(response.data);
        return Right(thread);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }  catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<ThreadModel>>> fetchThreadComments({required int? threadId, int? limit, int? skip}) async {

    try {

      final response = await _networkProvider.call(path: ApiConfig.threadComments(threadId: threadId, limit: limit, skip: skip), method: RequestMethod.get);

      if (response!.statusCode == 200) {
        List<ThreadModel> threadsResponseList = List<ThreadModel>.from(
            response.data.map((x) => ThreadModel.fromJson(x))).where((item) {
          if(item.user?.id == null || item.user?.username == null) {
            return false;
          }
          if(item.message == "[Message has been deleted]") {
            return false;
          }
          return true;
        }).toList();
        return Right(threadsResponseList);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<ThreadModel>>> fetchThreadCommentReplies({required int? commentId, int? limit, int? skip}) async {

    try {

      final response = await _networkProvider.call(path: ApiConfig.threadCommentReplies(commentId: commentId, limit: limit, skip: skip), method: RequestMethod.get);

      if (response!.statusCode == 200) {
        List<ThreadModel> threadsResponseList = List<ThreadModel>.from(response.data.map((x) => ThreadModel.fromJson(x))).where((item) {
          if(item.user?.id == null || item.user?.username == null) {
            return false;
          }
          if(item.message == "[Message has been deleted]") {
            return false;
          }
          return true;
        }).toList();
        return Right(threadsResponseList);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioException catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }




  Future<Either<ApiError, void>> boostThread({required int threadId, required BoostActionType actionType}) async {

    try {

      var response = await _networkProvider.call(
          path: ApiConfig.boostThread(threadId: threadId, actionType: actionType.name),
          method: RequestMethod.post);
      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }

    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }


  Future<Either<ApiError, void>> upvoteThread(
      {required int threadId, required UpvoteActionType actionType}) async {

    try {
      var response = await _networkProvider.call(
          path: ApiConfig.upvote(actionType: actionType.name),
          method: RequestMethod.post,
          body: {"threadId": threadId});
      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }


  Future<Either<ApiError, void>> bookmarkThread(
      {required int threadId, required bool isBookmark}) async {

    try {
      var response = await _networkProvider.call(
          path: ApiConfig.bookmark,
          method: isBookmark ? RequestMethod.post : RequestMethod.delete,
          body: {'threadId': threadId});
      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }  catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, void>> votePoll({required int? threadId, int? pollId, int? optionId}) async {

    try {
      var response = await _networkProvider.call(
          path: ApiConfig.votePoll(threadId: threadId),
          method: RequestMethod.post,
          body: {
            "threadId": threadId,
            "pollId": pollId,
            "optionId": optionId,
          });
      if (response!.statusCode == 200) {

        return const Right(null);

      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, List<ThreadVoterModel>>> fetchPollVoters({required int? threadId, int? pollId, int limit = 25, int skip = 0}) async {
    try{

      final path = ApiConfig.fetchThreadPollVoters(threadId: threadId, limit: limit, skip: skip, pollId: pollId);
      var response = await _networkProvider.call(path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final List<dynamic> data = response.data;
        final voters = data.map((x) => ThreadVoterModel.fromJson(x)).toList();
        return Right(voters);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }

    }on DioError catch(e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, List<UserModel>>> fetchUpVoters({required int threadId, int limit = 25, int skip = 0}) async {
    try{

      final path = ApiConfig.fetchThreadUpVoters(threadId: threadId, limit: limit, skip: skip);
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

  Future<Either<ApiError, void>> reportThread({required String message, required threadId}) async {
    try {
      var response = await _networkProvider.call(
          path: ApiConfig.complaints,
          method: RequestMethod.post,
          body: {
            "message": message,
            "threadId": threadId,
          });
      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error'] ?? "Unable to submit report"));
      }
    } on DioException catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, String>> deleteThread({required int threadId}) async {
    try {
      var response = await _networkProvider.call(
          path: ApiConfig.deleteThread(threadId: threadId),
          method: RequestMethod.delete);
      if (response!.statusCode == 200) {
        final responseData = response.data;
        return Right(responseData.toString());
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, ThreadModel>> createOrReplyThread({required ThreadEditorRequest createThreadRequest}) async {

    try {
      final body = createThreadRequest.toJson();

      var response = await _networkProvider.call(
          path: ApiConfig.createThreads,
          method: RequestMethod.post,
          body: body
      );

      if (response!.statusCode == 200) {
        ThreadModel threadsResponse = ThreadModel.fromJson(response.data);
        return Right(threadsResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioException catch (e) {
      return Left(ApiError(errorDescription:  e.toString()));
    }

  }

  Future<Either<ApiError, ThreadModel>> editThread({int? threadId, required ThreadEditorRequest createThreadRequest}) async {

    try {


      final path = ApiConfig.editThread(threadId: threadId);
      final body = createThreadRequest.toJson();

      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.put,
          body: body
      );

      if (response!.statusCode == 200) {
        ThreadModel threadResponse = ThreadModel.fromJson(response.data);
        return Right(threadResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioException catch (e) {
      return Left(ApiError(errorDescription:  e.toString()));
    }

  }

}