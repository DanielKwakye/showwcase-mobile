import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shared_gif_big_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SharedGifBigModel extends Equatable {
  const SharedGifBigModel({
    this.url,
    this.dims,
    this.size,
    this.preview,
  });

  final String? url;
  final List<int>? dims;
  final int? size;
  final String? preview;


  factory SharedGifBigModel.fromJson(Map<String, dynamic> json) => _$SharedGifBigModelFromJson(json);
  Map<String, dynamic> toJson() => _$SharedGifBigModelToJson(this);

  @override
  List<Object?> get props => [url, dims, size, preview];
}