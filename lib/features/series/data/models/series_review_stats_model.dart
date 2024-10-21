import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'series_review_stats_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SeriesReviewStatsModel extends Equatable {
  const SeriesReviewStatsModel({
    this.average,
    this.total,
    this.the0,
    this.the1,
    this.the2,
    this.the3,
    this.the4,
    this.the5,
  });

  @JsonKey(name: "0")
  final int? the0;
  @JsonKey(name: "1")
  final int? the1;
  @JsonKey(name: "2")
  final int? the2;
  @JsonKey(name: "3")
  final int? the3;
  @JsonKey(name: "4")
  final int? the4;
  @JsonKey(name: "5")
  final int? the5;
  final num? average;
  final num? total;

  factory SeriesReviewStatsModel.fromJson(Map<String, dynamic> json) => _$SeriesReviewStatsModelFromJson(json);
  Map<String, dynamic> toJson() => _$SeriesReviewStatsModelToJson(this);

  @override
  List<Object?> get props => [the0, the1, the2, the3, the4, the5, total, average];

}