
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/shows/data/models/show_link_model.dart';

part 'show_links_block_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowLinksBlockModel {

  final List<ShowLinkModel>? links;
  const ShowLinksBlockModel({this.links,});

  factory ShowLinksBlockModel.fromJson(Map<String, dynamic> json) => _$ShowLinksBlockModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowLinksBlockModelToJson(this);

}