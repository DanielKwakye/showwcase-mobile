import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_cubit.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_enums.dart';
import 'package:showwcase_v3/features/notifications/data/models/notification_model.dart';


class NotificationRequestsCubit extends NotificationCubit {

  NotificationRequestsCubit( {required super.notificationRepository});


  Future<Either<String, List<NotificationModel>>> fetchRequestNotifications(int pageKey) {


    const List<String> types = [
      'new_workedwith_invite',
      'new_project_workedwith_invite',
      'community_invite',
    ];

    final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey;  // even if previous page returned items less than defaultPageSize, still skip by defaultPageSize
    final queryParams = <String, dynamic>{'limit' : defaultPageSize , 'skip': skip};

    queryParams.addAll({'type': types});

    // supported notifications

    final notificationTypes = NotificationTypes.values.map((e) => e.name).toList();
    queryParams.addAll({
      "supported_notification_types" : notificationTypes
    });

    return super.fetchNotifications(pageKey: pageKey, queryParams: queryParams);

  }

}