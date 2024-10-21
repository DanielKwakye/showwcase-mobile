import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'company_size_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CompanySizeModel extends Equatable {

  final int? id;
  final String? label;
  final String? value;
  final int? offset;

  const CompanySizeModel({
    this.id,
    this.label,
    this.value,
    this.offset,
  });

  factory CompanySizeModel.fromJson(Map<String, dynamic> json) => _$CompanySizeModelFromJson(json);
  Map<String, dynamic> toJson() => _$CompanySizeModelToJson(this);

  @override
  List<Object?> get props => [id,label,value, offset];

}