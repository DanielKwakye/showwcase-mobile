
import 'package:json_annotation/json_annotation.dart';

part 'show_text_block_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowTextBlockModel {


  const ShowTextBlockModel({
    this.value,
    this.style,
    this.numberedCount,
  });

  final String? value;
  final int? style;
  final int? numberedCount;

  factory ShowTextBlockModel.fromJson(Map<String, dynamic> json) => _$ShowTextBlockModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowTextBlockModelToJson(this);

}