import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/series/data/models/series_category_model.dart';
import 'package:showwcase_v3/features/series/data/models/series_review_stats_model.dart';
import 'package:showwcase_v3/features/series/data/models/series_seo_model.dart';
import 'package:showwcase_v3/features/series/data/models/series_settings_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'series_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SeriesModel extends Equatable {
  final int? id;
  final int? userId;
  final String? title;
  final String? slug;
  final String? coverImageKey;
  final SeriesSeoModel? seo;
  final SeriesSettingsModel? settings;
  final String? summary;
  final String? description;
  final String? difficulty;
  final String? status;
  final DateTime? publishedDate;
  final DateTime? createdAt;
  final List<SeriesCategoryModel>? categories;
  final List<ShowModel>? projects;
  final SeriesReviewStatsModel? reviews;
  final UserModel? user;

  const SeriesModel({
    this.id,
    this.userId,
    this.title,
    this.slug,
    this.coverImageKey,
    this.seo,
    this.settings,
    this.summary,
    this.description,
    this.difficulty,
    this.status,
    this.publishedDate,
    this.createdAt,
    this.categories,
    this.projects,
    this.reviews,
    this.user,
  });

  factory SeriesModel.fromJson(Map<String, dynamic> json) => _$SeriesModelFromJson(json);
  Map<String, dynamic> toJson() => _$SeriesModelToJson(this);

  @override
  List<Object?> get props => [id, projects];

}