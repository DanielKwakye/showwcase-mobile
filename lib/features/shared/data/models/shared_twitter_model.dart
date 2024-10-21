import 'package:json_annotation/json_annotation.dart';

part 'shared_twitter_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SharedTwitterModel {
  const SharedTwitterModel({
    this.url,
    this.authorName,
    this.authorUrl,
    this.html,
    this.width,
    this.type,
    this.cacheAge,
    this.providerName,
    this.providerUrl,
    this.version,
  });

  final String? url;
  @JsonKey(name: 'author_name')
  final String? authorName;
  @JsonKey(name: 'author_url')
  final String? authorUrl;
  final String? html;
  final int? width;
  final String? type;
  @JsonKey(name: 'cache_age')
  final String? cacheAge;
  @JsonKey(name: 'provider_name')
  final String? providerName;
  @JsonKey(name: 'provider_url')
  final String? providerUrl;
  final String? version;

  factory SharedTwitterModel.fromJson(Map<String, dynamic> json) => _$SharedTwitterModelFromJson(json);
  Map<String, dynamic> toJson() => _$SharedTwitterModelToJson(this);
  
}