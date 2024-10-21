import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'thread_poll_option_model.g.dart';

@CopyWith()
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ThreadPollOptionModel extends Equatable {

  const ThreadPollOptionModel({
    this.id,
    this.option,
    this.pollId,
    this.createdAt,
    this.updatedAt,
    this.totalVotes,
  });

  final int? id;
  final String? option;
  final int? pollId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? totalVotes;

  factory ThreadPollOptionModel.fromJson(Map<String, dynamic> json) => _$ThreadPollOptionModelFromJson(json);
  Map<String, dynamic> toJson() => _$ThreadPollOptionModelToJson(this);

  @override
  List<Object?> get props => [id, option, pollId, totalVotes];

}