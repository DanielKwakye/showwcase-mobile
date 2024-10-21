// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoadmapModel _$RoadmapModelFromJson(Map<String, dynamic> json) => RoadmapModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      slug: json['slug'] as String?,
      color: json['color'] as String?,
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      numberOfShowsInRoadmap: json['numberOfShowsInRoadmap'] as num?,
      numberOfUserCompletedShows: json['numberOfUserCompletedShows'] as num?,
      userReadPercentage: json['userReadPercentage'] as num?,
      numberOfPendingShowsInArchive:
          json['numberOfPendingShowsInArchive'] as num?,
      numberOfApprovedShowsInArchive:
          json['numberOfApprovedShowsInArchive'] as num?,
      comingSoon: json['comingSoon'] as bool? ?? false,
      readingStats: json['readingStats'] == null
          ? null
          : RoadMapReadingStatsModel.fromJson(
              json['readingStats'] as Map<String, dynamic>),
      info: json['info'] == null
          ? null
          : RoadmapInfoModel.fromJson(json['info'] as Map<String, dynamic>),
      about: json['about'] as String?,
    );

Map<String, dynamic> _$RoadmapModelToJson(RoadmapModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'slug': instance.slug,
      'color': instance.color,
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'user': instance.user,
      'info': instance.info,
      'about': instance.about,
      'readingStats': instance.readingStats,
      'numberOfShowsInRoadmap': instance.numberOfShowsInRoadmap,
      'numberOfUserCompletedShows': instance.numberOfUserCompletedShows,
      'userReadPercentage': instance.userReadPercentage,
      'numberOfPendingShowsInArchive': instance.numberOfPendingShowsInArchive,
      'numberOfApprovedShowsInArchive': instance.numberOfApprovedShowsInArchive,
      'comingSoon': instance.comingSoon,
    };
