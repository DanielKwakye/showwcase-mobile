// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserActivityModel _$UserActivityModelFromJson(Map<String, dynamic> json) =>
    UserActivityModel(
      message: json['message'] as String?,
      emoji: json['emoji'] as String?,
    );

Map<String, dynamic> _$UserActivityModelToJson(UserActivityModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'emoji': instance.emoji,
    };
