// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_reviewer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesReviewerModel _$SeriesReviewerModelFromJson(Map<String, dynamic> json) =>
    SeriesReviewerModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      seriesId: json['seriesId'] as int?,
      subject: json['subject'],
      message: json['message'] as String?,
      rating: json['rating'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SeriesReviewerModelToJson(
        SeriesReviewerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'seriesId': instance.seriesId,
      'subject': instance.subject,
      'message': instance.message,
      'rating': instance.rating,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'user': instance.user?.toJson(),
    };
