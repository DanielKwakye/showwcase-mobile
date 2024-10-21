// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CommunityStateCWProxy {
  CommunityState status(CommunityStatus status);

  CommunityState message(String message);

  CommunityState communityDetails(CommunityModel? communityDetails);

  CommunityState communities(List<CommunityModel> communities);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CommunityState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CommunityState(...).copyWith(id: 12, name: "My name")
  /// ````
  CommunityState call({
    CommunityStatus? status,
    String? message,
    CommunityModel? communityDetails,
    List<CommunityModel>? communities,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCommunityState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCommunityState.copyWith.fieldName(...)`
class _$CommunityStateCWProxyImpl implements _$CommunityStateCWProxy {
  const _$CommunityStateCWProxyImpl(this._value);

  final CommunityState _value;

  @override
  CommunityState status(CommunityStatus status) => this(status: status);

  @override
  CommunityState message(String message) => this(message: message);

  @override
  CommunityState communityDetails(CommunityModel? communityDetails) =>
      this(communityDetails: communityDetails);

  @override
  CommunityState communities(List<CommunityModel> communities) =>
      this(communities: communities);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CommunityState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CommunityState(...).copyWith(id: 12, name: "My name")
  /// ````
  CommunityState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? communityDetails = const $CopyWithPlaceholder(),
    Object? communities = const $CopyWithPlaceholder(),
  }) {
    return CommunityState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as CommunityStatus,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      communityDetails: communityDetails == const $CopyWithPlaceholder()
          ? _value.communityDetails
          // ignore: cast_nullable_to_non_nullable
          : communityDetails as CommunityModel?,
      communities:
          communities == const $CopyWithPlaceholder() || communities == null
              ? _value.communities
              // ignore: cast_nullable_to_non_nullable
              : communities as List<CommunityModel>,
    );
  }
}

extension $CommunityStateCopyWith on CommunityState {
  /// Returns a callable class that can be used as follows: `instanceOfCommunityState.copyWith(...)` or like so:`instanceOfCommunityState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CommunityStateCWProxy get copyWith => _$CommunityStateCWProxyImpl(this);
}
