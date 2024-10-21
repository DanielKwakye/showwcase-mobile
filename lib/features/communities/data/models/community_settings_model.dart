import 'package:json_annotation/json_annotation.dart';

part 'community_settings_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CommunitySettingsModel {
  const CommunitySettingsModel({
    this.rules,
  });

  final String? rules;

  factory CommunitySettingsModel.fromJson(Map<String, dynamic> json) => _$CommunitySettingsModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommunitySettingsModelToJson(this);
  
}