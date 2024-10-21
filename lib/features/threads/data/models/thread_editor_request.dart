import 'dart:io';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_gif_model.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_enums.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_poll_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_mention_model.dart';

part 'thread_editor_request.g.dart';

@CopyWith()
@JsonSerializable(includeIfNull: false)
class  ThreadEditorRequest  extends Equatable {
  const ThreadEditorRequest({
    this.message,
    this.images,
    this.code,
    this.codeLanguage,
    this.id,
    this.totalReplies,
    this.totalUpvotes,
    this.hasVoted,
    this.hasBoosted,
    this.totalBoosts,
    this.videoUrl,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.communityId,
    this.platform,
    this.linkPreviewUrl,

    this.threadToReply,
    this.scheduled,
    this.scheduledAt,
    this.threadToEdit,

    this.files = const [],
    this.selectedFilesType,
    this.title,
    this.gif,
    this.poll,
    this.mentions,
    this.isAnonymous,
    this.community,


    this.editedComponents = const []

  });

  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<File> files;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final RequestType? selectedFilesType;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final ThreadModel? threadToReply;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool? scheduled;

  final DateTime? scheduledAt;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final ThreadModel? threadToEdit; // if this is not null, it means we are editing this thread

  final String? message;
  @JsonKey(includeIfNull: true)
  final List<String>? images;
  @JsonKey(includeIfNull: true)
  final String? code;
  final String? codeLanguage;
  final int? id;
  final int? parentId;
  final int? totalReplies;
  final bool? isAnonymous;
  final int? totalUpvotes;
  final int? createdAt;
  final int? updatedAt;
  final bool? hasVoted;
  final bool? hasBoosted;
  final int? totalBoosts;
  @JsonKey(includeIfNull: true)
  final String? videoUrl;
  final int? communityId;
  final String? platform;
  final String? title;
  @JsonKey(includeIfNull: true)
  final String? linkPreviewUrl;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<ThreadComponents> editedComponents;
  @JsonKey(includeIfNull: true)
  final ThreadPollModel? poll;
  @JsonKey(includeIfNull: true)
  final SharedGifModel? gif;
  final List<UserMentionModel>? mentions;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final CommunityModel? community;

  @override
  List<Object?> get props => [title, message, ];

  factory ThreadEditorRequest.fromJson(Map<String, dynamic> json) => _$ThreadEditorRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ThreadEditorRequestToJson(this);


}




