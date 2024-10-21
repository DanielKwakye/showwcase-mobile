
import 'package:json_annotation/json_annotation.dart';

part 'show_markdown_block_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowMarkdownBlockModel {

  final String? markdown;
  final int? height;
  const ShowMarkdownBlockModel({
    this.markdown,
    this.height,
  });

  factory ShowMarkdownBlockModel.fromJson(Map<String, dynamic> json) => _$ShowMarkdownBlockModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowMarkdownBlockModelToJson(this);

}