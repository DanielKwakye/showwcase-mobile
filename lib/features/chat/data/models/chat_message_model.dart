import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_attachment_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'chat_message_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
@HiveType(typeId: kChatMessageModelHive)
class ChatMessageModel extends Equatable {

  @HiveField(0)
  final String? id;

  //if serverUpdates this field update accordingly
  final String? matchId;

  @HiveField(1)
  final String? chatId;

  @HiveField(2)
  final int? userId;

  @HiveField(3)
  final String? text;

  @HiveField(4)
  final DateTime? createdAt;

  @HiveField(5)
  final DateTime? updatedAt;

  @HiveField(6)
  final UserModel? user;

  @HiveField(7)
  final List<ChatAttachmentModel>? attachments;

  final bool sentFromMobile;

  const ChatMessageModel({
    this.id,
    this.matchId,
    this.chatId,
    this.userId,
    this.text,
    this.createdAt,
    this.updatedAt,
    this.attachments,
    this.user,
    this.sentFromMobile = false
  });

  /// Connect the generated [_$ChatMessageModelFromJson] function to the `fromJson`
  /// factory.
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => _$ChatMessageModelFromJson(json);

  /// Connect the generated [_$ChatMessageModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);

  @override
  List<Object?> get props => [id];

}