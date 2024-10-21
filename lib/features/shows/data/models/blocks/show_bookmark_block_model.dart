
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_preview_model.dart';

part 'show_bookmark_block_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowBookmarkBlockModel {

  const ShowBookmarkBlockModel({
    this.preview,
  });

  final SharedPreviewModel? preview;

  factory ShowBookmarkBlockModel.fromJson(Map<String, dynamic> json) => _$ShowBookmarkBlockModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowBookmarkBlockModelToJson(this);

}