import 'package:json_annotation/json_annotation.dart';

part 'pre_signed_url_fields.g.dart';

@JsonSerializable(explicitToJson: true)
class PreSignedUrlFields {
  const PreSignedUrlFields({
    this.contentType,
    this.key,
    this.bucket,
    this.xAmzAlgorithm,
    this.xAmzCredential,
    this.xAmzDate,
    this.policy,
    this.xAmzSignature,
    this.xAmzSecurityToken
  });

  @JsonKey(name: 'Content-Type')
  final String? contentType;
  @JsonKey(name: 'key')
  final String? key;
  @JsonKey(name: 'bucket')
  final String? bucket;
  @JsonKey(name: 'X-Amz-Algorithm')
  final String? xAmzAlgorithm;
  @JsonKey(name: 'X-Amz-Credential')
  final String? xAmzCredential;
  @JsonKey(name: 'X-Amz-Date')
  final String? xAmzDate;
  @JsonKey(name: 'Policy')
  final String? policy;
  @JsonKey(name: 'X-Amz-Signature')
  final String? xAmzSignature;
  @JsonKey(name: 'X-Amz-Security-Token')
  final String? xAmzSecurityToken;

  factory PreSignedUrlFields.fromJson(Map<String, dynamic> json) => _$PreSignedUrlFieldsFromJson(json);
  Map<String, dynamic> toJson() => _$PreSignedUrlFieldsToJson(this);

}