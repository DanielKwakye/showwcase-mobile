import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_comment_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';

part 'notification_data_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NotificationDataModel {
  
  const NotificationDataModel({
    
    this.threadId,
    this.projectId,
    this.project,
    this.thread,
    this.parentId,
    this.message,
    this.reply,
    this.reason,
    this.note,
    this.community,
    this.comment

  });


  final int? threadId;
  final int? projectId;
  final ThreadModel? thread;
  final ShowModel? project;
  final int? parentId;
  final String? message;
  final ThreadModel? reply;
  final String? reason;
  final String? note;
  final CommunityModel? community;
  final ShowCommentModel? comment;

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) => NotificationDataModel(
    threadId: json["threadId"] is int ? json["threadId"] : int.tryParse(json["threadId"] ?? ''),
    projectId: json["projectId"],
    thread: json["thread"] == null ? null : ThreadModel.fromJson(json["thread"]),
    community: json["community"] == null ? null : CommunityModel.fromJson(json["community"]),
    project: json["project"] == null ? null : ShowModel.fromJson(json["project"]),
    parentId: json["parentId"],
    message: json["message"] is int ? json["message"].toString() : json["message"],
    reason:json["reason"].toString(),
    note:json["note"].toString(),
    reply: json["reply"] == null ? null : ThreadModel.fromJson(json["reply"]),
    comment: json["comment"] == null ? null : ShowCommentModel.fromJson(json["comment"]),
  );
  Map<String, dynamic> toJson() => _$NotificationDataModelToJson(this);
  
}