import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_code_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/blocks/show_bookmark_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/blocks/show_gallery_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/blocks/show_gist_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/blocks/show_image_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/blocks/show_links_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/blocks/show_markdown_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/blocks/show_skills_tech_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/blocks/show_statistic_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/blocks/show_text_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/blocks/show_thread_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/blocks/show_tweet_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/blocks/show_video_block_model.dart';

part 'show_block_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowBlockModel extends Equatable {

  const ShowBlockModel({
    this.textBlock,
    this.codeBlock,
    this.category,
    this.projectBlockType,
    this.type,
    this.imageBlock,
    this.galleryBlock,
    this.bookmarkBlock,
    this.tweetBlock,
    this.threadBlock,
    this.gistBlock,
    this.linksBlock,
    this.markdownBlock,
    this.statisticsBlock,
    this.skillsTechsBlock,
    this.videoBlock,
  });

  final ShowTextBlockModel? textBlock;
  final SharedCodeBlockModel? codeBlock;
  final String? category;
  final int? projectBlockType;
  final String? type;
  final ShowImageBlockModel? imageBlock;
  final ShowGalleryBlockModel? galleryBlock;
  final ShowBookmarkBlockModel? bookmarkBlock;
  final ShowTweetBlockModel? tweetBlock;
  final ShowThreadBlockModel? threadBlock;
  final ShowGistBlockModel? gistBlock;
  final ShowLinksBlockModel? linksBlock;
  final ShowMarkdownBlockModel? markdownBlock;
  final ShowStatisticBlockModel? statisticsBlock;
  final ShowSkillsTechBlockModel? skillsTechsBlock;
  final ShowVideoBlockModel? videoBlock;

  factory ShowBlockModel.fromJson(Map<String, dynamic> json) => _$ShowBlockModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowBlockModelToJson(this);

  @override
  List<Object?> get props => [type, projectBlockType, category];



}