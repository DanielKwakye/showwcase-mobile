import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/shows/data/models/blocks/show_image_block_model.dart';

part 'show_gallery_block_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowGalleryBlockModel {

  const ShowGalleryBlockModel({
    this.images,
  });

  final List<ShowImageBlockModel>? images;


  factory ShowGalleryBlockModel.fromJson(Map<String, dynamic> json) => _$ShowGalleryBlockModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowGalleryBlockModelToJson(this);

}