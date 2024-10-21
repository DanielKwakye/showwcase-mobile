import 'package:json_annotation/json_annotation.dart';

part 'user_mention_model.g.dart';

@JsonSerializable(explicitToJson: true)

class UserMentionModel {
  const UserMentionModel({
    this.communityId,
    this.slug,
    this.name,
    this.username,
    this.userId,
    this.currentUsername,
    this.displayName,
  });

  final int? communityId;
  final String? slug;
  final String? name;
  final String? username;
  final String? displayName;
  final int? userId;
  final String? currentUsername;

  factory UserMentionModel.fromJson(Map<String, dynamic> json) => _$UserMentionModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserMentionModelToJson(this);

}