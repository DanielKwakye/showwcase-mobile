import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'series_reviewer_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SeriesReviewerModel {

  const SeriesReviewerModel({
    this.id,
    this.userId,
    this.seriesId,
    this.subject,
    this.message,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  final int? id;
  final int? userId;
  final int? seriesId;
  final dynamic subject;
  final String? message;
  final int? rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserModel? user;

  factory SeriesReviewerModel.fromJson(Map<String, dynamic> json) => _$SeriesReviewerModelFromJson(json);
  Map<String, dynamic> toJson() => _$SeriesReviewerModelToJson(this);


}