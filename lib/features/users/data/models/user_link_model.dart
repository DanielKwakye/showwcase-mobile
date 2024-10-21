
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_link_model.g.dart';

@CopyWith()
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class UserLinkModel extends Equatable{
  final String? name;
  final String? label;
  final String? iconKey;
  final String? value;
  final int? id;
  final dynamic tooltip;

  const UserLinkModel({
    this.name,
    this.label,
    this.iconKey,
    this.value,
    this.id,
    this.tooltip,
  });

  /// Connect the generated [_$LinkModelFromJson] function to the `fromJson`
  /// factory.
  factory UserLinkModel.fromJson(Map<String, dynamic> json) => _$UserLinkModelFromJson(json);

  /// Connect the generated [_$LinkModelModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserLinkModelToJson(this);

  @override
  List<Object?> get props => [name, label, iconKey, value, id, tooltip];


}