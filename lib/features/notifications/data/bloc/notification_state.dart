import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_enums.dart';
import 'package:showwcase_v3/features/notifications/data/models/notification_model.dart';

part 'notification_state.g.dart';

@CopyWith()
class NotificationState extends Equatable {

  final NotificationStatus status;
  final String message;
  final int total;
  final List<NotificationModel> notifications;

  const NotificationState({
    this.message = '',
    this.status = NotificationStatus.initial,
    this.total = 0,
    this.notifications = const []
  });

  @override
  List<Object?> get props => [status, total];


}