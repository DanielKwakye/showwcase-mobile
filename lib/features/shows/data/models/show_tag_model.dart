import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/communities/data/models/community_tag_model.dart';

part 'show_tag_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowTagModel extends Equatable {

  const ShowTagModel({
    this.id,
    this.tagDescription,
    this.createdAt,
    this.updatedAt,
    this.communityTag,
  });

  final int? id;
  final String? tagDescription;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CommunityTagModel? communityTag;

  factory ShowTagModel.fromJson(Map<String, dynamic> json) => _$ShowTagModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowTagModelToJson(this);

  @override
  List<Object?> get props => [id, tagDescription];

}