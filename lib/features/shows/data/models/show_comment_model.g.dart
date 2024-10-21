// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_comment_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ShowCommentModelCWProxy {
  ShowCommentModel id(int? id);

  ShowCommentModel message(String? message);

  ShowCommentModel createdAt(DateTime? createdAt);

  ShowCommentModel updatedAt(DateTime? updatedAt);

  ShowCommentModel userId(int? userId);

  ShowCommentModel totalUpvotes(int? totalUpvotes);

  ShowCommentModel totalReplies(int? totalReplies);

  ShowCommentModel mentions(List<UserMentionModel>? mentions);

  ShowCommentModel user(UserModel? user);

  ShowCommentModel replies(List<ShowCommentModel>? replies);

  ShowCommentModel hasVoted(bool? hasVoted);

  ShowCommentModel parentId(int? parentId);

  ShowCommentModel projectId(int? projectId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShowCommentModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShowCommentModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ShowCommentModel call({
    int? id,
    String? message,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? userId,
    int? totalUpvotes,
    int? totalReplies,
    List<UserMentionModel>? mentions,
    UserModel? user,
    List<ShowCommentModel>? replies,
    bool? hasVoted,
    int? parentId,
    int? projectId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfShowCommentModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfShowCommentModel.copyWith.fieldName(...)`
class _$ShowCommentModelCWProxyImpl implements _$ShowCommentModelCWProxy {
  const _$ShowCommentModelCWProxyImpl(this._value);

  final ShowCommentModel _value;

  @override
  ShowCommentModel id(int? id) => this(id: id);

  @override
  ShowCommentModel message(String? message) => this(message: message);

  @override
  ShowCommentModel createdAt(DateTime? createdAt) => this(createdAt: createdAt);

  @override
  ShowCommentModel updatedAt(DateTime? updatedAt) => this(updatedAt: updatedAt);

  @override
  ShowCommentModel userId(int? userId) => this(userId: userId);

  @override
  ShowCommentModel totalUpvotes(int? totalUpvotes) =>
      this(totalUpvotes: totalUpvotes);

  @override
  ShowCommentModel totalReplies(int? totalReplies) =>
      this(totalReplies: totalReplies);

  @override
  ShowCommentModel mentions(List<UserMentionModel>? mentions) =>
      this(mentions: mentions);

  @override
  ShowCommentModel user(UserModel? user) => this(user: user);

  @override
  ShowCommentModel replies(List<ShowCommentModel>? replies) =>
      this(replies: replies);

  @override
  ShowCommentModel hasVoted(bool? hasVoted) => this(hasVoted: hasVoted);

  @override
  ShowCommentModel parentId(int? parentId) => this(parentId: parentId);

  @override
  ShowCommentModel projectId(int? projectId) => this(projectId: projectId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShowCommentModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShowCommentModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ShowCommentModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? userId = const $CopyWithPlaceholder(),
    Object? totalUpvotes = const $CopyWithPlaceholder(),
    Object? totalReplies = const $CopyWithPlaceholder(),
    Object? mentions = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
    Object? replies = const $CopyWithPlaceholder(),
    Object? hasVoted = const $CopyWithPlaceholder(),
    Object? parentId = const $CopyWithPlaceholder(),
    Object? projectId = const $CopyWithPlaceholder(),
  }) {
    return ShowCommentModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
      userId: userId == const $CopyWithPlaceholder()
          ? _value.userId
          // ignore: cast_nullable_to_non_nullable
          : userId as int?,
      totalUpvotes: totalUpvotes == const $CopyWithPlaceholder()
          ? _value.totalUpvotes
          // ignore: cast_nullable_to_non_nullable
          : totalUpvotes as int?,
      totalReplies: totalReplies == const $CopyWithPlaceholder()
          ? _value.totalReplies
          // ignore: cast_nullable_to_non_nullable
          : totalReplies as int?,
      mentions: mentions == const $CopyWithPlaceholder()
          ? _value.mentions
          // ignore: cast_nullable_to_non_nullable
          : mentions as List<UserMentionModel>?,
      user: user == const $CopyWithPlaceholder()
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as UserModel?,
      replies: replies == const $CopyWithPlaceholder()
          ? _value.replies
          // ignore: cast_nullable_to_non_nullable
          : replies as List<ShowCommentModel>?,
      hasVoted: hasVoted == const $CopyWithPlaceholder()
          ? _value.hasVoted
          // ignore: cast_nullable_to_non_nullable
          : hasVoted as bool?,
      parentId: parentId == const $CopyWithPlaceholder()
          ? _value.parentId
          // ignore: cast_nullable_to_non_nullable
          : parentId as int?,
      projectId: projectId == const $CopyWithPlaceholder()
          ? _value.projectId
          // ignore: cast_nullable_to_non_nullable
          : projectId as int?,
    );
  }
}

extension $ShowCommentModelCopyWith on ShowCommentModel {
  /// Returns a callable class that can be used as follows: `instanceOfShowCommentModel.copyWith(...)` or like so:`instanceOfShowCommentModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ShowCommentModelCWProxy get copyWith => _$ShowCommentModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowCommentModel _$ShowCommentModelFromJson(Map<String, dynamic> json) =>
    ShowCommentModel(
      id: json['id'] as int?,
      message: json['message'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as int?,
      totalUpvotes: json['totalUpvotes'] as int?,
      totalReplies: json['totalReplies'] as int?,
      mentions: (json['mentions'] as List<dynamic>?)
          ?.map((e) => UserMentionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => ShowCommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasVoted: json['hasVoted'] as bool?,
      parentId: json['parentId'] as int?,
      projectId: json['projectId'] as int?,
    );

Map<String, dynamic> _$ShowCommentModelToJson(ShowCommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'userId': instance.userId,
      'totalUpvotes': instance.totalUpvotes,
      'totalReplies': instance.totalReplies,
      'mentions': instance.mentions?.map((e) => e.toJson()).toList(),
      'user': instance.user?.toJson(),
      'replies': instance.replies?.map((e) => e.toJson()).toList(),
      'parentId': instance.parentId,
      'projectId': instance.projectId,
      'hasVoted': instance.hasVoted,
    };
