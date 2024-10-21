import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_connection_model.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_message_model.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_notifications_totals_model.dart';
import 'package:showwcase_v3/features/chat/data/models/incoming_connection_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';


class ChatRepository {

  final NetworkProvider _networkProvider;
  ChatRepository(this._networkProvider);


  Future<Either<ApiError, List<UserModel>>> fetchSuggestedChatAccounts({required int userId})async {
    try {
      var response = await _networkProvider.call(
          path: ApiConfig.fetchFollowing(userId: userId, limit: 20, skip: 0),
          method: RequestMethod.get);

        if (response!.statusCode == 200) {
          final networkResponseList = List<UserModel>.from(response.data.map((x) => UserModel.fromJson(x)));
          return Right(networkResponseList);
        }

        return Left(ApiError(errorDescription: response.data['error']));

    }  catch (e) {
      return Left(ApiError(errorDescription:  e.toString()));
    }

  }

  Future<Either<ApiError, List<UserModel>>> searchPeopleToChat({required String text, int limit = 25, int skip = 0}) async {

    try {
      final path = ApiConfig.search(limit: limit, skip: skip, type: 'users', text: text);

      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final userResponse = List<UserModel>.from(
            response.data.map((x) => UserModel.fromJson(x)));
        return Right(userResponse);


      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, ChatConnectionModel>> requestConnectionWithRecipient({required int recipientUserId})async {
    try {
      var response = await _networkProvider.call(
          path: ApiConfig.requestConnectionWithRecipient,
          method: RequestMethod.post,
          body: {
            'userId': recipientUserId
          }
      );

      if (response!.statusCode == 200) {
        final chatConnectionModel = ChatConnectionModel.fromJson(response.data);
        return Right(chatConnectionModel);
      }

      return Left(ApiError(errorDescription: response.data['error']));

    } on DioError catch (e) {
      return Left(ApiError(errorDescription:  e.toString()));
    }

  }

  Future<Either<ApiError, List<ChatConnectionModel>>> fetchConnectedRecipients({required int limit, required int skip})async {
    try {

      final path = ApiConfig.fetchConnectedRecipients(limit: limit, skip: skip);
      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.get,
      );

      if (response!.statusCode == 200) {
        final currentUser = AppStorage.currentUserSession!;
        final chatConnectionResponseList = List<ChatConnectionModel>.from(response.data.map((x) => ChatConnectionModel.fromJson(x))).where((element) {
          final recipients = element.users?.where((user) => user.username != currentUser.username);
          return  (recipients ?? []).isNotEmpty;
        }).toList();
        return Right(chatConnectionResponseList);
      }

      return Left(ApiError(errorDescription: response.data['error']));

    } on DioError catch (e) {
      return Left(ApiError(errorDescription:  e.toString()));
    }

  }

  Future<Either<ApiError, ChatConnectionModel>> getConnectedRecipient({required String connectionId}) async {
    try {

      final path = ApiConfig.getConnectedRecipient(connectionId: connectionId);
      var response = await _networkProvider.call(
        path: path,
        method: RequestMethod.get,
      );

      if (response!.statusCode == 200) {
        // final currentUser = AppStorage.currentUserSession!;
        final connectedRecipient = ChatConnectionModel.fromJson(response.data);
        return Right(connectedRecipient);
      }

      return Left(ApiError(errorDescription: response.data['error']));

    }  catch (e) {
      return Left(ApiError(errorDescription:  e.toString()));
    }

  }

  Future<Either<ApiError, ChatMessageModel>> sendMessageToRecipient({required ChatMessageModel message})async {
    try {

      final path = ApiConfig.sendMessageToRecipient(chatId: message.chatId ?? '');

      final body =  {
        "id": message.id,
        "chatId" : message.chatId,
        "createdAt": message.createdAt!.toIso8601String(),
        "user": {
          "displayName": message.user!.displayName,
          "id" : message.user!.id,
          "profilePictureKey": message.user!.profilePictureKey,
          "username": message.user!.username,
        }
      };
      if(!message.text.isNullOrEmpty()) {
        body.putIfAbsent('text', () => message.text);
      }
      if(message.attachments != null && message.attachments!.isNotEmpty && message.attachments!.first.value != null) {
        body.putIfAbsent('imageUrl', () => message.attachments!.first.value);
        body.putIfAbsent('uploadImageUrl', () => message.attachments!.first.value);
      }
      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.post,
          body: body
      );

      if (response!.statusCode == 200) {
        final message = ChatMessageModel.fromJson(response.data);
        return Right(message);
      }

      return Left(ApiError(errorDescription: response.data['error']));

    } on DioError catch (e) {
      return Left(ApiError(errorDescription:  e.toString()));
    }

  }

