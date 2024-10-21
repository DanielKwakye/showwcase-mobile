 import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_enums.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_state.dart';
import 'package:showwcase_v3/features/notifications/data/models/notification_model.dart';
import 'package:showwcase_v3/features/notifications/repositories/notification_repository.dart';

class NotificationCubit extends Cubit<NotificationState> {

  final NotificationRepository notificationRepository;
  NotificationCubit({required this. notificationRepository}): super (const NotificationState());


  Future<Either<String, List<NotificationModel>>> fetchNotifications({required int pageKey, required  Map<String, dynamic> queryParams}) async {
    try {

      emit(state.copyWith(status: NotificationStatus.fetchNotificationsInProgress));
      final either = await notificationRepository.fetchNotifications(queryParams: queryParams);

      if(either.isLeft()) {
        final l = either.asLeft();
        emit(state.copyWith(status: NotificationStatus.fetchNotificationsFailed, message: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful
      List<NotificationModel> r = either.asRight();
      final List<NotificationModel> notifications = [...state.notifications];
      if(pageKey == 0){
        // if its first page request remove all existing threads
        notifications.clear();
      }

      notifications.addAll(r);

      emit(state.copyWith(
        status: NotificationStatus.fetchNotificationsSuccessful,
        notifications: notifications,
      ));

      return Right(r);


    }catch(e) {
      debugPrint(e.toString());
      emit(state.copyWith(status: NotificationStatus.fetchNotificationsFailed, message: e.toString()));
      return Left(e.toString());
    }
  }

  Future<void> markNotificationAsRead() async {

    try {

      emit(state.copyWith(status: NotificationStatus.markNotificationAsReadInProgress));
      final either = await notificationRepository.markAsRead();

      either.fold(
              (l) =>  emit(state.copyWith(status: NotificationStatus.markNotificationAsReadFailed, message: l.errorDescription)),

              (r) => emit(state.copyWith(status: NotificationStatus.markNotificationAsReadSuccessful, total: 0))
      );


    }catch(e) {
      emit(state.copyWith(status: NotificationStatus.markNotificationAsReadFailed, message: e.toString()));
    }


  }

  void fetchNotificationTotal() async {

    try {
      emit(state.copyWith(status: NotificationStatus.fetchingNotificationTotal));

      final either = await notificationRepository.getNotificationTotal();

      either.fold(
              (l) =>  emit(state.copyWith(
              status: NotificationStatus.fetchingNotificationTotalError,
              message: l.errorDescription
          )),
              (r) => emit(state.copyWith(
              status: NotificationStatus.fetchingNotificationTotalSuccessful,
              total: r
          ))
      );

    }catch(e) {
      emit(state.copyWith(
          status: NotificationStatus.fetchingNotificationTotalError,
          message: e.toString()
      ));
    }

  }


}