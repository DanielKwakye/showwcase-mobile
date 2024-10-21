// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_preview_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CommunityPreviewStateCWProxy {
  CommunityPreviewState status(CommunityStatus status);

  CommunityPreviewState message(String message);

  CommunityPreviewState communityPreviews(
      List<CommunityModel> communityPreviews);

  CommunityPreviewState communityTags(
      Map<int, List<CommunityThreadTagsModel>> communityTags);

  CommunityPreviewState selectedCommunityTag(
      CommunityThreadTagsModel selectedCommunityTag);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CommunityPreviewState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CommunityPreviewState(...).copyWith(id: 12, name: "My name")
  /// ````
  CommunityPreviewState call({
    CommunityStatus? status,
    String? message,
    List<CommunityModel>? communityPreviews,
    Map<int, List<CommunityThreadTagsModel>>? communityTags,
    CommunityThreadTagsModel? selectedCommunityTag,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCommunityPreviewState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCommunityPreviewState.copyWith.fieldName(...)`
class _$CommunityPreviewStateCWProxyImpl
    implements _$CommunityPreviewStateCWProxy {
  const _$CommunityPreviewStateCWProxyImpl(this._value);

  final CommunityPreviewState _value;

  @override
  CommunityPreviewState status(CommunityStatus status) => this(status: status);

  @override
  CommunityPreviewState message(String message) => this(message: message);

  @override
  CommunityPreviewState communityPreviews(
          List<CommunityModel> communityPreviews) =>
      this(communityPreviews: communityPreviews);

  @override
  CommunityPreviewState communityTags(
          Map<int, List<CommunityThreadTagsModel>> communityTags) =>
      this(communityTags: communityTags);

  @override
  CommunityPreviewState selectedCommunityTag(
          CommunityThreadTagsModel selectedCommunityTag) =>
      this(selectedCommunityTag: selectedCommunityTag);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CommunityPreviewState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CommunityPreviewState(...).copyWith(id: 12, name: "My name")
  /// ````
  CommunityPreviewState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? communityPreviews = const $CopyWithPlaceholder(),
    Object? communityTags = const $CopyWithPlaceholder(),
    Object? selectedCommunityTag = const $CopyWithPlaceholder(),
  }) {
    return CommunityPreviewState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as CommunityStatus,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      communityPreviews: communityPreviews == const $CopyWithPlaceholder() ||
              communityPreviews == null
          ? _value.communityPreviews
          // ignore: cast_nullable_to_non_nullable
          : communityPreviews as List<CommunityModel>,
      communityTags:
          communityTags == const $CopyWithPlaceholder() || communityTags == null
              ? _value.communityTags
              // ignore: cast_nullable_to_non_nullable
              : communityTags as Map<int, List<CommunityThreadTagsModel>>,
      selectedCommunityTag:
          selectedCommunityTag == const $CopyWithPlaceholder() ||
                  selectedCommunityTag == null
              ? _value.selectedCommunityTag
              // ignore: cast_nullable_to_non_nullable
              : selectedCommunityTag as CommunityThreadTagsModel,
    );
  }
}

extension $CommunityPreviewStateCopyWith on CommunityPreviewState {
  /// Returns a callable class that can be used as follows: `instanceOfCommunityPreviewState.copyWith(...)` or like so:`instanceOfCommunityPreviewState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CommunityPreviewStateCWProxy get copyWith =>
      _$CommunityPreviewStateCWProxyImpl(this);
}
