// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_notifications_totals_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatNotificationsTotalModel _$ChatNotificationsTotalModelFromJson(
        Map<String, dynamic> json) =>
    ChatNotificationsTotalModel(
      totalUnreadMessages: json['totalUnreadMessages'] as int? ?? 0,
      totalPendingRequests: json['totalPendingRequests'] as int? ?? 0,
      totalUnreadChats: json['totalUnreadChats'] as int? ?? 0,
    );

Map<String, dynamic> _$ChatNotificationsTotalModelToJson(
        ChatNotificationsTotalModel instance) =>
    <String, dynamic>{
      'totalUnreadMessages': instance.totalUnreadMessages,
      'totalPendingRequests': instance.totalPendingRequests,
      'totalUnreadChats': instance.totalUnreadChats,
    };
