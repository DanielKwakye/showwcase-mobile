// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesModel _$SeriesModelFromJson(Map<String, dynamic> json) => SeriesModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      title: json['title'] as String?,
      slug: json['slug'] as String?,
      coverImageKey: json['coverImageKey'] as String?,
      seo: json['seo'] == null
          ? null
          : SeriesSeoModel.fromJson(json['seo'] as Map<String, dynamic>),
      settings: json['settings'] == null
          ? null
          : SeriesSettingsModel.fromJson(
              json['settings'] as Map<String, dynamic>),
      summary: json['summary'] as String?,
      description: json['description'] as String?,
      difficulty: json['difficulty'] as String?,
      status: json['status'] as String?,
      publishedDate: json['publishedDate'] == null
          ? null
          : DateTime.parse(json['publishedDate'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => SeriesCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      projects: (json['projects'] as List<dynamic>?)
          ?.map((e) => ShowModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviews: json['reviews'] == null
          ? null
          : SeriesReviewStatsModel.fromJson(
              json['reviews'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SeriesModelToJson(SeriesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'slug': instance.slug,
      'coverImageKey': instance.coverImageKey,
      'seo': instance.seo?.toJson(),
      'settings': instance.settings?.toJson(),
      'summary': instance.summary,
      'description': instance.description,
      'difficulty': instance.difficulty,
      'status': instance.status,
      'publishedDate': instance.publishedDate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'categories': instance.categories?.map((e) => e.toJson()).toList(),
      'projects': instance.projects?.map((e) => e.toJson()).toList(),
      'reviews': instance.reviews?.toJson(),
      'user': instance.user?.toJson(),
    };
