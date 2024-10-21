// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatMessageModelCWProxy {
  ChatMessageModel id(String? id);

  ChatMessageModel matchId(String? matchId);

  ChatMessageModel chatId(String? chatId);

  ChatMessageModel userId(int? userId);

  ChatMessageModel text(String? text);

  ChatMessageModel createdAt(DateTime? createdAt);

  ChatMessageModel updatedAt(DateTime? updatedAt);

  ChatMessageModel attachments(List<ChatAttachmentModel>? attachments);

  ChatMessageModel user(UserModel? user);

  ChatMessageModel sentFromMobile(bool sentFromMobile);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatMessageModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatMessageModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatMessageModel call({
    String? id,
    String? matchId,
    String? chatId,
    int? userId,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ChatAttachmentModel>? attachments,
    UserModel? user,
    bool? sentFromMobile,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChatMessageModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChatMessageModel.copyWith.fieldName(...)`
class _$ChatMessageModelCWProxyImpl implements _$ChatMessageModelCWProxy {
  const _$ChatMessageModelCWProxyImpl(this._value);

  final ChatMessageModel _value;

  @override
  ChatMessageModel id(String? id) => this(id: id);

  @override
  ChatMessageModel matchId(String? matchId) => this(matchId: matchId);

  @override
  ChatMessageModel chatId(String? chatId) => this(chatId: chatId);

  @override
  ChatMessageModel userId(int? userId) => this(userId: userId);

  @override
  ChatMessageModel text(String? text) => this(text: text);

  @override
  ChatMessageModel createdAt(DateTime? createdAt) => this(createdAt: createdAt);

  @override
  ChatMessageModel updatedAt(DateTime? updatedAt) => this(updatedAt: updatedAt);

  @override
  ChatMessageModel attachments(List<ChatAttachmentModel>? attachments) =>
      this(attachments: attachments);

  @override
  ChatMessageModel user(UserModel? user) => this(user: user);

  @override
  ChatMessageModel sentFromMobile(bool sentFromMobile) =>
      this(sentFromMobile: sentFromMobile);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatMessageModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatMessageModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatMessageModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? matchId = const $CopyWithPlaceholder(),
    Object? chatId = const $CopyWithPlaceholder(),
    Object? userId = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? attachments = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
    Object? sentFromMobile = const $CopyWithPlaceholder(),
  }) {
    return ChatMessageModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      matchId: matchId == const $CopyWithPlaceholder()
          ? _value.matchId
          // ignore: cast_nullable_to_non_nullable
          : matchId as String?,
      chatId: chatId == const $CopyWithPlaceholder()
          ? _value.chatId
          // ignore: cast_nullable_to_non_nullable
          : chatId as String?,
      userId: userId == const $CopyWithPlaceholder()
          ? _value.userId
          // ignore: cast_nullable_to_non_nullable
          : userId as int?,
      text: text == const $CopyWithPlaceholder()
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
      attachments: attachments == const $CopyWithPlaceholder()
          ? _value.attachments
          // ignore: cast_nullable_to_non_nullable
          : attachments as List<ChatAttachmentModel>?,
      user: user == const $CopyWithPlaceholder()
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as UserModel?,
      sentFromMobile: sentFromMobile == const $CopyWithPlaceholder() ||
              sentFromMobile == null
          ? _value.sentFromMobile
          // ignore: cast_nullable_to_non_nullable
          : sentFromMobile as bool,
    );
  }
}

extension $ChatMessageModelCopyWith on ChatMessageModel {
  /// Returns a callable class that can be used as follows: `instanceOfChatMessageModel.copyWith(...)` or like so:`instanceOfChatMessageModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatMessageModelCWProxy get copyWith => _$ChatMessageModelCWProxyImpl(this);
}

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatMessageModelAdapter extends TypeAdapter<ChatMessageModel> {
  @override
  final int typeId = 2;

  @override
  ChatMessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessageModel(
      id: fields[0] as String?,
      chatId: fields[1] as String?,
      userId: fields[2] as int?,
      text: fields[3] as String?,
      createdAt: fields[4] as DateTime?,
      updatedAt: fields[5] as DateTime?,
      attachments: (fields[7] as List?)?.cast<ChatAttachmentModel>(),
      user: fields[6] as UserModel?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessageModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.chatId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.text)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.user)
      ..writeByte(7)
      ..write(obj.attachments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    ChatMessageModel(
      id: json['id'] as String?,
      matchId: json['matchId'] as String?,
      chatId: json['chatId'] as String?,
      userId: json['userId'] as int?,
      text: json['text'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => ChatAttachmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      sentFromMobile: json['sentFromMobile'] as bool? ?? false,
    );

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'matchId': instance.matchId,
      'chatId': instance.chatId,
      'userId': instance.userId,
      'text': instance.text,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'user': instance.user?.toJson(),
      'attachments': instance.attachments?.map((e) => e.toJson()).toList(),
      'sentFromMobile': instance.sentFromMobile,
    };
