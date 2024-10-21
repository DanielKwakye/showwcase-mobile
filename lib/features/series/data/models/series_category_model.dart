import 'package:json_annotation/json_annotation.dart';

part 'series_category_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SeriesCategoryModel {

  const SeriesCategoryModel({
    this.id,
    this.name,
    this.slug,
  });

  final int? id;
  final String? name;
  final String? slug;

  factory SeriesCategoryModel.fromJson(Map<String, dynamic> json) => _$SeriesCategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$SeriesCategoryModelToJson(this);


}