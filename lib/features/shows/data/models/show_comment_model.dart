import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/users/data/models/user_mention_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'show_comment_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class ShowCommentModel extends Equatable {
  
  const ShowCommentModel({
    this.id,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.totalUpvotes,
    this.totalReplies,
    this.mentions,
    this.user,
    this.replies,
    this.hasVoted,
    this.parentId,
    this.projectId
  });

  final int? id;
  final String? message;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? userId;
  final int? totalUpvotes;
  final int? totalReplies;
  final List<UserMentionModel>? mentions;
  final UserModel? user;
  final List<ShowCommentModel>? replies;
  final int? parentId;
  final int? projectId;
  final bool? hasVoted;

  factory ShowCommentModel.fromJson(Map<String, dynamic> json) => _$ShowCommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowCommentModelToJson(this);

  @override
  List<Object?> get props => [id, totalUpvotes, totalReplies, hasVoted, message, replies];
  
}