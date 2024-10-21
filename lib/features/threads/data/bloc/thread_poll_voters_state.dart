import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_enums.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_voter_model.dart';

part 'thread_poll_voters_state.g.dart';

@CopyWith()
class ThreadPollVotersState extends Equatable {
  final ThreadStatus status;
  final String message;
  final List<ThreadVoterModel> voters;

  const ThreadPollVotersState({
    this.status = ThreadStatus.initial,
    this.message = '',
    this.voters = const []
  });

  @override
  List<Object?> get props => [status];
}