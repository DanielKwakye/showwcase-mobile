// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_filters_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$JobFiltersResponseCWProxy {
  JobFiltersResponse locations(List<Map<String, dynamic>>? locations);

  JobFiltersResponse types(List<Map<String, dynamic>>? types);

  JobFiltersResponse positions(List<Map<String, dynamic>>? positions);

  JobFiltersResponse stacks(List<Map<String, dynamic>>? stacks);

  JobFiltersResponse teamSizes(List<Map<String, dynamic>>? teamSizes);

  JobFiltersResponse industries(List<Map<String, dynamic>>? industries);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobFiltersResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobFiltersResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  JobFiltersResponse call({
    List<Map<String, dynamic>>? locations,
    List<Map<String, dynamic>>? types,
    List<Map<String, dynamic>>? positions,
    List<Map<String, dynamic>>? stacks,
    List<Map<String, dynamic>>? teamSizes,
    List<Map<String, dynamic>>? industries,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfJobFiltersResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfJobFiltersResponse.copyWith.fieldName(...)`
class _$JobFiltersResponseCWProxyImpl implements _$JobFiltersResponseCWProxy {
  const _$JobFiltersResponseCWProxyImpl(this._value);

  final JobFiltersResponse _value;

  @override
  JobFiltersResponse locations(List<Map<String, dynamic>>? locations) =>
      this(locations: locations);

  @override
  JobFiltersResponse types(List<Map<String, dynamic>>? types) =>
      this(types: types);

  @override
  JobFiltersResponse positions(List<Map<String, dynamic>>? positions) =>
      this(positions: positions);

  @override
  JobFiltersResponse stacks(List<Map<String, dynamic>>? stacks) =>
      this(stacks: stacks);

  @override
  JobFiltersResponse teamSizes(List<Map<String, dynamic>>? teamSizes) =>
      this(teamSizes: teamSizes);

  @override
  JobFiltersResponse industries(List<Map<String, dynamic>>? industries) =>
      this(industries: industries);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobFiltersResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobFiltersResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  JobFiltersResponse call({
    Object? locations = const $CopyWithPlaceholder(),
    Object? types = const $CopyWithPlaceholder(),
    Object? positions = const $CopyWithPlaceholder(),
    Object? stacks = const $CopyWithPlaceholder(),
    Object? teamSizes = const $CopyWithPlaceholder(),
    Object? industries = const $CopyWithPlaceholder(),
  }) {
    return JobFiltersResponse(
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

extension $JobFiltersResponseCopyWith on JobFiltersResponse {
  /// Returns a callable class that can be used as follows: `instanceOfJobFiltersResponse.copyWith(...)` or like so:`instanceOfJobFiltersResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$JobFiltersResponseCWProxy get copyWith =>
      _$JobFiltersResponseCWProxyImpl(this);
}

abstract class _$IndustryCWProxy {
  Industry id(int? id);

  Industry name(String? name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Industry(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Industry(...).copyWith(id: 12, name: "My name")
  /// ````
  Industry call({
    int? id,
    String? name,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfIndustry.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfIndustry.copyWith.fieldName(...)`
class _$IndustryCWProxyImpl implements _$IndustryCWProxy {
  const _$IndustryCWProxyImpl(this._value);

  final Industry _value;

  @override
  Industry id(int? id) => this(id: id);

  @override
  Industry name(String? name) => this(name: name);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Industry(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Industry(...).copyWith(id: 12, name: "My name")
  /// ````
  Industry call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return Industry(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
    );
  }
}

extension $IndustryCopyWith on Industry {
  /// Returns a callable class that can be used as follows: `instanceOfIndustry.copyWith(...)` or like so:`instanceOfIndustry.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$IndustryCWProxy get copyWith => _$IndustryCWProxyImpl(this);
}

abstract class _$StackCWProxy {
  Stack id(int? id);

  Stack name(String? name);

  Stack icon(String? icon);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Stack(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Stack(...).copyWith(id: 12, name: "My name")
  /// ````
  Stack call({
    int? id,
    String? name,
    String? icon,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStack.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStack.copyWith.fieldName(...)`
class _$StackCWProxyImpl implements _$StackCWProxy {
  const _$StackCWProxyImpl(this._value);

  final Stack _value;

  @override
  Stack id(int? id) => this(id: id);

  @override
  Stack name(String? name) => this(name: name);

  @override
  Stack icon(String? icon) => this(icon: icon);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Stack(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Stack(...).copyWith(id: 12, name: "My name")
  /// ````
  Stack call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? icon = const $CopyWithPlaceholder(),
  }) {
    return Stack(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      icon: icon == const $CopyWithPlaceholder()
          ? _value.icon
          // ignore: cast_nullable_to_non_nullable
          : icon as String?,
    );
  }
}

extension $StackCopyWith on Stack {
  /// Returns a callable class that can be used as follows: `instanceOfStack.copyWith(...)` or like so:`instanceOfStack.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StackCWProxy get copyWith => _$StackCWProxyImpl(this);
}

abstract class _$TeamSizeCWProxy {
  TeamSize id(int? id);

  TeamSize value(String? value);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TeamSize(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TeamSize(...).copyWith(id: 12, name: "My name")
  /// ````
  TeamSize call({
    int? id,
    String? value,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTeamSize.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTeamSize.copyWith.fieldName(...)`
class _$TeamSizeCWProxyImpl implements _$TeamSizeCWProxy {
  const _$TeamSizeCWProxyImpl(this._value);

  final TeamSize _value;

  @override
  TeamSize id(int? id) => this(id: id);

  @override
  TeamSize value(String? value) => this(value: value);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TeamSize(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TeamSize(...).copyWith(id: 12, name: "My name")
  /// ````
  TeamSize call({
    Object? id = const $CopyWithPlaceholder(),
    Object? value = const $CopyWithPlaceholder(),
  }) {
    return TeamSize(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      value: value == const $CopyWithPlaceholder()
          ? _value.value
          // ignore: cast_nullable_to_non_nullable
          : value as String?,
    );
  }
}

extension $TeamSizeCopyWith on TeamSize {
  /// Returns a callable class that can be used as follows: `instanceOfTeamSize.copyWith(...)` or like so:`instanceOfTeamSize.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TeamSizeCWProxy get copyWith => _$TeamSizeCWProxyImpl(this);
}

abstract class _$TypeCWProxy {
  Type value(String? value);

  Type label(String? label);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Type(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Type(...).copyWith(id: 12, name: "My name")
  /// ````
  Type call({
    String? value,
    String? label,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfType.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfType.copyWith.fieldName(...)`
class _$TypeCWProxyImpl implements _$TypeCWProxy {
  const _$TypeCWProxyImpl(this._value);

  final Type _value;

  @override
  Type value(String? value) => this(value: value);

  @override
  Type label(String? label) => this(label: label);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Type(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Type(...).copyWith(id: 12, name: "My name")
  /// ````
  Type call({
    Object? value = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
  }) {
    return Type(
      value: value == const $CopyWithPlaceholder()
          ? _value.value
          // ignore: cast_nullable_to_non_nullable
          : value as String?,
      label: label == const $CopyWithPlaceholder()
          ? _value.label
          // ignore: cast_nullable_to_non_nullable
          : label as String?,
    );
  }
}

extension $TypeCopyWith on Type {
  /// Returns a callable class that can be used as follows: `instanceOfType.copyWith(...)` or like so:`instanceOfType.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TypeCWProxy get copyWith => _$TypeCWProxyImpl(this);
}
