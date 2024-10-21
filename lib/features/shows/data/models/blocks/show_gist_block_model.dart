
import 'package:json_annotation/json_annotation.dart';

part 'show_gist_block_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowGistBlockModel {

  final String? gistURL;
  final String? fileName;

  const ShowGistBlockModel({
    this.gistURL,
    this.fileName,
  });

  factory ShowGistBlockModel.fromJson(Map<String, dynamic> json) => _$ShowGistBlockModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowGistBlockModelToJson(this);

}