// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_engagement_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EngagementModelCWProxy {
  EngagementModel totalThreadReplies(int? totalThreadReplies);

  EngagementModel totalThreadUpvotes(int? totalThreadUpvotes);

  EngagementModel totalPublishedShows(int? totalPublishedShows);

  EngagementModel totalPublishedSeries(int? totalPublishedSeries);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EngagementModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EngagementModel(...).copyWith(id: 12, name: "My name")
  /// ````
  EngagementModel call({
    int? totalThreadReplies,
    int? totalThreadUpvotes,
    int? totalPublishedShows,
    int? totalPublishedSeries,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfEngagementModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfEngagementModel.copyWith.fieldName(...)`
class _$EngagementModelCWProxyImpl implements _$EngagementModelCWProxy {
  const _$EngagementModelCWProxyImpl(this._value);

  final EngagementModel _value;

  @override
  EngagementModel totalThreadReplies(int? totalThreadReplies) =>
      this(totalThreadReplies: totalThreadReplies);

  @override
  EngagementModel totalThreadUpvotes(int? totalThreadUpvotes) =>
      this(totalThreadUpvotes: totalThreadUpvotes);

  @override
  EngagementModel totalPublishedShows(int? totalPublishedShows) =>
      this(totalPublishedShows: totalPublishedShows);

  @override
  EngagementModel totalPublishedSeries(int? totalPublishedSeries) =>
      this(totalPublishedSeries: totalPublishedSeries);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EngagementModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EngagementModel(...).copyWith(id: 12, name: "My name")
  /// ````
  EngagementModel call({
    Object? totalThreadReplies = const $CopyWithPlaceholder(),
    Object? totalThreadUpvotes = const $CopyWithPlaceholder(),
    Object? totalPublishedShows = const $CopyWithPlaceholder(),
    Object? totalPublishedSeries = const $CopyWithPlaceholder(),
  }) {
    return EngagementModel(
      totalThreadReplies: totalThreadReplies == const $CopyWithPlaceholder()
          ? _value.totalThreadReplies
          // ignore: cast_nullable_to_non_nullable
          : totalThreadReplies as int?,
      totalThreadUpvotes: totalThreadUpvotes == const $CopyWithPlaceholder()
          ? _value.totalThreadUpvotes
          // ignore: cast_nullable_to_non_nullable
          : totalThreadUpvotes as int?,
      totalPublishedShows: totalPublishedShows == const $CopyWithPlaceholder()
          ? _value.totalPublishedShows
          // ignore: cast_nullable_to_non_nullable
          : totalPublishedShows as int?,
      totalPublishedSeries: totalPublishedSeries == const $CopyWithPlaceholder()
          ? _value.totalPublishedSeries
          // ignore: cast_nullable_to_non_nullable
          : totalPublishedSeries as int?,
    );
  }
}

extension $EngagementModelCopyWith on EngagementModel {
  /// Returns a callable class that can be used as follows: `instanceOfEngagementModel.copyWith(...)` or like so:`instanceOfEngagementModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EngagementModelCWProxy get copyWith => _$EngagementModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EngagementModel _$EngagementModelFromJson(Map<String, dynamic> json) =>
    EngagementModel(
      totalThreadReplies: json['totalThreadReplies'] as int?,
      totalThreadUpvotes: json['totalThreadUpvotes'] as int?,
      totalPublishedShows: json['totalPublishedShows'] as int?,
      totalPublishedSeries: json['totalPublishedSeries'] as int?,
    );

Map<String, dynamic> _$EngagementModelToJson(EngagementModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('totalThreadReplies', instance.totalThreadReplies);
  writeNotNull('totalThreadUpvotes', instance.totalThreadUpvotes);
  writeNotNull('totalPublishedShows', instance.totalPublishedShows);
  writeNotNull('totalPublishedSeries', instance.totalPublishedSeries);
  return val;
}
