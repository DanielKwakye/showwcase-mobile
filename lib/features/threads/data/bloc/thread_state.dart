import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_enums.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';

part 'thread_state.g.dart';

@CopyWith()
class ThreadState extends Equatable {

  final ThreadStatus status;
  final String message;
  final dynamic data; // you can keep all temporal data here ---
  final List<ThreadModel> threads;

  const ThreadState({
    this.status = ThreadStatus.initial,
    this.message = '',
    this.threads = const [],
    this.data,
  });

  @override
  List<Object?> get props => [status];

}