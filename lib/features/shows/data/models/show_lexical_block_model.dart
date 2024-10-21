import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'show_lexical_block_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowLexicalBlockModel extends Equatable {

  const ShowLexicalBlockModel({
    required this.html,
    required this.editor,
  });

  final String? html;
  final String? editor;

  factory ShowLexicalBlockModel.fromJson(Map<String, dynamic> json) => _$ShowLexicalBlockModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowLexicalBlockModelToJson(this);

  @override
  List<Object?> get props => [html, editor];

}