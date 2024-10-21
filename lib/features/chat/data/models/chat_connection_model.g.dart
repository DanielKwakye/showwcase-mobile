// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_connection_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatConnectionModelCWProxy {
  ChatConnectionModel id(String? id);

  ChatConnectionModel lastMessage(ChatMessageModel? lastMessage);

  ChatConnectionModel users(List<UserModel>? users);

  ChatConnectionModel isPinned(bool? isPinned);

  ChatConnectionModel lastMessageReadAt(DateTime? lastMessageReadAt);

  ChatConnectionModel totalUnreadMessages(int? totalUnreadMessages);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatConnectionModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatConnectionModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatConnectionModel call({
    String? id,
    ChatMessageModel? lastMessage,
    List<UserModel>? users,
    bool? isPinned,
    DateTime? lastMessageReadAt,
    int? totalUnreadMessages,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChatConnectionModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChatConnectionModel.copyWith.fieldName(...)`
class _$ChatConnectionModelCWProxyImpl implements _$ChatConnectionModelCWProxy {
  const _$ChatConnectionModelCWProxyImpl(this._value);

  final ChatConnectionModel _value;

  @override
  ChatConnectionModel id(String? id) => this(id: id);

  @override
  ChatConnectionModel lastMessage(ChatMessageModel? lastMessage) =>
      this(lastMessage: lastMessage);

  @override
  ChatConnectionModel users(List<UserModel>? users) => this(users: users);

  @override
  ChatConnectionModel isPinned(bool? isPinned) => this(isPinned: isPinned);

  @override
  ChatConnectionModel lastMessageReadAt(DateTime? lastMessageReadAt) =>
      this(lastMessageReadAt: lastMessageReadAt);

  @override
  ChatConnectionModel totalUnreadMessages(int? totalUnreadMessages) =>
      this(totalUnreadMessages: totalUnreadMessages);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatConnectionModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatConnectionModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatConnectionModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? lastMessage = const $CopyWithPlaceholder(),
    Object? users = const $CopyWithPlaceholder(),
    Object? isPinned = const $CopyWithPlaceholder(),
    Object? lastMessageReadAt = const $CopyWithPlaceholder(),
    Object? totalUnreadMessages = const $CopyWithPlaceholder(),
  }) {
    return ChatConnectionModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      lastMessage: lastMessage == const $CopyWithPlaceholder()
          ? _value.lastMessage
          // ignore: cast_nullable_to_non_nullable
          : lastMessage as ChatMessageModel?,
      users: users == const $CopyWithPlaceholder()
          ? _value.users
          // ignore: cast_nullable_to_non_nullable
          : users as List<UserModel>?,
      isPinned: isPinned == const $CopyWithPlaceholder()
          ? _value.isPinned
          // ignore: cast_nullable_to_non_nullable
          : isPinned as bool?,
      lastMessageReadAt: lastMessageReadAt == const $CopyWithPlaceholder()
          ? _value.lastMessageReadAt
          // ignore: cast_nullable_to_non_nullable
          : lastMessageReadAt as DateTime?,
      totalUnreadMessages: totalUnreadMessages == const $CopyWithPlaceholder()
          ? _value.totalUnreadMessages
          // ignore: cast_nullable_to_non_nullable
          : totalUnreadMessages as int?,
    );
  }
}

extension $ChatConnectionModelCopyWith on ChatConnectionModel {
  /// Returns a callable class that can be used as follows: `instanceOfChatConnectionModel.copyWith(...)` or like so:`instanceOfChatConnectionModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatConnectionModelCWProxy get copyWith =>
      _$ChatConnectionModelCWProxyImpl(this);
}

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatConnectionModelAdapter extends TypeAdapter<ChatConnectionModel> {
  @override
  final int typeId = 1;

  @override
  ChatConnectionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatConnectionModel(
      id: fields[0] as String?,
      lastMessage: fields[1] as ChatMessageModel?,
      users: (fields[2] as List?)?.cast<UserModel>(),
      isPinned: fields[3] as bool?,
      lastMessageReadAt: fields[4] as DateTime?,
      totalUnreadMessages: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatConnectionModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.lastMessage)
      ..writeByte(2)
      ..write(obj.users)
      ..writeByte(3)
      ..write(obj.isPinned)
      ..writeByte(4)
      ..write(obj.lastMessageReadAt)
      ..writeByte(5)
      ..write(obj.totalUnreadMessages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatConnectionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatConnectionModel _$ChatConnectionModelFromJson(Map<String, dynamic> json) =>
    ChatConnectionModel(
      id: json['id'] as String?,
      lastMessage: json['lastMessage'] == null
          ? null
          : ChatMessageModel.fromJson(
              json['lastMessage'] as Map<String, dynamic>),
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isPinned: json['isPinned'] as bool?,
      lastMessageReadAt: json['lastMessageReadAt'] == null
          ? null
          : DateTime.parse(json['lastMessageReadAt'] as String),
      totalUnreadMessages: json['totalUnreadMessages'] as int?,
    );

Map<String, dynamic> _$ChatConnectionModelToJson(
        ChatConnectionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lastMessage': instance.lastMessage?.toJson(),
      'users': instance.users?.map((e) => e.toJson()).toList(),
      'isPinned': instance.isPinned,
      'lastMessageReadAt': instance.lastMessageReadAt?.toIso8601String(),
      'totalUnreadMessages': instance.totalUnreadMessages,
    };
