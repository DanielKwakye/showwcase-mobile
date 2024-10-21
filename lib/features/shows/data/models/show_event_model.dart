import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'show_event_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowEventModel {
  const ShowEventModel({
    this.id,
    this.name,
    this.startDate,
    this.endDate,
    this.project,
    this.user,
    this.isActive,
    this.attendees,
  });

  final int? id;
  final String? name;
  final DateTime? startDate;
  final DateTime? endDate;
  final ShowModel? project;
  final UserModel? user;
  final bool? isActive;
  final List<UserModel>? attendees;

  factory ShowEventModel.fromJson(Map<String, dynamic> json) => _$ShowEventModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowEventModelToJson(this);

}