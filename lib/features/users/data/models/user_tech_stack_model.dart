import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/users/data/models/user_stack_model.dart';

part 'user_tech_stack_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class UserTechStackModel extends Equatable {
  final int? id;
  final int? userId;
  final int? stackId;
  final int? experience;
  final int? experienceId;
  final bool? isFeatured;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserStackModel? stack;

  const UserTechStackModel({
    this.id,
    this.userId,
    this.stackId,
    this.experience,
    this.experienceId,
    this.isFeatured,
    this.createdAt,
    this.updatedAt,
    this.stack,
  });

  factory UserTechStackModel.fromJson(Map<String, dynamic> json) => _$UserTechStackModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserTechStackModelToJson(this);

  @override
  List<Object?> get props => [stackId, isFeatured, stack];


}