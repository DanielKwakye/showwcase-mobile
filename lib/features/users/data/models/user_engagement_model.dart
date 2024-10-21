
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_engagement_model.g.dart';

@CopyWith()
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class EngagementModel extends Equatable {
  final int? totalThreadReplies;
  final int? totalThreadUpvotes;
  final int? totalPublishedShows;
  final int? totalPublishedSeries;

  const EngagementModel({
    this.totalThreadReplies,
    this.totalThreadUpvotes,
    this.totalPublishedShows,
    this.totalPublishedSeries,
  });

  factory EngagementModel.fromJson(Map<String, dynamic> json) => _$EngagementModelFromJson(json);

  Map<String, dynamic> toJson() => _$EngagementModelToJson(this);

  @override
  List<Object?> get props => [
    totalThreadReplies,
    totalThreadUpvotes,
    totalPublishedShows,
    totalPublishedSeries,
  ];
}