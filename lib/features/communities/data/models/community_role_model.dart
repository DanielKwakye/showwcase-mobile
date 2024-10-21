import 'package:json_annotation/json_annotation.dart';

part 'community_role_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CommunityRoleModel {

  const CommunityRoleModel({
    this.id,
    this.name,
    this.color,
  });

  final int? id;
  final String? name;
  final String? color;

  factory CommunityRoleModel.fromJson(Map<String, dynamic> json) => _$CommunityRoleModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommunityRoleModelToJson(this);

}