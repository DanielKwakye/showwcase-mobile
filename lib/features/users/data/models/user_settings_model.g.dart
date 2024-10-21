// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserSettingsModelCWProxy {
  UserSettingsModel collaborateWith(String? collaborateWith);

  UserSettingsModel collaborationDisabled(bool? collaborationDisabled);

  UserSettingsModel reasonForReachoutEnabled(bool? reasonForReachoutEnabled);

  UserSettingsModel showView(String? showView);

  UserSettingsModel onboardingReason(String? onboardingReason);

  UserSettingsModel jobPreferences(UserJobPreferenceModel? jobPreferences);

  UserSettingsModel profileOnboarding(
      UserProfileOnboardingModel? profileOnboarding);

  UserSettingsModel customDomainLayout(String? customDomainLayout);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserSettingsModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserSettingsModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserSettingsModel call({
    String? collaborateWith,
    bool? collaborationDisabled,
    bool? reasonForReachoutEnabled,
    String? showView,
    String? onboardingReason,
    UserJobPreferenceModel? jobPreferences,
    UserProfileOnboardingModel? profileOnboarding,
    String? customDomainLayout,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserSettingsModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserSettingsModel.copyWith.fieldName(...)`
class _$UserSettingsModelCWProxyImpl implements _$UserSettingsModelCWProxy {
  const _$UserSettingsModelCWProxyImpl(this._value);

  final UserSettingsModel _value;

  @override
  UserSettingsModel collaborateWith(String? collaborateWith) =>
      this(collaborateWith: collaborateWith);

  @override
  UserSettingsModel collaborationDisabled(bool? collaborationDisabled) =>
      this(collaborationDisabled: collaborationDisabled);

  @override
  UserSettingsModel reasonForReachoutEnabled(bool? reasonForReachoutEnabled) =>
      this(reasonForReachoutEnabled: reasonForReachoutEnabled);

  @override
  UserSettingsModel showView(String? showView) => this(showView: showView);

  @override
  UserSettingsModel onboardingReason(String? onboardingReason) =>
      this(onboardingReason: onboardingReason);

  @override
  UserSettingsModel jobPreferences(UserJobPreferenceModel? jobPreferences) =>
      this(jobPreferences: jobPreferences);

  @override
  UserSettingsModel profileOnboarding(
          UserProfileOnboardingModel? profileOnboarding) =>
      this(profileOnboarding: profileOnboarding);

  @override
  UserSettingsModel customDomainLayout(String? customDomainLayout) =>
      this(customDomainLayout: customDomainLayout);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserSettingsModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserSettingsModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserSettingsModel call({
    Object? collaborateWith = const $CopyWithPlaceholder(),
    Object? collaborationDisabled = const $CopyWithPlaceholder(),
    Object? reasonForReachoutEnabled = const $CopyWithPlaceholder(),
    Object? showView = const $CopyWithPlaceholder(),
    Object? onboardingReason = const $CopyWithPlaceholder(),
    Object? jobPreferences = const $CopyWithPlaceholder(),
    Object? profileOnboarding = const $CopyWithPlaceholder(),
    Object? customDomainLayout = const $CopyWithPlaceholder(),
  }) {
    return UserSettingsModel(
      collaborateWith: collaborateWith == const $CopyWithPlaceholder()
          ? _value.collaborateWith
          // ignore: cast_nullable_to_non_nullable
          : collaborateWith as String?,
      collaborationDisabled:
          collaborationDisabled == const $CopyWithPlaceholder()
              ? _value.collaborationDisabled
              // ignore: cast_nullable_to_non_nullable
              : collaborationDisabled as bool?,
      reasonForReachoutEnabled:
          reasonForReachoutEnabled == const $CopyWithPlaceholder()
              ? _value.reasonForReachoutEnabled
              // ignore: cast_nullable_to_non_nullable
              : reasonForReachoutEnabled as bool?,
      showView: showView == const $CopyWithPlaceholder()
          ? _value.showView
          // ignore: cast_nullable_to_non_nullable
          : showView as String?,
      onboardingReason: onboardingReason == const $CopyWithPlaceholder()
          ? _value.onboardingReason
          // ignore: cast_nullable_to_non_nullable
          : onboardingReason as String?,
      jobPreferences: jobPreferences == const $CopyWithPlaceholder()
          ? _value.jobPreferences
          // ignore: cast_nullable_to_non_nullable
          : jobPreferences as UserJobPreferenceModel?,
      profileOnboarding: profileOnboarding == const $CopyWithPlaceholder()
          ? _value.profileOnboarding
          // ignore: cast_nullable_to_non_nullable
          : profileOnboarding as UserProfileOnboardingModel?,
      customDomainLayout: customDomainLayout == const $CopyWithPlaceholder()
          ? _value.customDomainLayout
          // ignore: cast_nullable_to_non_nullable
          : customDomainLayout as String?,
    );
  }
}

extension $UserSettingsModelCopyWith on UserSettingsModel {
  /// Returns a callable class that can be used as follows: `instanceOfUserSettingsModel.copyWith(...)` or like so:`instanceOfUserSettingsModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserSettingsModelCWProxy get copyWith =>
      _$UserSettingsModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettingsModel _$UserSettingsModelFromJson(Map<String, dynamic> json) =>
    UserSettingsModel(
      collaborateWith: json['collaborateWith'] as String?,
      collaborationDisabled: json['collaborationDisabled'] as bool?,
      reasonForReachoutEnabled: json['reasonForReachoutEnabled'] as bool?,
      showView: json['showView'] as String?,
      onboardingReason: json['onboardingReason'] as String?,
      jobPreferences: json['job_preferences'] == null
          ? null
          : UserJobPreferenceModel.fromJson(
              json['job_preferences'] as Map<String, dynamic>),
      profileOnboarding: json['profileOnboarding'] == null
          ? null
          : UserProfileOnboardingModel.fromJson(
              json['profileOnboarding'] as Map<String, dynamic>),
      customDomainLayout: json['customDomainLayout'] as String?,
    );

Map<String, dynamic> _$UserSettingsModelToJson(UserSettingsModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('collaborateWith', instance.collaborateWith);
  writeNotNull('collaborationDisabled', instance.collaborationDisabled);
  writeNotNull('reasonForReachoutEnabled', instance.reasonForReachoutEnabled);
  writeNotNull('showView', instance.showView);
  writeNotNull('onboardingReason', instance.onboardingReason);
  writeNotNull('job_preferences', instance.jobPreferences?.toJson());
  writeNotNull('profileOnboarding', instance.profileOnboarding?.toJson());
  writeNotNull('customDomainLayout', instance.customDomainLayout);
  return val;
}
