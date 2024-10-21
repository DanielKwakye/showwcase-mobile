import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shared_social_link_model.g.dart';

@JsonSerializable()
class SharedSocialLinkIconModel extends Equatable {
  final int? id;
  final String? name;
  final String? label;
  final String? iconKey;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const SharedSocialLinkIconModel({this.id, this.name, this.label, this.iconKey, this.createdAt, this.updatedAt});

  @override
  List<Object?> get props => [id, name, label, iconKey];


  factory SharedSocialLinkIconModel.fromJson(Map<String, dynamic> json) => _$SharedSocialLinkIconModelFromJson(json);
  Map<String, dynamic> toJson() => _$SharedSocialLinkIconModelToJson(this);



}