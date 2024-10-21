// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shows_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ShowsStateCWProxy {
  ShowsState status(ShowsStatus status);

  ShowsState message(String message);

  ShowsState showCategories(List<ShowCategoryModel> showCategories);

  ShowsState shows(List<ShowModel> shows);

  ShowsState selectedShowCategory(ShowCategoryModel selectedShowCategory);

  ShowsState data(dynamic data);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShowsState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShowsState(...).copyWith(id: 12, name: "My name")
  /// ````
  ShowsState call({
    ShowsStatus? status,
    String? message,
    List<ShowCategoryModel>? showCategories,
    List<ShowModel>? shows,
    ShowCategoryModel? selectedShowCategory,
    dynamic data,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfShowsState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfShowsState.copyWith.fieldName(...)`
class _$ShowsStateCWProxyImpl implements _$ShowsStateCWProxy {
  const _$ShowsStateCWProxyImpl(this._value);

  final ShowsState _value;

  @override
  ShowsState status(ShowsStatus status) => this(status: status);

  @override
  ShowsState message(String message) => this(message: message);

  @override
  ShowsState showCategories(List<ShowCategoryModel> showCategories) =>
      this(showCategories: showCategories);

  @override
  ShowsState shows(List<ShowModel> shows) => this(shows: shows);

  @override
  ShowsState selectedShowCategory(ShowCategoryModel selectedShowCategory) =>
      this(selectedShowCategory: selectedShowCategory);

  @override
  ShowsState data(dynamic data) => this(data: data);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShowsState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShowsState(...).copyWith(id: 12, name: "My name")
  /// ````
  ShowsState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? showCategories = const $CopyWithPlaceholder(),
    Object? shows = const $CopyWithPlaceholder(),
    Object? selectedShowCategory = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
  }) {
    return ShowsState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as ShowsStatus,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      showCategories: showCategories == const $CopyWithPlaceholder() ||
              showCategories == null
          ? _value.showCategories
          // ignore: cast_nullable_to_non_nullable
          : showCategories as List<ShowCategoryModel>,
      shows: shows == const $CopyWithPlaceholder() || shows == null
          ? _value.shows
          // ignore: cast_nullable_to_non_nullable
          : shows as List<ShowModel>,
      selectedShowCategory:
          selectedShowCategory == const $CopyWithPlaceholder() ||
                  selectedShowCategory == null
              ? _value.selectedShowCategory
              // ignore: cast_nullable_to_non_nullable
              : selectedShowCategory as ShowCategoryModel,
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as dynamic,
    );
  }
}

extension $ShowsStateCopyWith on ShowsState {
  /// Returns a callable class that can be used as follows: `instanceOfShowsState.copyWith(...)` or like so:`instanceOfShowsState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ShowsStateCWProxy get copyWith => _$ShowsStateCWProxyImpl(this);
}
