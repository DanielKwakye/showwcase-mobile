import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'thread_poll_vote_model.g.dart';

@CopyWith()
@JsonSerializable(explicitToJson: true)
class ThreadPollVoteModel extends Equatable {

  const ThreadPollVoteModel({
    this.userId,
    this.optionId,
    this.pollId,
  });

  final int? userId;
  final int? optionId;
  final int? pollId;

  factory ThreadPollVoteModel.fromJson(Map<String, dynamic> json) => _$ThreadPollVoteModelFromJson(json);
  Map<String, dynamic> toJson() => _$ThreadPollVoteModelToJson(this);

  @override

  List<Object?> get props => [userId, optionId, pollId];

}