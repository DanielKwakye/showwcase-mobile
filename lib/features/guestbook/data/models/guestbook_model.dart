import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'guestbook_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GuestBookModel {
  GuestBookModel({
    this.id,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  int? id;
  String? message;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel? user;

  factory GuestBookModel.fromJson(Map<String, dynamic> json) => _$GuestBookModelFromJson(json);
  Map<String, dynamic> toJson() => _$GuestBookModelToJson(this);

}

