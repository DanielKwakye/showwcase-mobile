import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_module_model.g.dart';

@JsonSerializable()
class UserModuleModel extends Equatable {

  const UserModuleModel({
    this.id,
    this.name,
    this.visible,
    this.type,
    this.data,
  });

  final String? id;
  final String? name;
  final bool? visible;
  final String? type;
  final dynamic data;

  /// Connect the generated [_$UserModuleModelFromJson] function to the `fromJson`
  /// factory.
  factory UserModuleModel.fromJson(Map<String, dynamic> json) => _$UserModuleModelFromJson(json);

  /// Connect the generated [_$UserModuleModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserModuleModelToJson(this);

  @override
  List<Object?> get props => [id, name, type, visible];

}