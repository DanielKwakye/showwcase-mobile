import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/file_manager/data/models/pre_signed_url_fields.dart';

part 'pre_signed_url_response.g.dart';

@CopyWith()
@JsonSerializable(explicitToJson: true)
class PreSignedUrlResponse {

  const PreSignedUrlResponse({
    this.url,
    this.preSignedUrlFields,
  });

  final String? url;

  @JsonKey(name: 'fields')
  final PreSignedUrlFields? preSignedUrlFields;

  factory PreSignedUrlResponse.fromJson(Map<String, dynamic> json) => _$PreSignedUrlResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PreSignedUrlResponseToJson(this);

}
