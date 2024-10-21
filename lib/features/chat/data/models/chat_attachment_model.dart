import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/constants.dart';

part 'chat_attachment_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: kChatAttachmentModelHive)
class ChatAttachmentModel {

  final String? id;
  @HiveField(0)
  final String? value;
  @HiveField(1)
  final String? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ChatAttachmentMetaModel? meta;

  const ChatAttachmentModel({
    this.id,
    this.value,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.meta
  });

  /// Connect the generated [_$ChatAttachmentModelFromJson] function to the `fromJson`
  /// factory.
  factory ChatAttachmentModel.fromJson(Map<String, dynamic> json) => _$ChatAttachmentModelFromJson(json);

  /// Connect the generated [_$ChatAttachmentModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ChatAttachmentModelToJson(this);

}

@JsonSerializable(explicitToJson: true)
class ChatAttachmentMetaModel {

  final String? url;
  final String? mime;
  final String? type;
  final num? width;
  final num? height;
  final num? length;
  final String? hUnits;
  final String? wUnits;

  const ChatAttachmentMetaModel({
      this.url,
      this.mime,
      this.type,
      this.width,
      this.height,
      this.length,
      this.hUnits,
      this.wUnits
  });

  /// Connect the generated [_$ChatAttachmentMetaModelFromJson] function to the `fromJson`
  /// factory.
  factory ChatAttachmentMetaModel.fromJson(Map<String, dynamic> json) => _$ChatAttachmentMetaModelFromJson(json);

  /// Connect the generated [_$ChatAttachmentMetaModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ChatAttachmentMetaModelToJson(this);

}