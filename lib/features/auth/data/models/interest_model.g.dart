// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interest_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$InterestModelCWProxy {
  InterestModel name(String name);

  InterestModel selected(bool selected);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InterestModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InterestModel(...).copyWith(id: 12, name: "My name")
  /// ````
  InterestModel call({
    String? name,
    bool? selected,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfInterestModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfInterestModel.copyWith.fieldName(...)`
class _$InterestModelCWProxyImpl implements _$InterestModelCWProxy {
  const _$InterestModelCWProxyImpl(this._value);

  final InterestModel _value;

  @override
  InterestModel name(String name) => this(name: name);

  @override
  InterestModel selected(bool selected) => this(selected: selected);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InterestModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InterestModel(...).copyWith(id: 12, name: "My name")
  /// ````
  InterestModel call({
    Object? name = const $CopyWithPlaceholder(),
    Object? selected = const $CopyWithPlaceholder(),
  }) {
    return InterestModel(
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      selected: selected == const $CopyWithPlaceholder() || selected == null
          ? _value.selected
          // ignore: cast_nullable_to_non_nullable
          : selected as bool,
    );
  }
}

extension $InterestModelCopyWith on InterestModel {
  /// Returns a callable class that can be used as follows: `instanceOfInterestModel.copyWith(...)` or like so:`instanceOfInterestModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$InterestModelCWProxy get copyWith => _$InterestModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InterestModel _$InterestModelFromJson(Map<String, dynamic> json) =>
    InterestModel(
      name: json['name'] as String,
      selected: json['selected'] as bool,
    );

Map<String, dynamic> _$InterestModelToJson(InterestModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'selected': instance.selected,
    };
