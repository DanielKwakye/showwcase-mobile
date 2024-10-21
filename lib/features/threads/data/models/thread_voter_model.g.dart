// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_voter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadVoterModel _$ThreadVoterModelFromJson(Map<String, dynamic> json) =>
    ThreadVoterModel(
      option: json['option'] as Map<String, dynamic>?,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ThreadVoterModelToJson(ThreadVoterModel instance) =>
    <String, dynamic>{
      'option': instance.option,
      'user': instance.user?.toJson(),
    };
