
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_repository_model.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_statistic_data_model.dart';

part 'show_statistic_block_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowStatisticBlockModel {

  const ShowStatisticBlockModel({
    this.selectedRepository,
    this.data,
  });

  final SharedRepositoryModel? selectedRepository;
  final SharedStatisticDataModel? data;

  factory ShowStatisticBlockModel.fromJson(Map<String, dynamic> json) => _$ShowStatisticBlockModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowStatisticBlockModelToJson(this);

}