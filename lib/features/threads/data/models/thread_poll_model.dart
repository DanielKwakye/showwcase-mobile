import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_poll_option_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_poll_vote_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'thread_poll_model.g.dart';

@CopyWith()
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ThreadPollModel extends Equatable {

  const ThreadPollModel({
    this.id,
    this.isPublic,
    this.question,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.options,
    this.totalVotes,
    this.voters,
    this.vote,
  });

  final int? id;
  final bool? isPublic;
  final String? question;
  final dynamic endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<ThreadPollOptionModel>? options;
  final int? totalVotes;
  final List<UserModel>? voters;
  final ThreadPollVoteModel? vote;

  factory ThreadPollModel.fromJson(Map<String, dynamic> json) => _$ThreadPollModelFromJson(json);
  Map<String, dynamic> toJson() => _$ThreadPollModelToJson(this);

  @override
  List<Object?> get props => [id, totalVotes, voters, vote, totalVotes, options];
}