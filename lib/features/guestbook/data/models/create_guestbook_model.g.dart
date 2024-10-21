// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_guestbook_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateGuestbookModel _$CreateGuestbookModelFromJson(
        Map<String, dynamic> json) =>
    CreateGuestbookModel(
      id: json['id'] as int?,
      authorId: json['authorId'] as int?,
      userId: json['userId'] as int?,
      message: json['message'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CreateGuestbookModelToJson(
        CreateGuestbookModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'userId': instance.userId,
      'message': instance.message,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
