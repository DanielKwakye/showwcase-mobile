import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/shows/data/models/show_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_lexical_block_model.dart';

part 'show_content_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowContentModel extends Equatable {
  const ShowContentModel({
    this.blocks,
    this.lexicalBlock,
    this.category,
    this.projectBlockType
  });

  final List<ShowBlockModel>? blocks;
  final ShowLexicalBlockModel? lexicalBlock;
  final String? category;
  final int? projectBlockType;

  factory ShowContentModel.fromJson(Map<String, dynamic> json) => _$ShowContentModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowContentModelToJson(this);

  @override
  List<Object?> get props => [projectBlockType, category, lexicalBlock, blocks];

}