import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'thread_voter_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ThreadVoterModel {
  final Map<String, dynamic>? option;
  final UserModel? user;

  const ThreadVoterModel({this.option, this.user});

  factory ThreadVoterModel.fromJson(Map<String, dynamic> json) => _$ThreadVoterModelFromJson(json);
  Map<String, dynamic> toJson() => _$ThreadVoterModelToJson(this);

}