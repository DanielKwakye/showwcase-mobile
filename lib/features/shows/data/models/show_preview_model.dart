import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';

part 'show_preview_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowPreviewModel {
  const ShowPreviewModel({
    this.title,
    this.description,
    this.url,
    this.images,
    this.favicon,
    this.type,
    this.thread,
    this.show,
  });

  final String? title;
  final String? description;
  final String? url;
  final List<dynamic>? images;
  final String? favicon;
  final String? type;
  final ThreadModel? thread;
  final ShowModel? show;

  factory ShowPreviewModel.fromJson(Map<String, dynamic> json) => _$ShowPreviewModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowPreviewModelToJson(this);

}