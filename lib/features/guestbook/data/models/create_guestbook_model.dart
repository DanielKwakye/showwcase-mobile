import 'package:json_annotation/json_annotation.dart';

part 'create_guestbook_model.g.dart';

@JsonSerializable(explicitToJson: true)

class CreateGuestbookModel {
  CreateGuestbookModel({
    this.id,
    this.authorId,
    this.userId,
    this.message,
    this.updatedAt,
    this.createdAt,
  });

  int? id;
  int? authorId;
  int? userId;
  String? message;
  DateTime? updatedAt;
  DateTime? createdAt;

  factory CreateGuestbookModel.fromJson(Map<String, dynamic> json) => _$CreateGuestbookModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreateGuestbookModelToJson(this);
}
