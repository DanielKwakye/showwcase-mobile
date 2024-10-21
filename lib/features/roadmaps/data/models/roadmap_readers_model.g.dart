// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap_readers_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoadmapReadersModel _$RoadmapReadersModelFromJson(Map<String, dynamic> json) =>
    RoadmapReadersModel(
      numberOfReaders: json['numberOfReaders'] as int?,
      readers: (json['readers'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoadmapReadersModelToJson(
        RoadmapReadersModel instance) =>
    <String, dynamic>{
      'numberOfReaders': instance.numberOfReaders,
      'readers': instance.readers?.map((e) => e.toJson()).toList(),
    };
