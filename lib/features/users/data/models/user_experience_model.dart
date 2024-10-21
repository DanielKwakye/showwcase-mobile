import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/users/data/models/user_tech_stack_model.dart';

part 'user_experience_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class UserExperienceModel extends Equatable {

  final int? id;
  final int? userId;
  final String? title;
  final int? companyId;
  final String? companyName;
  final String? companyLogo;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? current;
  final String? description;
  final String? location;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<UserTechStackModel>? stacks;
  // final List<ProjectElement>? projects;

  const UserExperienceModel({
      this.id,
      this.userId,
      this.title,
      this.companyId,
      this.companyName,
      this.companyLogo,
      this.startDate,
      this.endDate,
      this.current,
      this.description,
      this.location,
      this.createdAt,
      this.updatedAt,
      this.stacks,
      // this.projects,
  });

  factory UserExperienceModel.fromJson(Map<String, dynamic> json) => _$UserExperienceModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserExperienceModelToJson(this);

  @override
  List<Object?> get props => [id, title];

}