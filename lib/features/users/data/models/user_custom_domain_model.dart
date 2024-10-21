import 'package:json_annotation/json_annotation.dart';

part 'user_custom_domain_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserCustomDomainModel {

  final int? id;
  final int? userId;
  final String? domain;
  final int? virtualId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserCustomDomainModel({
    this.id,
    this.userId,
    this.domain,
    this.virtualId,
    this.createdAt,
    this.updatedAt,
  });

  /// Connect the generated [_$UserCustomDomainModelFromJson] function to the `fromJson`
  /// factory.
  factory UserCustomDomainModel.fromJson(Map<String, dynamic> json) => _$UserCustomDomainModelFromJson(json);

  /// Connect the generated [_$UserCustomDomainModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserCustomDomainModelToJson(this);

}