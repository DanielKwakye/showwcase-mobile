import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shared_time_zone_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SharedTimeZoneModel extends Equatable {
  const SharedTimeZoneModel({
    this.label,
    this.value,
  });
  final String? label;
  final String? value;

  factory SharedTimeZoneModel.fromJson(Map<String, dynamic> json) => _$SharedTimeZoneModelFromJson(json);
  Map<String, dynamic> toJson() => _$SharedTimeZoneModelToJson(this);

  @override
  List<Object?> get props => [label, value];

}