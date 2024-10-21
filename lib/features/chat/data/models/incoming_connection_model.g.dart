// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_connection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomingConnectionModel _$IncomingConnectionModelFromJson(
        Map<String, dynamic> json) =>
    IncomingConnectionModel(
      chatId: json['chatId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      totalUnreadMessages: json['totalUnreadMessages'] as int?,
      message: json['message'] == null
          ? null
          : ChatMessageModel.fromJson(json['message'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IncomingConnectionModelToJson(
        IncomingConnectionModel instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'totalUnreadMessages': instance.totalUnreadMessages,
      'message': instance.message?.toJson(),
      'user': instance.user?.toJson(),
    };
