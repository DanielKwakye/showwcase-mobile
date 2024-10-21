import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_cubit.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_enums.dart';
import 'package:showwcase_v3/features/notifications/data/models/notification_model.dart';

class NotificationCommunityCubit extends NotificationCubit {

  NotificationCommunityCubit( {required super.notificationRepository});




  Future<Either<String, List<NotificationModel>>> fetchCommunityNotifications(int pageKey) async {


    const List<String> types = [
      'new_community_member',
      'community_role_changed',
      'community_invite',
      'community_ownership_transfer',
      'new_thread',
      'new_reply',
      'thread_mention',
      'new_thread_upvote',
      'new_poll_vote',
      'community_approved',
    ];

    final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey;  // even if previous page returned items less than defaultPageSize, still skip by defaultPageSize
    final queryParams = <String, dynamic>{'limit' : defaultPageSize , 'skip': skip};

    queryParams.addAll({'type': types});

    // supported notifications

    final notificationTypes = NotificationTypes.values.map((e) => camelCaseToSnakeCase(camelCase: e.name)).toList();
    queryParams.addAll({
      "supported_notification_types" : notificationTypes
    });

    final either =  await super.fetchNotifications(pageKey: pageKey, queryParams: queryParams);
    if(either.isRight()) {
      final r = either.asRight();
      final communityNotifications = r.where((x) => x.data?.thread?.community != null || x.data?.community != null ).toList();
      return Right(communityNotifications);
    }

    return Left(either.asLeft());

  }
}