import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dashboard_thread_model.g.dart';


@CopyWith()
@JsonSerializable(explicitToJson: true)
class DashboardThreadsModel  extends Equatable{
  const DashboardThreadsModel({
    this.newThreads,
    this.threadsViews,
    this.threadsInteractions,
    this.threadsMentions,
  });

  final int? newThreads;
  final int? threadsViews;
  final int? threadsInteractions;
  final int? threadsMentions;

  factory DashboardThreadsModel.fromJson(Map<String, dynamic> json) => _$DashboardThreadsModelFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardThreadsModelToJson(this);

  @override
  List<Object?> get props => [newThreads, threadsViews, threadsInteractions, threadsMentions];

}
