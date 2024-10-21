import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/users/data/models/user_module_model.dart';

part 'user_tab_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserTabModel extends Equatable{
  final bool? visible;
  final bool? canEdit;
  final String? name;
  final String? id;
  final String? category;
  final bool? canHide;
  final List<UserModuleModel> modules;

  const UserTabModel({
    this.visible,
    this.canEdit,
    this.name,
    this.id,
    this.category,
    this.canHide,
    this.modules = const []
  });

  /// Connect the generated [_$UserTabModelFromJson] function to the `fromJson`
  /// factory.
  factory UserTabModel.fromJson(Map<String, dynamic> json) => _$UserTabModelFromJson(json);

  /// Connect the generated [_$UserTabModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserTabModelToJson(this);

  @override
  List<Object?> get props => [id, name, category, modules, visible, canEdit, canHide];


}