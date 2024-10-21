// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_links_block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowLinksBlockModel _$ShowLinksBlockModelFromJson(Map<String, dynamic> json) =>
    ShowLinksBlockModel(
      links: (json['links'] as List<dynamic>?)
          ?.map((e) => ShowLinkModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShowLinksBlockModelToJson(
        ShowLinksBlockModel instance) =>
    <String, dynamic>{
      'links': instance.links?.map((e) => e.toJson()).toList(),
    };
