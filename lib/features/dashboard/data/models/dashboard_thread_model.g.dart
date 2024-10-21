// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_thread_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DashboardThreadsModelCWProxy {
  DashboardThreadsModel newThreads(int? newThreads);

  DashboardThreadsModel threadsViews(int? threadsViews);

  DashboardThreadsModel threadsInteractions(int? threadsInteractions);

  DashboardThreadsModel threadsMentions(int? threadsMentions);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DashboardThreadsModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DashboardThreadsModel(...).copyWith(id: 12, name: "My name")
  /// ````
  DashboardThreadsModel call({
    int? newThreads,
    int? threadsViews,
    int? threadsInteractions,
    int? threadsMentions,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDashboardThreadsModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDashboardThreadsModel.copyWith.fieldName(...)`
class _$DashboardThreadsModelCWProxyImpl
    implements _$DashboardThreadsModelCWProxy {
  const _$DashboardThreadsModelCWProxyImpl(this._value);

  final DashboardThreadsModel _value;

  @override
  DashboardThreadsModel newThreads(int? newThreads) =>
      this(newThreads: newThreads);

  @override
  DashboardThreadsModel threadsViews(int? threadsViews) =>
      this(threadsViews: threadsViews);

  @override
  DashboardThreadsModel threadsInteractions(int? threadsInteractions) =>
      this(threadsInteractions: threadsInteractions);

  @override
  DashboardThreadsModel threadsMentions(int? threadsMentions) =>
      this(threadsMentions: threadsMentions);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DashboardThreadsModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DashboardThreadsModel(...).copyWith(id: 12, name: "My name")
  /// ````
  DashboardThreadsModel call({
    Object? newThreads = const $CopyWithPlaceholder(),
    Object? threadsViews = const $CopyWithPlaceholder(),
    Object? threadsInteractions = const $CopyWithPlaceholder(),
    Object? threadsMentions = const $CopyWithPlaceholder(),
  }) {
    return DashboardThreadsModel(
      newThreads: newThreads == const $CopyWithPlaceholder()
          ? _value.newThreads
          // ignore: cast_nullable_to_non_nullable
          : newThreads as int?,
      threadsViews: threadsViews == const $CopyWithPlaceholder()
          ? _value.threadsViews
          // ignore: cast_nullable_to_non_nullable
          : threadsViews as int?,
      threadsInteractions: threadsInteractions == const $CopyWithPlaceholder()
          ? _value.threadsInteractions
          // ignore: cast_nullable_to_non_nullable
          : threadsInteractions as int?,
      threadsMentions: threadsMentions == const $CopyWithPlaceholder()
          ? _value.threadsMentions
          // ignore: cast_nullable_to_non_nullable
          : threadsMentions as int?,
    );
  }
}

extension $DashboardThreadsModelCopyWith on DashboardThreadsModel {
  /// Returns a callable class that can be used as follows: `instanceOfDashboardThreadsModel.copyWith(...)` or like so:`instanceOfDashboardThreadsModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DashboardThreadsModelCWProxy get copyWith =>
      _$DashboardThreadsModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardThreadsModel _$DashboardThreadsModelFromJson(
        Map<String, dynamic> json) =>
    DashboardThreadsModel(
      newThreads: json['newThreads'] as int?,
      threadsViews: json['threadsViews'] as int?,
      threadsInteractions: json['threadsInteractions'] as int?,
      threadsMentions: json['threadsMentions'] as int?,
    );

Map<String, dynamic> _$DashboardThreadsModelToJson(
        DashboardThreadsModel instance) =>
    <String, dynamic>{
      'newThreads': instance.newThreads,
      'threadsViews': instance.threadsViews,
      'threadsInteractions': instance.threadsInteractions,
      'threadsMentions': instance.threadsMentions,
    };
