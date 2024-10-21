import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_message_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'incoming_connection_model.g.dart';

@JsonSerializable(explicitToJson: true)
class IncomingConnectionModel {

  const IncomingConnectionModel({
    this.chatId,
    this.createdAt,
    this.updatedAt,
    this.totalUnreadMessages,
    this.message,
    this.user,
  });

  final String? chatId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? totalUnreadMessages;
  final ChatMessageModel? message;
  final UserModel? user;

  /// Connect the generated [_$IncomingConnectionModelFromJson] function to the `fromJson`
  /// factory.
  factory IncomingConnectionModel.fromJson(Map<String, dynamic> json) => _$IncomingConnectionModelFromJson(json);

  /// Connect the generated [_$IncomingConnectionModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$IncomingConnectionModelToJson(this);

}