import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_tag_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserTagModel extends Equatable {

  final String? color;
  final String? name;
  final String? icon;

  const UserTagModel({
      this.color,
      this.name,
      this.icon
  });

  /// Connect the generated [_$UserTagModelFromJson] function to the `fromJson`
  /// factory.
  factory UserTagModel.fromJson(Map<String, dynamic> json) => _$UserTagModelFromJson(json);

  /// Connect the generated [_$UserTagModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserTagModelToJson(this);

  @override
  List<Object?> get props => [name];


}