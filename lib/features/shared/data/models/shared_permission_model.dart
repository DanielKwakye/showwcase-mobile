import 'package:json_annotation/json_annotation.dart';

part 'shared_permission_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SharedPermissionsModel {
  const SharedPermissionsModel({
    this.admin,
    this.maintain,
    this.push,
    this.triage,
    this.pull,
  });

  final bool? admin;
  final bool? maintain;
  final bool? push;
  final bool? triage;
  final bool? pull;

  factory SharedPermissionsModel.fromJson(Map<String, dynamic> json) => _$SharedPermissionsModelFromJson(json);
  Map<String, dynamic> toJson() => _$SharedPermissionsModelToJson(this);

}