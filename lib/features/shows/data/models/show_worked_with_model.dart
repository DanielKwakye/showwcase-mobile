import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'show_worked_with_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowWorkedWithModel extends Equatable {

  const ShowWorkedWithModel({
    this.id,
    this.userId,
    this.colleagueId,
    this.projectId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.colleague,
  });

  final num? id;
  final int? userId;
  final int? colleagueId;
  final int? projectId;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserModel? colleague;

  factory ShowWorkedWithModel.fromJson(Map<String, dynamic> json) => _$ShowWorkedWithModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowWorkedWithModelToJson(this);

  @override
  List<Object?> get props => [id, colleague, projectId, userId];

}