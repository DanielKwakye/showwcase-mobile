import 'package:json_annotation/json_annotation.dart';

part 'show_reading_stats_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowReadingStatsModel {

  const ShowReadingStatsModel({
    this.text,
    this.time,
    this.words,
    this.minutes,
  });

  final String? text;
  final num? time;
  final num? words;
  final num? minutes;

  factory ShowReadingStatsModel.fromJson(Map<String, dynamic> json) => _$ShowReadingStatsModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowReadingStatsModelToJson(this);

}