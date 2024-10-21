import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/users/data/models/user_job_preference_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_profile_onboarding_model.dart';

part 'user_settings_model.g.dart';

@CopyWith()
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class UserSettingsModel extends Equatable {

  final String? collaborateWith;
  final bool? collaborationDisabled;
  final bool? reasonForReachoutEnabled;
  final String? showView;
  final String? onboardingReason;

  @JsonKey(name: 'job_preferences')
  final UserJobPreferenceModel? jobPreferences;

  final UserProfileOnboardingModel? profileOnboarding;
  final String? customDomainLayout;


  const UserSettingsModel({
    this.collaborateWith,
    this.collaborationDisabled,
    this.reasonForReachoutEnabled,
    this.showView,
    this.onboardingReason,
    this.jobPreferences,
    this.profileOnboarding,
    this.customDomainLayout
  });

  /// Connect the generated [_$UserSettingsModelFromJson] function to the `fromJson`
  /// factory.
  factory UserSettingsModel.fromJson(Map<String, dynamic> json) => _$UserSettingsModelFromJson(json);

  /// Connect the generated [_$UserSettingsModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserSettingsModelToJson(this);

  @override
  List<Object?> get props => [jobPreferences, onboardingReason, customDomainLayout];
}