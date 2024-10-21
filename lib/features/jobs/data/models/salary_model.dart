import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'salary_model.g.dart';

@JsonSerializable()
class SalaryModel extends Equatable {
  final num? from;
  final num? to;
  final String? range;
  final String? currency;

  const SalaryModel({
    this.from,
    this.to,
    this.range,
    this.currency
  });

  factory SalaryModel.fromJson(Map<String, dynamic> json) => _$SalaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$SalaryModelToJson(this);

  @override
  List<Object?> get props => [from, to, range, currency];

}