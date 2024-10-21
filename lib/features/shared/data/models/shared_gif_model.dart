import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_gif_big_model.dart';

part 'shared_gif_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SharedGifModel extends Equatable {

  const SharedGifModel({
    this.big,
    this.tiny,
  });

  final SharedGifBigModel? big;
  final SharedGifBigModel? tiny;


  factory SharedGifModel.fromJson(Map<String, dynamic> json) => _$SharedGifModelFromJson(json);
  Map<String, dynamic> toJson() => _$SharedGifModelToJson(this);

  @override

  List<Object?> get props => [big, tiny];

}


