import 'package:json_annotation/json_annotation.dart';

part 'user_activity_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserActivityModel {
  final String? message;
  final String? emoji;

  const UserActivityModel({
    this.message,
    this.emoji,
  });

  /// Connect the generated [_$UserActivityModelFromJson] function to the `fromJson`
  /// factory.
  factory UserActivityModel.fromJson(Map<String, dynamic> json) => _$UserActivityModelFromJson(json);

  /// Connect the generated [_$UserActivityModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserActivityModelToJson(this);

}