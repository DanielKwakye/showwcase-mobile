import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'show_category_model.g.dart';

@JsonSerializable()
class ShowCategoryModel extends Equatable{

  final String? name;
  final String? category;

  const ShowCategoryModel({this.name, this.category});

  factory ShowCategoryModel.fromJson(Map<String, dynamic> json) => _$ShowCategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowCategoryModelToJson(this);

  @override
  List<Object?> get props => [name, category];

}