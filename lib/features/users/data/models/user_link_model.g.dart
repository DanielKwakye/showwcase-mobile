// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_link_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserLinkModelCWProxy {
  UserLinkModel name(String? name);

  UserLinkModel label(String? label);

  UserLinkModel iconKey(String? iconKey);

  UserLinkModel value(String? value);

  UserLinkModel id(int? id);

  UserLinkModel tooltip(dynamic tooltip);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserLinkModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserLinkModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserLinkModel call({
    String? name,
    String? label,
    String? iconKey,
    String? value,
    int? id,
    dynamic tooltip,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserLinkModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserLinkModel.copyWith.fieldName(...)`
class _$UserLinkModelCWProxyImpl implements _$UserLinkModelCWProxy {
  const _$UserLinkModelCWProxyImpl(this._value);

  final UserLinkModel _value;

  @override
  UserLinkModel name(String? name) => this(name: name);

  @override
  UserLinkModel label(String? label) => this(label: label);

  @override
  UserLinkModel iconKey(String? iconKey) => this(iconKey: iconKey);

  @override
  UserLinkModel value(String? value) => this(value: value);

  @override
  UserLinkModel id(int? id) => this(id: id);

  @override
  UserLinkModel tooltip(dynamic tooltip) => this(tooltip: tooltip);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserLinkModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserLinkModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserLinkModel call({
    Object? name = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
    Object? iconKey = const $CopyWithPlaceholder(),
    Object? value = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? tooltip = const $CopyWithPlaceholder(),
  }) {
    return UserLinkModel(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      label: label == const $CopyWithPlaceholder()
          ? _value.label
          // ignore: cast_nullable_to_non_nullable
          : label as String?,
      iconKey: iconKey == const $CopyWithPlaceholder()
          ? _value.iconKey
          // ignore: cast_nullable_to_non_nullable
          : iconKey as String?,
      value: value == const $CopyWithPlaceholder()
          ? _value.value
          // ignore: cast_nullable_to_non_nullable
          : value as String?,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      tooltip: tooltip == const $CopyWithPlaceholder() || tooltip == null
          ? _value.tooltip
          // ignore: cast_nullable_to_non_nullable
          : tooltip as dynamic,
    );
  }
}

extension $UserLinkModelCopyWith on UserLinkModel {
  /// Returns a callable class that can be used as follows: `instanceOfUserLinkModel.copyWith(...)` or like so:`instanceOfUserLinkModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserLinkModelCWProxy get copyWith => _$UserLinkModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLinkModel _$UserLinkModelFromJson(Map<String, dynamic> json) =>
    UserLinkModel(
      name: json['name'] as String?,
      label: json['label'] as String?,
      iconKey: json['iconKey'] as String?,
      value: json['value'] as String?,
      id: json['id'] as int?,
      tooltip: json['tooltip'],
    );

Map<String, dynamic> _$UserLinkModelToJson(UserLinkModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('label', instance.label);
  writeNotNull('iconKey', instance.iconKey);
  writeNotNull('value', instance.value);
  writeNotNull('id', instance.id);
  writeNotNull('tooltip', instance.tooltip);
  return val;
}
