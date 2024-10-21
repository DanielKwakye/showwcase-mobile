// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_filters_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$JobFiltersModelCWProxy {
  JobFiltersModel locations(List<Map<String, dynamic>>? locations);

  JobFiltersModel types(List<Map<String, dynamic>>? types);

  JobFiltersModel positions(List<Map<String, dynamic>>? positions);

  JobFiltersModel stacks(List<Map<String, dynamic>>? stacks);

  JobFiltersModel teamSizes(List<Map<String, dynamic>>? teamSizes);

  JobFiltersModel industries(List<Map<String, dynamic>>? industries);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobFiltersModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobFiltersModel(...).copyWith(id: 12, name: "My name")
  /// ````
  JobFiltersModel call({
    List<Map<String, dynamic>>? locations,
    List<Map<String, dynamic>>? types,
    List<Map<String, dynamic>>? positions,
    List<Map<String, dynamic>>? stacks,
    List<Map<String, dynamic>>? teamSizes,
    List<Map<String, dynamic>>? industries,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfJobFiltersModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfJobFiltersModel.copyWith.fieldName(...)`
class _$JobFiltersModelCWProxyImpl implements _$JobFiltersModelCWProxy {
  const _$JobFiltersModelCWProxyImpl(this._value);

  final JobFiltersModel _value;

  @override
  JobFiltersModel locations(List<Map<String, dynamic>>? locations) =>
      this(locations: locations);

  @override
  JobFiltersModel types(List<Map<String, dynamic>>? types) =>
      this(types: types);

  @override
  JobFiltersModel positions(List<Map<String, dynamic>>? positions) =>
      this(positions: positions);

  @override
  JobFiltersModel stacks(List<Map<String, dynamic>>? stacks) =>
      this(stacks: stacks);

  @override
  JobFiltersModel teamSizes(List<Map<String, dynamic>>? teamSizes) =>
      this(teamSizes: teamSizes);

  @override
  JobFiltersModel industries(List<Map<String, dynamic>>? industries) =>
      this(industries: industries);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobFiltersModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobFiltersModel(...).copyWith(id: 12, name: "My name")
  /// ````
  JobFiltersModel call({
    Object? locations = const $CopyWithPlaceholder(),
    Object? types = const $CopyWithPlaceholder(),
    Object? positions = const $CopyWithPlaceholder(),
    Object? stacks = const $CopyWithPlaceholder(),
    Object? teamSizes = const $CopyWithPlaceholder(),
    Object? industries = const $CopyWithPlaceholder(),
  }) {
    return JobFiltersModel(
      locations: locations == const $CopyWithPlaceholder()
          ? _value.locations
          // ignore: cast_nullable_to_non_nullable
          : locations as List<Map<String, dynamic>>?,
      types: types == const $CopyWithPlaceholder()
          ? _value.types
          // ignore: cast_nullable_to_non_nullable
          : types as List<Map<String, dynamic>>?,
      positions: positions == const $CopyWithPlaceholder()
          ? _value.positions
          // ignore: cast_nullable_to_non_nullable
          : positions as List<Map<String, dynamic>>?,
      stacks: stacks == const $CopyWithPlaceholder()
          ? _value.stacks
          // ignore: cast_nullable_to_non_nullable
          : stacks as List<Map<String, dynamic>>?,
      teamSizes: teamSizes == const $CopyWithPlaceholder()
          ? _value.teamSizes
          // ignore: cast_nullable_to_non_nullable
          : teamSizes as List<Map<String, dynamic>>?,
      industries: industries == const $CopyWithPlaceholder()
          ? _value.industries
          // ignore: cast_nullable_to_non_nullable
          : industries as List<Map<String, dynamic>>?,
    );
  }
}

extension $JobFiltersModelCopyWith on JobFiltersModel {
  /// Returns a callable class that can be used as follows: `instanceOfJobFiltersModel.copyWith(...)` or like so:`instanceOfJobFiltersModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$JobFiltersModelCWProxy get copyWith => _$JobFiltersModelCWProxyImpl(this);
}
