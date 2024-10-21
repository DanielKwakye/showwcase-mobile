import 'package:json_annotation/json_annotation.dart';

part 'pre_signed_url_request.g.dart';

@JsonSerializable()
class PreSignedUrlRequest {
  const PreSignedUrlRequest({

    this.key,
    this.contentType,
    this.bucketName,
  });

  final String? key;
  final String? contentType;
  final String? bucketName;


  factory PreSignedUrlRequest.fromJson(Map<String, dynamic> json) => _$PreSignedUrlRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PreSignedUrlRequestToJson(this);

}