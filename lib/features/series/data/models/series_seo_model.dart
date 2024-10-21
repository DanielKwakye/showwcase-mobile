import 'package:json_annotation/json_annotation.dart';

part 'series_seo_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SeriesSeoModel {
  const SeriesSeoModel({
    this.title,
    this.description,
  });

  final String? title;
  final String? description;

  factory SeriesSeoModel.fromJson(Map<String, dynamic> json) => _$SeriesSeoModelFromJson(json);
  Map<String, dynamic> toJson() => _$SeriesSeoModelToJson(this);

}