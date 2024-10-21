import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_enums.dart';
import 'package:showwcase_v3/features/notifications/data/models/notification_model.dart';

class NotificationRepository {

  final supportedNotificationTypes = NotificationTypes.values.map((e) => camelCaseToSnakeCase(camelCase: e.name)).toList();
  final NetworkProvider networkProvider;
  NotificationRepository(this.networkProvider);


  Future<Either<ApiError, List<NotificationModel>>> fetchNotifications({required Map<String, dynamic> queryParams}) async {
    try {

      String path = ApiConfig.notifications;

      var response = await networkProvider.call(
          path: path, method: RequestMethod.get,
          queryParams: queryParams
      );

      if (response!.statusCode == 200) {
        final data = response.data as List<dynamic>;
        final filteredNotifications = data.where((e) {
          final map = e as Map<String, dynamic>;
          final notificationType = map['type'] as String;
          return supportedNotificationTypes.contains(notificationType);
        });
        final notificationsResponse = List<NotificationModel>.from(filteredNotifications.map((x) => NotificationModel.fromJson(x)));

        return Right(notificationsResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }  catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, int>> getNotificationTotal() async {
    try {
      String path = ApiConfig.fetchNotificationTotal;
      var response = await networkProvider.call(path: path, method: RequestMethod.get);

      if (response!.statusCode == 200) {
        return Right((response.data is int) ? response.data : 0);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioException catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, void>> markAsRead() async {
    try {
      String path = ApiConfig.notifications;
      var response = await networkProvider.call(path: path, method: RequestMethod.put);

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