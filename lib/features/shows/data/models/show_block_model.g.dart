// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowBlockModel _$ShowBlockModelFromJson(Map<String, dynamic> json) =>
    ShowBlockModel(
      textBlock: json['textBlock'] == null
          ? null
          : ShowTextBlockModel.fromJson(
              json['textBlock'] as Map<String, dynamic>),
      codeBlock: json['codeBlock'] == null
          ? null
          : SharedCodeBlockModel.fromJson(
              json['codeBlock'] as Map<String, dynamic>),
      category: json['category'] as String?,
      projectBlockType: json['projectBlockType'] as int?,
      type: json['type'] as String?,
      imageBlock: json['imageBlock'] == null
          ? null
          : ShowImageBlockModel.fromJson(
              json['imageBlock'] as Map<String, dynamic>),
      galleryBlock: json['galleryBlock'] == null
          ? null
          : ShowGalleryBlockModel.fromJson(
              json['galleryBlock'] as Map<String, dynamic>),
      bookmarkBlock: json['bookmarkBlock'] == null
          ? null
          : ShowBookmarkBlockModel.fromJson(
              json['bookmarkBlock'] as Map<String, dynamic>),
      tweetBlock: json['tweetBlock'] == null
          ? null
          : ShowTweetBlockModel.fromJson(
              json['tweetBlock'] as Map<String, dynamic>),
      threadBlock: json['threadBlock'] == null
          ? null
          : ShowThreadBlockModel.fromJson(
              json['threadBlock'] as Map<String, dynamic>),
      gistBlock: json['gistBlock'] == null
          ? null
          : ShowGistBlockModel.fromJson(
              json['gistBlock'] as Map<String, dynamic>),
      linksBlock: json['linksBlock'] == null
          ? null
          : ShowLinksBlockModel.fromJson(
              json['linksBlock'] as Map<String, dynamic>),
      markdownBlock: json['markdownBlock'] == null
          ? null
          : ShowMarkdownBlockModel.fromJson(
              json['markdownBlock'] as Map<String, dynamic>),
      statisticsBlock: json['statisticsBlock'] == null
          ? null
          : ShowStatisticBlockModel.fromJson(
              json['statisticsBlock'] as Map<String, dynamic>),
      skillsTechsBlock: json['skillsTechsBlock'] == null
          ? null
          : ShowSkillsTechBlockModel.fromJson(
              json['skillsTechsBlock'] as Map<String, dynamic>),
      videoBlock: json['videoBlock'] == null
          ? null
          : ShowVideoBlockModel.fromJson(
              json['videoBlock'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShowBlockModelToJson(ShowBlockModel instance) =>
    <String, dynamic>{
      'textBlock': instance.textBlock?.toJson(),
      'codeBlock': instance.codeBlock?.toJson(),
      'category': instance.category,
      'projectBlockType': instance.projectBlockType,
      'type': instance.type,
      'imageBlock': instance.imageBlock?.toJson(),
      'galleryBlock': instance.galleryBlock?.toJson(),
      'bookmarkBlock': instance.bookmarkBlock?.toJson(),
      'tweetBlock': instance.tweetBlock?.toJson(),
      'threadBlock': instance.threadBlock?.toJson(),
      'gistBlock': instance.gistBlock?.toJson(),
      'linksBlock': instance.linksBlock?.toJson(),
      'markdownBlock': instance.markdownBlock?.toJson(),
      'statisticsBlock': instance.statisticsBlock?.toJson(),
      'skillsTechsBlock': instance.skillsTechsBlock?.toJson(),
      'videoBlock': instance.videoBlock?.toJson(),
    };
