
import 'package:json_annotation/json_annotation.dart';

part 'community_category_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CommunityCategoryModel {
  const CommunityCategoryModel({
    this.id,
    this.name,
    this.slug,
  });

  final int? id;
  final String? name;
  final String? slug;

  factory CommunityCategoryModel.fromJson(Map<String, dynamic> json) => _$CommunityCategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommunityCategoryModelToJson(this);

}