// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NotificationModelCWProxy {
  NotificationModel id(int? id);

  NotificationModel type(NotificationTypes? type);

  NotificationModel entityId(int? entityId);

  NotificationModel data(NotificationDataModel? data);

  NotificationModel createdAt(DateTime? createdAt);

  NotificationModel initiators(List<UserModel>? initiators);

  NotificationModel totalInitiators(int? totalInitiators);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NotificationModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NotificationModel(...).copyWith(id: 12, name: "My name")
  /// ````
  NotificationModel call({
    int? id,
    NotificationTypes? type,
    int? entityId,
    NotificationDataModel? data,
    DateTime? createdAt,
    List<UserModel>? initiators,
    int? totalInitiators,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfNotificationModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfNotificationModel.copyWith.fieldName(...)`
class _$NotificationModelCWProxyImpl implements _$NotificationModelCWProxy {
  const _$NotificationModelCWProxyImpl(this._value);

  final NotificationModel _value;

  @override
  NotificationModel id(int? id) => this(id: id);

  @override
  NotificationModel type(NotificationTypes? type) => this(type: type);

  @override
  NotificationModel entityId(int? entityId) => this(entityId: entityId);

  @override
  NotificationModel data(NotificationDataModel? data) => this(data: data);

  @override
  NotificationModel createdAt(DateTime? createdAt) =>
      this(createdAt: createdAt);

  @override
  NotificationModel initiators(List<UserModel>? initiators) =>
      this(initiators: initiators);

  @override
  NotificationModel totalInitiators(int? totalInitiators) =>
      this(totalInitiators: totalInitiators);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NotificationModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NotificationModel(...).copyWith(id: 12, name: "My name")
  /// ````
  NotificationModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? entityId = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? initiators = const $CopyWithPlaceholder(),
    Object? totalInitiators = const $CopyWithPlaceholder(),
  }) {
    return NotificationModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as NotificationTypes?,
      entityId: entityId == const $CopyWithPlaceholder()
          ? _value.entityId
          // ignore: cast_nullable_to_non_nullable
          : entityId as int?,
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as NotificationDataModel?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      initiators: initiators == const $CopyWithPlaceholder()
          ? _value.initiators
          // ignore: cast_nullable_to_non_nullable
          : initiators as List<UserModel>?,
      totalInitiators: totalInitiators == const $CopyWithPlaceholder()
          ? _value.totalInitiators
          // ignore: cast_nullable_to_non_nullable
          : totalInitiators as int?,
    );
  }
}

extension $NotificationModelCopyWith on NotificationModel {
  /// Returns a callable class that can be used as follows: `instanceOfNotificationModel.copyWith(...)` or like so:`instanceOfNotificationModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NotificationModelCWProxy get copyWith =>
      _$NotificationModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as int?,
      type: $enumDecodeNullable(_$NotificationTypesEnumMap, json['type']),
      entityId: json['entityId'] as int?,
      data: json['data'] == null
          ? null
          : NotificationDataModel.fromJson(
              json['data'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      initiators: (json['initiators'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalInitiators: json['totalInitiators'] as int?,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$NotificationTypesEnumMap[instance.type],
      'entityId': instance.entityId,
      'data': instance.data?.toJson(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'initiators': instance.initiators?.map((e) => e.toJson()).toList(),
      'totalInitiators': instance.totalInitiators,
    };

const _$NotificationTypesEnumMap = {
  NotificationTypes.newReply: 'new_reply',
  NotificationTypes.newThreadUpvote: 'new_thread_upvote',
  NotificationTypes.threadBoost: 'thread_boost',
  NotificationTypes.threadMention: 'thread_mention',
  NotificationTypes.newFollower: 'new_follower',
  NotificationTypes.newWorkedwithInvite: 'new_workedwith_invite',
  NotificationTypes.newProjectWorkedwithInvite: 'new_project_workedwith_invite',
  NotificationTypes.newComment: 'new_comment',
  NotificationTypes.initialPost: 'initial_post',
  NotificationTypes.newCommunityMember: 'new_community_member',
  NotificationTypes.newPollVote: 'new_poll_vote',
  NotificationTypes.communityInvite: 'community_invite',
  NotificationTypes.communityRoleChanged: 'community_role_changed',
  NotificationTypes.newCommentUpvote: 'new_comment_upvote',
  NotificationTypes.newProjectUpvote: 'new_project_upvote',
  NotificationTypes.editGuestbookEntry: 'edit_guestbook_entry',
  NotificationTypes.newGuestbookEntry: 'new_guestbook_entry',
  NotificationTypes.communityOwnershipTransfer: 'community_ownership_transfer',
};
