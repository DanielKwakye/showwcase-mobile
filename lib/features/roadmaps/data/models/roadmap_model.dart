import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_info_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

import 'roadmap_reading_stats_model.dart';

part 'roadmap_model.g.dart';

@JsonSerializable()
class RoadmapModel {

  final int? id;
  final int? userId;
  final String? title;
  final String? description;
  final String? slug;
  final String? color;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserModel? user;
  final RoadmapInfoModel? info;
  final String? about;
  final RoadMapReadingStatsModel? readingStats ;
  final num? numberOfShowsInRoadmap;
  final num? numberOfUserCompletedShows;
  final num? userReadPercentage;
  final num? numberOfPendingShowsInArchive;
  final num? numberOfApprovedShowsInArchive;
  final bool comingSoon;

  const RoadmapModel( {
    this.id,
    this.userId,
    this.title,
    this.description,
    this.slug,
    this.color,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.numberOfShowsInRoadmap,
    this.numberOfUserCompletedShows,
    this.userReadPercentage,
    this.numberOfPendingShowsInArchive,
    this.numberOfApprovedShowsInArchive,
    this.comingSoon = false,
    this.readingStats,
    this.info,
    this.about,
  });

  factory RoadmapModel.fromJson(Map<String, dynamic> json) => _$RoadmapModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoadmapModelToJson(this);
  
}