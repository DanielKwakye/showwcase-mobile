// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_poll_option_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ThreadPollOptionModelCWProxy {
  ThreadPollOptionModel id(int? id);

  ThreadPollOptionModel option(String? option);

  ThreadPollOptionModel pollId(int? pollId);

  ThreadPollOptionModel createdAt(DateTime? createdAt);

  ThreadPollOptionModel updatedAt(DateTime? updatedAt);

  ThreadPollOptionModel totalVotes(int? totalVotes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThreadPollOptionModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThreadPollOptionModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ThreadPollOptionModel call({
    int? id,
    String? option,
    int? pollId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? totalVotes,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfThreadPollOptionModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfThreadPollOptionModel.copyWith.fieldName(...)`
class _$ThreadPollOptionModelCWProxyImpl
    implements _$ThreadPollOptionModelCWProxy {
  const _$ThreadPollOptionModelCWProxyImpl(this._value);

  final ThreadPollOptionModel _value;

  @override
  ThreadPollOptionModel id(int? id) => this(id: id);

  @override
  ThreadPollOptionModel option(String? option) => this(option: option);

  @override
  ThreadPollOptionModel pollId(int? pollId) => this(pollId: pollId);

  @override
  ThreadPollOptionModel createdAt(DateTime? createdAt) =>
      this(createdAt: createdAt);

  @override
  ThreadPollOptionModel updatedAt(DateTime? updatedAt) =>
      this(updatedAt: updatedAt);

  @override
  ThreadPollOptionModel totalVotes(int? totalVotes) =>
      this(totalVotes: totalVotes);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThreadPollOptionModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThreadPollOptionModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ThreadPollOptionModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? option = const $CopyWithPlaceholder(),
    Object? pollId = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? totalVotes = const $CopyWithPlaceholder(),
  }) {
    return ThreadPollOptionModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      option: option == const $CopyWithPlaceholder()
          ? _value.option
          // ignore: cast_nullable_to_non_nullable
          : option as String?,
      pollId: pollId == const $CopyWithPlaceholder()
          ? _value.pollId
          // ignore: cast_nullable_to_non_nullable
          : pollId as int?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
      totalVotes: totalVotes == const $CopyWithPlaceholder()
          ? _value.totalVotes
          // ignore: cast_nullable_to_non_nullable
          : totalVotes as int?,
    );
  }
}

extension $ThreadPollOptionModelCopyWith on ThreadPollOptionModel {
  /// Returns a callable class that can be used as follows: `instanceOfThreadPollOptionModel.copyWith(...)` or like so:`instanceOfThreadPollOptionModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ThreadPollOptionModelCWProxy get copyWith =>
      _$ThreadPollOptionModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadPollOptionModel _$ThreadPollOptionModelFromJson(
        Map<String, dynamic> json) =>
    ThreadPollOptionModel(
      id: json['id'] as int?,
      option: json['option'] as String?,
      pollId: json['pollId'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      totalVotes: json['totalVotes'] as int?,
    );

Map<String, dynamic> _$ThreadPollOptionModelToJson(
    ThreadPollOptionModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('option', instance.option);
  writeNotNull('pollId', instance.pollId);
  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  writeNotNull('updatedAt', instance.updatedAt?.toIso8601String());
  writeNotNull('totalVotes', instance.totalVotes);
  return val;
}
