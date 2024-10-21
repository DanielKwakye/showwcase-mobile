// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopSearchModel _$TopSearchModelFromJson(Map<String, dynamic> json) =>
    TopSearchModel(
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      projects: (json['projects'] as List<dynamic>?)
              ?.map((e) => ShowModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      threads: (json['threads'] as List<dynamic>?)
              ?.map((e) => ThreadModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      communities: (json['communities'] as List<dynamic>?)
              ?.map((e) => CommunityModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TopSearchModelToJson(TopSearchModel instance) =>
    <String, dynamic>{
      'users': instance.users,
      'projects': instance.projects,
      'threads': instance.threads,
      'communities': instance.communities,
    };