  Future<Either<ApiError, List<ChatMessageModel>>> fetchChatMessages({required String connectionId})async {
    try {
      var response = await _networkProvider.call(
        path: ApiConfig.fetchChatMessages(chatId: connectionId),
        method: RequestMethod.get,
      );

      if (response!.statusCode == 200) {
        final chatMessages = List<ChatMessageModel>.from(response.data.map((x) => ChatMessageModel.fromJson(x)));
        return Right(chatMessages);
      }

      return Left(ApiError(errorDescription: response.data['error']));

    } on DioError catch (e) {
      return Left(ApiError(errorDescription:  e.toString()));
    }

  }

  Future<Either<ApiError, void>> markChatMessagesAsRead({required String connectionId})async {
    try {
      var response = await _networkProvider.call(
        path: ApiConfig.markChatMessagesAsRead(connectionId: connectionId),
        method: RequestMethod.post,
      );

      if (response!.statusCode == 200) {
        return const Right(null);
      }

      return Left(ApiError(errorDescription: response.data['error']));

    } on DioError catch (e) {
      return Left(ApiError(errorDescription:  e.toString()));
    }

  }


  Future<Either<ApiError, List<IncomingConnectionModel>>> fetchPendingConnections({required int limit, required int skip})async {
    try {
      var response = await _networkProvider.call(
        path: ApiConfig.fetchPendingConnections(limit: limit, skip: skip),
        method: RequestMethod.get,
      );

      if (response!.statusCode == 200) {
        final pendingConnectionList = List<IncomingConnectionModel>.from(response.data.map((x) => IncomingConnectionModel.fromJson(x)));
        return Right(pendingConnectionList);
      }

      return Left(ApiError(errorDescription: response.data['error']));

    } on DioError catch (e) {
      return Left(ApiError(errorDescription:  e.toString()));
    }

  }

  Future<Either<ApiError, List<IncomingConnectionModel>>> fetchRejectedConnections({required int limit, required int skip})async {
    try {
      var response = await _networkProvider.call(
        path: ApiConfig.fetchRejectedConnections(limit: limit, skip: skip),
        method: RequestMethod.get,
      );

      if (response!.statusCode == 200) {
        final pendingConnectionList = List<IncomingConnectionModel>.from(response.data.map((x) => IncomingConnectionModel.fromJson(x)));
        return Right(pendingConnectionList);
      }

      return Left(ApiError(errorDescription: response.data['error']));

    } on DioError catch (e) {
      return Left(ApiError(errorDescription:  e.toString()));
    }

  }

  Future<Either<ApiError, void>> acceptPendingConnections({required String connectionId}) async {
    try {
      var response = await _networkProvider.call(
        path: ApiConfig.acceptPendingConnection(connectionId: connectionId),
        method: RequestMethod.post,
      );

      if (response!.statusCode == 200) {
        return const Right(null);
      }

      return Left(ApiError(errorDescription: response.data['error']));
      // return const Right(null);

    } on DioError catch (e) {
      return Left(ApiError(errorDescription:  e.toString()));
    }

  }

  Future<Either<ApiError, void>> rejectPendingConnections({required String connectionId}) async {
    try {
      var response = await _networkProvider.call(
        path: ApiConfig.rejectPendingConnection(connectionId: connectionId),
        method: RequestMethod.post,
      );

      if (response!.statusCode == 200) {
        return const Right(null);
      }

      return Left(ApiError(errorDescription: response.data['error']));
      // return const Right(null);

    } on DioError catch (e) {
      return Left(ApiError(errorDescription:  e.toString()));
    }

  }

  Future<Either<ApiError, ChatNotificationsTotalModel>> fetchChatNotificationTotals() async {
    try {
      var response = await _networkProvider.call(
        path: ApiConfig.fetchChatNotificationTotals,
        method: RequestMethod.get,
      );

      if (response!.statusCode == 200) {
        return  Right(ChatNotificationsTotalModel.fromJson(response.data));
      }

      return Left(ApiError(errorDescription: response.data['error']));

    } on DioError catch (e) {
      return Left(ApiError(errorDescription:  e.toString()));
    }

  }

}