import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_onboarding_model.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
@CopyWith()
class UserProfileOnboardingModel extends Equatable {
  const UserProfileOnboardingModel({
    this.workedwith,
    this.repos,
    this.positions,
    this.completed,
  });

  final bool? workedwith;
  final bool? repos;
  final bool? positions;
  final bool? completed;

  factory UserProfileOnboardingModel.fromJson(Map<String, dynamic> json) => _$UserProfileOnboardingModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileOnboardingModelToJson(this);

  @override
  List<Object?> get props => [workedwith, repos, positions, completed];




}