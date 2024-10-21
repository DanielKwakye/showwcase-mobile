// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_repository_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedRepositoryModel _$SharedRepositoryModelFromJson(
        Map<String, dynamic> json) =>
    SharedRepositoryModel(
      license: json['license'],
      languages: json['languages'] as Map<String, dynamic>?,
      permissions: json['permissions'] == null
          ? null
          : SharedPermissionsModel.fromJson(
              json['permissions'] as Map<String, dynamic>),
      id: json['id'] as int?,
      githubRepoId: json['githubRepoId'] as int?,
      name: json['name'] as String?,
      private: json['private'] as bool?,
      htmlUrl: json['htmlUrl'] as String?,
      description: json['description'],
      fork: json['fork'],
      repoCreatedAt: json['repoCreatedAt'] == null
          ? null
          : DateTime.parse(json['repoCreatedAt'] as String),
      repoUpdatedAt: json['repoUpdatedAt'] == null
          ? null
          : DateTime.parse(json['repoUpdatedAt'] as String),
      size: json['size'] as int?,
      stargazerCount: json['stargazerCount'] as int?,
      watchersCount: json['watchersCount'] as int?,
      language: json['language'] as String?,
      archived: json['archived'] as bool?,
      disabled: json['disabled'] as bool?,
      homepage: json['homepage'],
      apiUrl: json['apiUrl'] as String?,
      forks: json['forks'] as int?,
      userId: json['userId'] as int?,
      pinned: json['pinned'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SharedRepositoryModelToJson(
        SharedRepositoryModel instance) =>
    <String, dynamic>{
      'license': instance.license,
      'languages': instance.languages,
      'permissions': instance.permissions?.toJson(),
      'id': instance.id,
      'githubRepoId': instance.githubRepoId,
      'name': instance.name,
      'private': instance.private,
      'htmlUrl': instance.htmlUrl,
      'description': instance.description,
      'fork': instance.fork,
      'repoCreatedAt': instance.repoCreatedAt?.toIso8601String(),
      'repoUpdatedAt': instance.repoUpdatedAt?.toIso8601String(),
      'size': instance.size,
      'stargazerCount': instance.stargazerCount,
      'watchersCount': instance.watchersCount,
      'language': instance.language,
      'archived': instance.archived,
      'disabled': instance.disabled,
      'homepage': instance.homepage,
      'apiUrl': instance.apiUrl,
      'forks': instance.forks,
      'userId': instance.userId,
      'pinned': instance.pinned,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
