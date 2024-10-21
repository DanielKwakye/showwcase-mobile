import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_message_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'chat_connection_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
@HiveType(typeId: kChatConnectionModelHive)
class ChatConnectionModel extends Equatable {

  @HiveField(0)
  final String? id;

  @HiveField(1)
  final ChatMessageModel? lastMessage;

  @HiveField(2)
  final List<UserModel>? users;

  @HiveField(3)
  final bool? isPinned;

  @HiveField(4)
  final DateTime? lastMessageReadAt;

  @HiveField(5)
  final int? totalUnreadMessages;

  const ChatConnectionModel({

    this.id,
    this.lastMessage,
    this.users,
    this.isPinned,
    this.lastMessageReadAt,
    this.totalUnreadMessages,

  });

  /// Connect the generated [_$ChatConnectionModelFromJson] function to the `fromJson`
  /// factory.
  factory ChatConnectionModel.fromJson(Map<String, dynamic> json) => _$ChatConnectionModelFromJson(json);

  /// Connect the generated [_$ChatConnectionModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ChatConnectionModelToJson(this);

  @override
  List<Object?> get props => [id, lastMessageReadAt, lastMessage];

}