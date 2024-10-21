import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_gif_model.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_link_preview_meta_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_poll_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_mention_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'thread_model.g.dart';

@CopyWith()
@JsonSerializable(explicitToJson: true)
class ThreadModel extends Equatable {

  final String? title;
  final String? message;
  final String? platform;
  final String? code;
  final String? codeLanguage;
  final String? videoUrl;
  final List<String>? images;
  final int? id;
  final int? userId;
  final int? views;
  final int? visits;
  final int? totalUpvotes;
  final int? totalReplies;
  final int? totalBoosts;
  final num? weightedScore;
  final num? intervalScore;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final List<UserModel>? boostedBy;
  final List<UserMentionModel>? mentions;
  final UserModel? user;
  final int? parentId;
  final ThreadModel? parent;
  @JsonKey(fromJson: _linkPreviewMetaFromJson)
  final SharedLinkPreviewMetaModel? linkPreviewMeta;
  final int? communityId;
  final CommunityModel? community;
  final bool? hasVoted;
  final bool? hasBookmarked;
  final bool? hasBoosted;
  final int? pollId;
  final ThreadPollModel? poll;
  final SharedGifModel? gif;
  final List<ThreadModel>? replies;
  final List<UserModel>? participants;
  final bool? isPinned;
  final bool? isAnonymous;

  const ThreadModel({
    this.title,
    this.message,
    this.code,
    this.codeLanguage,
    this.videoUrl,
    this.images,
    this.id,
    this.userId,
    this.views,
    this.visits,
    this.totalUpvotes,
    this.totalReplies,
    this.totalBoosts,
    this.weightedScore,
    this.intervalScore,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.boostedBy,
    this.mentions,
    this.user,
    this.parentId,
    this.parent,
    this.linkPreviewMeta,
    this.communityId,
    this.community,
    this.hasBookmarked,
    this.hasBoosted,
    this.hasVoted,
    this.gif,
    this.isPinned,
    this.poll,
    this.pollId,
    this.replies,
    this.participants,
    this.platform,
    this.isAnonymous,

  });

  factory ThreadModel.fromJson(Map<String, dynamic> json) => _$ThreadModelFromJson(json);
  Map<String, dynamic> toJson() => _$ThreadModelToJson(this);

  static SharedLinkPreviewMetaModel? _linkPreviewMetaFromJson( linkPreviewMeta ) =>
      linkPreviewMeta == null || linkPreviewMeta is! Map<String, dynamic>
          ? null
          : SharedLinkPreviewMetaModel.fromJson(
          linkPreviewMeta);

  @override
  List<Object?> get props => [id, userId, title, message, totalUpvotes, totalBoosts, totalReplies, hasVoted,  hasBoosted, hasBookmarked, poll, linkPreviewMeta, gif, code, images, videoUrl, replies, parent, ];

}