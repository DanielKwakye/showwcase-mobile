import 'package:json_annotation/json_annotation.dart';

part 'series_settings_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SeriesSettingsModel {
  SeriesSettingsModel({
    this.enableReview,
    this.enableProgress,
    this.language
  });

  final bool? enableReview;
  final bool? enableProgress;
  final String? language;

  factory SeriesSettingsModel.fromJson(Map<String, dynamic> json) => _$SeriesSettingsModelFromJson(json);
  Map<String, dynamic> toJson() => _$SeriesSettingsModelToJson(this);
}