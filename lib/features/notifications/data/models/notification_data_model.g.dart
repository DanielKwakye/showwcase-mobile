// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationDataModel _$NotificationDataModelFromJson(
        Map<String, dynamic> json) =>
    NotificationDataModel(
      threadId: json['threadId'] as int?,
      projectId: json['projectId'] as int?,
      project: json['project'] == null
          ? null
          : ShowModel.fromJson(json['project'] as Map<String, dynamic>),
      thread: json['thread'] == null
          ? null
          : ThreadModel.fromJson(json['thread'] as Map<String, dynamic>),
      parentId: json['parentId'] as int?,
      message: json['message'] as String?,
      reply: json['reply'] == null
          ? null
          : ThreadModel.fromJson(json['reply'] as Map<String, dynamic>),
      reason: json['reason'] as String?,
      note: json['note'] as String?,
      community: json['community'] == null
          ? null
          : CommunityModel.fromJson(json['community'] as Map<String, dynamic>),
      comment: json['comment'] == null
          ? null
          : ShowCommentModel.fromJson(json['comment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationDataModelToJson(
        NotificationDataModel instance) =>
    <String, dynamic>{
      'threadId': instance.threadId,
      'projectId': instance.projectId,
      'thread': instance.thread?.toJson(),
      'project': instance.project?.toJson(),
      'parentId': instance.parentId,
      'message': instance.message,
      'reply': instance.reply?.toJson(),
      'reason': instance.reason,
      'note': instance.note,
      'community': instance.community?.toJson(),
      'comment': instance.comment?.toJson(),
    };
