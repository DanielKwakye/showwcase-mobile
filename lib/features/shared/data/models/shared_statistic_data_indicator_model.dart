import 'package:json_annotation/json_annotation.dart';

part 'shared_statistic_data_indicator_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SharedStatisticDataIndicatorModel {
  final String? label;
  final bool? visible;
  final int? value;
  final bool? isOther;

  const SharedStatisticDataIndicatorModel({
    this.label,
    this.visible,
    this.value,
    this.isOther,
  });

  factory SharedStatisticDataIndicatorModel.fromJson(Map<String, dynamic> json) => _$SharedStatisticDataIndicatorModelFromJson(json);
  Map<String, dynamic> toJson() => _$SharedStatisticDataIndicatorModelToJson(this);
  
  
}