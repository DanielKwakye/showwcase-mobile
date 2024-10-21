import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_certification_model.g.dart';

@JsonSerializable()
@CopyWith()
class UserCertificationModel {

  final int? id;
  final int? userId;
  final String? title;
  final int? organizationId;
  final String? organizationName;
  final String? organizationLogo;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? current;
  final String? credentialId;
  final String? url;
  final String? attachmentUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserCertificationModel({
    this.id,
    this.userId,
    this.title,
    this.organizationId,
    this.organizationName,
    this.organizationLogo,
    this.startDate,
    this.endDate,
    this.current,
    this.credentialId,
    this.url,
    this.attachmentUrl,
    this.createdAt,
    this.updatedAt,
  });

  /// Connect the generated [_$UserCertificationModelFromJson] function to the `fromJson`
  /// factory.
  factory UserCertificationModel.fromJson(Map<String, dynamic> json) => _$UserCertificationModelFromJson(json);

  /// Connect the generated [_$UserCertificationModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserCertificationModelToJson(this);


}