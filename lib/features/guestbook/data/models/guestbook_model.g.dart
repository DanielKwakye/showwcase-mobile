// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guestbook_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuestBookModel _$GuestBookModelFromJson(Map<String, dynamic> json) =>
    GuestBookModel(
      id: json['id'] as int?,
      message: json['message'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GuestBookModelToJson(GuestBookModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'user': instance.user?.toJson(),
    };
