import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_details_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class UserDetailsModel extends Equatable {
  final List<String> languages;
  const UserDetailsModel({this.languages = const []});


  factory UserDetailsModel.fromJson(Map<String, dynamic> json) => _$UserDetailsModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserDetailsModelToJson(this);

  @override
  List<Object?> get props => [languages];
}