// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_twitter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedTwitterModel _$SharedTwitterModelFromJson(Map<String, dynamic> json) =>
    SharedTwitterModel(
      url: json['url'] as String?,
      authorName: json['author_name'] as String?,
      authorUrl: json['author_url'] as String?,
      html: json['html'] as String?,
      width: json['width'] as int?,
      type: json['type'] as String?,
      cacheAge: json['cache_age'] as String?,
      providerName: json['provider_name'] as String?,
      providerUrl: json['provider_url'] as String?,
      version: json['version'] as String?,
    );

Map<String, dynamic> _$SharedTwitterModelToJson(SharedTwitterModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'author_name': instance.authorName,
      'author_url': instance.authorUrl,
      'html': instance.html,
      'width': instance.width,
      'type': instance.type,
      'cache_age': instance.cacheAge,
      'provider_name': instance.providerName,
      'provider_url': instance.providerUrl,
      'version': instance.version,
    };
