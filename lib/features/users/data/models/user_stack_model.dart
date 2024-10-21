import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_stack_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserStackModel extends Equatable{
  final int? id;
  final String? category;
  @JsonKey(name: 'sub_category')
  final String? subCategory;
  final String? description;
  final String? name;
  final String? icon;
  final String? iconUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isMatched;

  const UserStackModel({
    this.id,
    this.category,
    this.subCategory,
    this.description,
    this.name,
    this.icon,
    this.iconUrl,
    this.createdAt,
    this.updatedAt,
    this.isMatched
  });

  factory UserStackModel.fromJson(Map<String, dynamic> json) => _$UserStackModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserStackModelToJson(this);

  @override
  List<Object?> get props =>  [id, name];

}