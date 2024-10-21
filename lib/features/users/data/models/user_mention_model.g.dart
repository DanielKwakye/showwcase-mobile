// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_mention_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMentionModel _$UserMentionModelFromJson(Map<String, dynamic> json) =>
    UserMentionModel(
      communityId: json['communityId'] as int?,
      slug: json['slug'] as String?,
      name: json['name'] as String?,
      username: json['username'] as String?,
      userId: json['userId'] as int?,
      currentUsername: json['currentUsername'] as String?,
      displayName: json['displayName'] as String?,
    );

Map<String, dynamic> _$UserMentionModelToJson(UserMentionModel instance) =>
    <String, dynamic>{
      'communityId': instance.communityId,
      'slug': instance.slug,
      'name': instance.name,
      'username': instance.username,
      'displayName': instance.displayName,
      'userId': instance.userId,
      'currentUsername': instance.currentUsername,
    };
