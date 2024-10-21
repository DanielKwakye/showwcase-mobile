import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_content_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_event_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_lexical_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_reading_stats_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_tag_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_worked_with_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'show_model.g.dart';

@CopyWith()
@JsonSerializable(explicitToJson: true)
class ShowModel extends Equatable {
  final int? id;
  final int? userId;
  final String? title;
  final String? thumbnailKey;
  final String? coverImage;
  final DateTime? publishedDate;
  final int? views;
  final int? visits;
  final int? totalUpvotes;
  final int? totalComments;
  final String? projectSummary;
  final String? canonicalLink;
  final String? slug;
  final String? visibility;
  final String? structure;
  final String? markdown;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<ShowTagModel>? tags;
  final List<ShowWorkedWithModel>? workedwiths;
  @JsonKey(fromJson: _contentFromJson)
  final ShowContentModel? content;
  final String? category;
  final ShowEventModel? event;
  final UserModel? user;
  final bool? hasVoted;
  final bool? hasBookmarked;
  final ShowReadingStatsModel? readingStats;
  final List<int>? seriesIds;
  final bool? isEditing;
  final int? level;
  final int? depth;
  final int? seriesId;
  final SeriesModel? series;
  final bool? hasCompleted;

  const ShowModel({
    this.id,
    this.userId,
    this.title,
    this.thumbnailKey,
    this.coverImage,
    this.publishedDate,
    this.views,
    this.visits,
    this.totalUpvotes,
    this.totalComments,
    this.projectSummary,
    this.canonicalLink,
    this.slug,
    this.visibility,
    this.structure,
    this.markdown,
    this.createdAt,
    this.updatedAt,
    this.tags,
    this.workedwiths,
    this.content,
    this.category,
    this.event,
    this.user,
    this.hasVoted,
    this.hasBookmarked,
    this.readingStats,
    this.seriesIds,
    this.isEditing,
    this.level,
    this.depth,
    this.seriesId,
    this.series,
    this.hasCompleted,
  });

  factory ShowModel.fromJson(Map<String, dynamic> json) => _$ShowModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowModelToJson(this);

  static ShowContentModel? _contentFromJson( jsonContent ) {

    if(jsonContent == null){
      return null;
    }

    if(jsonContent is List<dynamic>){

      if(jsonContent.isNotEmpty){
        final jsonItem = jsonContent.first as Map<String, dynamic>;
        if(jsonItem.containsKey("lexicalBlock") && jsonItem['lexicalBlock'] != null) {
          final content = ShowContentModel(
            lexicalBlock: ShowLexicalBlockModel.fromJson(jsonItem["lexicalBlock"]),
          );
          return content;
        }
      }

      return ShowContentModel(
        blocks:  List<ShowBlockModel>.from(jsonContent.map((x) => ShowBlockModel.fromJson(x))),
      );

    }

    return ShowContentModel(
      blocks: jsonContent["blocks"] == null ? null : List<ShowBlockModel>.from(jsonContent["blocks"].map((x) => ShowBlockModel.fromJson(x))),
    );

  }

  @override
  List<Object?> get props => [id, hasBookmarked, hasVoted, hasCompleted, workedwiths, content, tags, title, projectSummary, totalUpvotes, totalComments, coverImage, thumbnailKey];
}