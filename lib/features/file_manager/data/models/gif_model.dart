import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_gif_big_model.dart';

part 'gif_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GifModel {

  const GifModel({
    this.big,
    this.tiny,
  });

  final SharedGifBigModel? big;
  final SharedGifBigModel? tiny;


  factory GifModel.fromJson(Map<String, dynamic> json) => _$GifModelFromJson(json);
  Map<String, dynamic> toJson() => _$GifModelToJson(this);

}


