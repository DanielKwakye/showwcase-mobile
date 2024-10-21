import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_enums.dart';
import 'package:showwcase_v3/features/notifications/data/models/notification_data_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'notification_model.g.dart';

@CopyWith()
@JsonSerializable(explicitToJson: true)
class NotificationModel {

  final int? id;
  final NotificationTypes? type;
  final int? entityId;
  final NotificationDataModel? data;
  final DateTime? createdAt;
  final List<UserModel>? initiators;
  final int? totalInitiators;

  const NotificationModel({
      this.id,
      this.type,
      this.entityId,
      this.data,
      this.createdAt,
      this.initiators,
      this.totalInitiators
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

}