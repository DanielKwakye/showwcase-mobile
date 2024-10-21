import 'package:json_annotation/json_annotation.dart';

part 'shared_code_block_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SharedCodeBlockModel {

  const SharedCodeBlockModel({
    this.code,
    this.language,
  });

  final String? code;
  final String? language;

  factory SharedCodeBlockModel.fromJson(Map<String, dynamic> json) => _$SharedCodeBlockModelFromJson(json);
  Map<String, dynamic> toJson() => _$SharedCodeBlockModelToJson(this);

}