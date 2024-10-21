import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_repository_collaborator_model.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_statistic_data_indicator_model.dart';

part 'shared_statistic_data_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SharedStatisticDataModel {
  const SharedStatisticDataModel({
    this.indicators,
    this.indicatorsVisible,
    this.languages,
    this.languagesVisible,
    this.collaborators,
  });

  final List<SharedStatisticDataIndicatorModel>? indicators;
  final bool? indicatorsVisible;
  final Map<String, dynamic>? languages;
  final bool? languagesVisible;
  final List<SharedRepositoryCollaboratorModel>? collaborators;

  factory SharedStatisticDataModel.fromJson(Map<String, dynamic> json) => _$SharedStatisticDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$SharedStatisticDataModelToJson(this);
  
}