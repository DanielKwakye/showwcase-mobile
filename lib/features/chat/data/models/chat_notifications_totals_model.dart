import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_notifications_totals_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChatNotificationsTotalModel extends Equatable {

  const ChatNotificationsTotalModel({
    this.totalUnreadMessages = 0,
    this.totalPendingRequests = 0,
    this.totalUnreadChats = 0,
  });

  final int totalUnreadMessages;
  final int totalPendingRequests;
  final int totalUnreadChats;

  @override
  List<int> get props => [totalUnreadMessages, totalPendingRequests, totalUnreadChats];

  /// Connect the generated [_$ChatNotificationsTotalModelFromJson] function to the `fromJson`
  /// factory.
  factory ChatNotificationsTotalModel.fromJson(Map<String, dynamic> json) => _$ChatNotificationsTotalModelFromJson(json);

  /// Connect the generated [_$ChatNotificationsTotalModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ChatNotificationsTotalModelToJson(this);

}