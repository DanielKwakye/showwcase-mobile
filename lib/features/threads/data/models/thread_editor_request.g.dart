// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_editor_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ThreadEditorRequestCWProxy {
  ThreadEditorRequest message(String? message);

  ThreadEditorRequest images(List<String>? images);

  ThreadEditorRequest code(String? code);

  ThreadEditorRequest codeLanguage(String? codeLanguage);

  ThreadEditorRequest id(int? id);

  ThreadEditorRequest totalReplies(int? totalReplies);

  ThreadEditorRequest totalUpvotes(int? totalUpvotes);

  ThreadEditorRequest hasVoted(bool? hasVoted);

  ThreadEditorRequest hasBoosted(bool? hasBoosted);

  ThreadEditorRequest totalBoosts(int? totalBoosts);

  ThreadEditorRequest videoUrl(String? videoUrl);

  ThreadEditorRequest parentId(int? parentId);

  ThreadEditorRequest createdAt(int? createdAt);

  ThreadEditorRequest updatedAt(int? updatedAt);

  ThreadEditorRequest communityId(int? communityId);

  ThreadEditorRequest platform(String? platform);

  ThreadEditorRequest linkPreviewUrl(String? linkPreviewUrl);

  ThreadEditorRequest threadToReply(ThreadModel? threadToReply);

  ThreadEditorRequest scheduled(bool? scheduled);

  ThreadEditorRequest scheduledAt(DateTime? scheduledAt);

  ThreadEditorRequest threadToEdit(ThreadModel? threadToEdit);

  ThreadEditorRequest files(List<File> files);

  ThreadEditorRequest selectedFilesType(RequestType? selectedFilesType);

  ThreadEditorRequest title(String? title);

  ThreadEditorRequest gif(SharedGifModel? gif);

  ThreadEditorRequest poll(ThreadPollModel? poll);

  ThreadEditorRequest mentions(List<UserMentionModel>? mentions);

  ThreadEditorRequest isAnonymous(bool? isAnonymous);

  ThreadEditorRequest community(CommunityModel? community);

  ThreadEditorRequest editedComponents(List<ThreadComponents> editedComponents);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThreadEditorRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThreadEditorRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  ThreadEditorRequest call({
    String? message,
    List<String>? images,
    String? code,
    String? codeLanguage,
    int? id,
    int? totalReplies,
    int? totalUpvotes,
    bool? hasVoted,
    bool? hasBoosted,
    int? totalBoosts,
    String? videoUrl,
    int? parentId,
    int? createdAt,
    int? updatedAt,
    int? communityId,
    String? platform,
    String? linkPreviewUrl,
    ThreadModel? threadToReply,
    bool? scheduled,
    DateTime? scheduledAt,
    ThreadModel? threadToEdit,
    List<File>? files,
    RequestType? selectedFilesType,
    String? title,
    SharedGifModel? gif,
    ThreadPollModel? poll,
    List<UserMentionModel>? mentions,
    bool? isAnonymous,
    CommunityModel? community,
    List<ThreadComponents>? editedComponents,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfThreadEditorRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfThreadEditorRequest.copyWith.fieldName(...)`
class _$ThreadEditorRequestCWProxyImpl implements _$ThreadEditorRequestCWProxy {
  const _$ThreadEditorRequestCWProxyImpl(this._value);

  final ThreadEditorRequest _value;

  @override
  ThreadEditorRequest message(String? message) => this(message: message);

  @override
  ThreadEditorRequest images(List<String>? images) => this(images: images);

  @override
  ThreadEditorRequest code(String? code) => this(code: code);

  @override
  ThreadEditorRequest codeLanguage(String? codeLanguage) =>
      this(codeLanguage: codeLanguage);

  @override
  ThreadEditorRequest id(int? id) => this(id: id);

  @override
  ThreadEditorRequest totalReplies(int? totalReplies) =>
      this(totalReplies: totalReplies);

  @override
  ThreadEditorRequest totalUpvotes(int? totalUpvotes) =>
      this(totalUpvotes: totalUpvotes);

  @override
  ThreadEditorRequest hasVoted(bool? hasVoted) => this(hasVoted: hasVoted);

  @override
  ThreadEditorRequest hasBoosted(bool? hasBoosted) =>
      this(hasBoosted: hasBoosted);

  @override
  ThreadEditorRequest totalBoosts(int? totalBoosts) =>
      this(totalBoosts: totalBoosts);

  @override
  ThreadEditorRequest videoUrl(String? videoUrl) => this(videoUrl: videoUrl);

  @override
  ThreadEditorRequest parentId(int? parentId) => this(parentId: parentId);

  @override
  ThreadEditorRequest createdAt(int? createdAt) => this(createdAt: createdAt);

  @override
  ThreadEditorRequest updatedAt(int? updatedAt) => this(updatedAt: updatedAt);

  @override
  ThreadEditorRequest communityId(int? communityId) =>
      this(communityId: communityId);

  @override
  ThreadEditorRequest platform(String? platform) => this(platform: platform);

  @override
  ThreadEditorRequest linkPreviewUrl(String? linkPreviewUrl) =>
      this(linkPreviewUrl: linkPreviewUrl);

  @override
  ThreadEditorRequest threadToReply(ThreadModel? threadToReply) =>
      this(threadToReply: threadToReply);

  @override
  ThreadEditorRequest scheduled(bool? scheduled) => this(scheduled: scheduled);

  @override
  ThreadEditorRequest scheduledAt(DateTime? scheduledAt) =>
      this(scheduledAt: scheduledAt);

  @override
  ThreadEditorRequest threadToEdit(ThreadModel? threadToEdit) =>
      this(threadToEdit: threadToEdit);

  @override
  ThreadEditorRequest files(List<File> files) => this(files: files);

  @override
  ThreadEditorRequest selectedFilesType(RequestType? selectedFilesType) =>
      this(selectedFilesType: selectedFilesType);

  @override
  ThreadEditorRequest title(String? title) => this(title: title);

  @override
  ThreadEditorRequest gif(SharedGifModel? gif) => this(gif: gif);

  @override
  ThreadEditorRequest poll(ThreadPollModel? poll) => this(poll: poll);

  @override
  ThreadEditorRequest mentions(List<UserMentionModel>? mentions) =>
      this(mentions: mentions);

  @override
  ThreadEditorRequest isAnonymous(bool? isAnonymous) =>
      this(isAnonymous: isAnonymous);

  @override
  ThreadEditorRequest community(CommunityModel? community) =>
      this(community: community);

  @override
  ThreadEditorRequest editedComponents(
          List<ThreadComponents> editedComponents) =>
      this(editedComponents: editedComponents);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThreadEditorRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThreadEditorRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  ThreadEditorRequest call({
    Object? message = const $CopyWithPlaceholder(),
    Object? images = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? codeLanguage = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? totalReplies = const $CopyWithPlaceholder(),
    Object? totalUpvotes = const $CopyWithPlaceholder(),
    Object? hasVoted = const $CopyWithPlaceholder(),
    Object? hasBoosted = const $CopyWithPlaceholder(),
    Object? totalBoosts = const $CopyWithPlaceholder(),
    Object? videoUrl = const $CopyWithPlaceholder(),
    Object? parentId = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? communityId = const $CopyWithPlaceholder(),
    Object? platform = const $CopyWithPlaceholder(),
    Object? linkPreviewUrl = const $CopyWithPlaceholder(),
    Object? threadToReply = const $CopyWithPlaceholder(),
    Object? scheduled = const $CopyWithPlaceholder(),
    Object? scheduledAt = const $CopyWithPlaceholder(),
    Object? threadToEdit = const $CopyWithPlaceholder(),
    Object? files = const $CopyWithPlaceholder(),
    Object? selectedFilesType = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? gif = const $CopyWithPlaceholder(),
    Object? poll = const $CopyWithPlaceholder(),
    Object? mentions = const $CopyWithPlaceholder(),
    Object? isAnonymous = const $CopyWithPlaceholder(),
    Object? community = const $CopyWithPlaceholder(),
    Object? editedComponents = const $CopyWithPlaceholder(),
  }) {
    return ThreadEditorRequest(
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
      images: images == const $CopyWithPlaceholder()
          ? _value.images
          // ignore: cast_nullable_to_non_nullable
          : images as List<String>?,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String?,
      codeLanguage: codeLanguage == const $CopyWithPlaceholder()
          ? _value.codeLanguage
          // ignore: cast_nullable_to_non_nullable
          : codeLanguage as String?,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      totalReplies: totalReplies == const $CopyWithPlaceholder()
          ? _value.totalReplies
          // ignore: cast_nullable_to_non_nullable
          : totalReplies as int?,
      totalUpvotes: totalUpvotes == const $CopyWithPlaceholder()
          ? _value.totalUpvotes
          // ignore: cast_nullable_to_non_nullable
          : totalUpvotes as int?,
      hasVoted: hasVoted == const $CopyWithPlaceholder()
          ? _value.hasVoted
          // ignore: cast_nullable_to_non_nullable
          : hasVoted as bool?,
      hasBoosted: hasBoosted == const $CopyWithPlaceholder()
          ? _value.hasBoosted
          // ignore: cast_nullable_to_non_nullable
          : hasBoosted as bool?,
      totalBoosts: totalBoosts == const $CopyWithPlaceholder()
          ? _value.totalBoosts
          // ignore: cast_nullable_to_non_nullable
          : totalBoosts as int?,
      videoUrl: videoUrl == const $CopyWithPlaceholder()
          ? _value.videoUrl
          // ignore: cast_nullable_to_non_nullable
          : videoUrl as String?,
      parentId: parentId == const $CopyWithPlaceholder()
          ? _value.parentId
          // ignore: cast_nullable_to_non_nullable
          : parentId as int?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as int?,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as int?,
      communityId: communityId == const $CopyWithPlaceholder()
          ? _value.communityId
          // ignore: cast_nullable_to_non_nullable
          : communityId as int?,
      platform: platform == const $CopyWithPlaceholder()
          ? _value.platform
          // ignore: cast_nullable_to_non_nullable
          : platform as String?,
      linkPreviewUrl: linkPreviewUrl == const $CopyWithPlaceholder()
          ? _value.linkPreviewUrl
          // ignore: cast_nullable_to_non_nullable
          : linkPreviewUrl as String?,
      threadToReply: threadToReply == const $CopyWithPlaceholder()
          ? _value.threadToReply
          // ignore: cast_nullable_to_non_nullable
          : threadToReply as ThreadModel?,
      scheduled: scheduled == const $CopyWithPlaceholder()
          ? _value.scheduled
          // ignore: cast_nullable_to_non_nullable
          : scheduled as bool?,
      scheduledAt: scheduledAt == const $CopyWithPlaceholder()
          ? _value.scheduledAt
          // ignore: cast_nullable_to_non_nullable
          : scheduledAt as DateTime?,
      threadToEdit: threadToEdit == const $CopyWithPlaceholder()
          ? _value.threadToEdit
          // ignore: cast_nullable_to_non_nullable
          : threadToEdit as ThreadModel?,
      files: files == const $CopyWithPlaceholder() || files == null
          ? _value.files
          // ignore: cast_nullable_to_non_nullable
          : files as List<File>,
      selectedFilesType: selectedFilesType == const $CopyWithPlaceholder()
          ? _value.selectedFilesType
          // ignore: cast_nullable_to_non_nullable
          : selectedFilesType as RequestType?,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String?,
      gif: gif == const $CopyWithPlaceholder()
          ? _value.gif
          // ignore: cast_nullable_to_non_nullable
          : gif as SharedGifModel?,
      poll: poll == const $CopyWithPlaceholder()
          ? _value.poll
          // ignore: cast_nullable_to_non_nullable
          : poll as ThreadPollModel?,
      mentions: mentions == const $CopyWithPlaceholder()
          ? _value.mentions
          // ignore: cast_nullable_to_non_nullable
          : mentions as List<UserMentionModel>?,
      isAnonymous: isAnonymous == const $CopyWithPlaceholder()
          ? _value.isAnonymous
          // ignore: cast_nullable_to_non_nullable
          : isAnonymous as bool?,
      community: community == const $CopyWithPlaceholder()
          ? _value.community
          // ignore: cast_nullable_to_non_nullable
          : community as CommunityModel?,
      editedComponents: editedComponents == const $CopyWithPlaceholder() ||
              editedComponents == null
          ? _value.editedComponents
          // ignore: cast_nullable_to_non_nullable
          : editedComponents as List<ThreadComponents>,
    );
  }
}

extension $ThreadEditorRequestCopyWith on ThreadEditorRequest {
  /// Returns a callable class that can be used as follows: `instanceOfThreadEditorRequest.copyWith(...)` or like so:`instanceOfThreadEditorRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ThreadEditorRequestCWProxy get copyWith =>
      _$ThreadEditorRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadEditorRequest _$ThreadEditorRequestFromJson(Map<String, dynamic> json) =>
    ThreadEditorRequest(
      message: json['message'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      code: json['code'] as String?,
      codeLanguage: json['codeLanguage'] as String?,
      id: json['id'] as int?,
      totalReplies: json['totalReplies'] as int?,
      totalUpvotes: json['totalUpvotes'] as int?,
      hasVoted: json['hasVoted'] as bool?,
      hasBoosted: json['hasBoosted'] as bool?,
      totalBoosts: json['totalBoosts'] as int?,
      videoUrl: json['videoUrl'] as String?,
      parentId: json['parentId'] as int?,
      createdAt: json['createdAt'] as int?,
      updatedAt: json['updatedAt'] as int?,
      communityId: json['communityId'] as int?,
      platform: json['platform'] as String?,
      linkPreviewUrl: json['linkPreviewUrl'] as String?,
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      title: json['title'] as String?,
      gif: json['gif'] == null
          ? null
          : SharedGifModel.fromJson(json['gif'] as Map<String, dynamic>),
      poll: json['poll'] == null
          ? null
          : ThreadPollModel.fromJson(json['poll'] as Map<String, dynamic>),
      mentions: (json['mentions'] as List<dynamic>?)
          ?.map((e) => UserMentionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isAnonymous: json['isAnonymous'] as bool?,
    );

Map<String, dynamic> _$ThreadEditorRequestToJson(ThreadEditorRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('scheduledAt', instance.scheduledAt?.toIso8601String());
  writeNotNull('message', instance.message);
  val['images'] = instance.images;
  val['code'] = instance.code;
  writeNotNull('codeLanguage', instance.codeLanguage);
  writeNotNull('id', instance.id);
  writeNotNull('parentId', instance.parentId);
  writeNotNull('totalReplies', instance.totalReplies);
  writeNotNull('isAnonymous', instance.isAnonymous);
  writeNotNull('totalUpvotes', instance.totalUpvotes);
  writeNotNull('createdAt', instance.createdAt);
  writeNotNull('updatedAt', instance.updatedAt);
  writeNotNull('hasVoted', instance.hasVoted);
  writeNotNull('hasBoosted', instance.hasBoosted);
  writeNotNull('totalBoosts', instance.totalBoosts);
  val['videoUrl'] = instance.videoUrl;
  writeNotNull('communityId', instance.communityId);
  writeNotNull('platform', instance.platform);
  writeNotNull('title', instance.title);
  val['linkPreviewUrl'] = instance.linkPreviewUrl;
  val['poll'] = instance.poll;
  val['gif'] = instance.gif;
  writeNotNull('mentions', instance.mentions);
  return val;
}
