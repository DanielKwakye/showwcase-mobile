// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_attachment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatAttachmentModelAdapter extends TypeAdapter<ChatAttachmentModel> {
  @override
  final int typeId = 5;

  @override
  ChatAttachmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatAttachmentModel(
      value: fields[0] as String?,
      type: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatAttachmentModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.value)
      ..writeByte(1)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatAttachmentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatAttachmentModel _$ChatAttachmentModelFromJson(Map<String, dynamic> json) =>
    ChatAttachmentModel(
      id: json['id'] as String?,
      value: json['value'] as String?,
      type: json['type'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      meta: json['meta'] == null
          ? null
          : ChatAttachmentMetaModel.fromJson(
              json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatAttachmentModelToJson(
        ChatAttachmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'type': instance.type,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'meta': instance.meta?.toJson(),
    };

ChatAttachmentMetaModel _$ChatAttachmentMetaModelFromJson(
        Map<String, dynamic> json) =>
    ChatAttachmentMetaModel(
      url: json['url'] as String?,
      mime: json['mime'] as String?,
      type: json['type'] as String?,
      width: json['width'] as num?,
      height: json['height'] as num?,
      length: json['length'] as num?,
      hUnits: json['hUnits'] as String?,
      wUnits: json['wUnits'] as String?,
    );

Map<String, dynamic> _$ChatAttachmentMetaModelToJson(
        ChatAttachmentMetaModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'mime': instance.mime,
      'type': instance.type,
      'width': instance.width,
      'height': instance.height,
      'length': instance.length,
      'hUnits': instance.hUnits,
      'wUnits': instance.wUnits,
    };
