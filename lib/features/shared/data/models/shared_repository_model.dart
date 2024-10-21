import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_permission_model.dart';

part 'shared_repository_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SharedRepositoryModel {
  const SharedRepositoryModel({
    this.license,
    this.languages,
    this.permissions,
    this.id,
    this.githubRepoId,
    this.name,
    this.private,
    this.htmlUrl,
    this.description,
    this.fork,
    this.repoCreatedAt,
    this.repoUpdatedAt,
    this.size,
    this.stargazerCount,
    this.watchersCount,
    this.language,
    this.archived,
    this.disabled,
    this.homepage,
    this.apiUrl,
    this.forks,
    this.userId,
    this.pinned,
    this.createdAt,
    this.updatedAt,
  });

  final dynamic license;
  final Map<String, dynamic>? languages;
  final SharedPermissionsModel? permissions;
  final int? id;
  final int? githubRepoId;
  final String? name;
  final bool? private;
  final String? htmlUrl;
  final dynamic description;
  final dynamic fork;
  final DateTime? repoCreatedAt;
  final DateTime? repoUpdatedAt;
  final int? size;
  final int? stargazerCount;
  final int? watchersCount;
  final String? language;
  final bool? archived;
  final bool? disabled;
  final dynamic homepage;
  final String? apiUrl;
  final int? forks;
  final int? userId;
  final bool? pinned;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory SharedRepositoryModel.fromJson(Map<String, dynamic> json) => _$SharedRepositoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$SharedRepositoryModelToJson(this);
  
}
