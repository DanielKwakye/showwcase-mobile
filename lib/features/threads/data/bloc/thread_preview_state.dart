import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_enums.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';

part 'thread_preview_state.g.dart';

@CopyWith()
class ThreadPreviewState extends Equatable{

  final ThreadStatus status;
  final String message;
  final List<ThreadModel> threadPreviews;
  final dynamic data; // holds any temporal data

  // key is the parentThread (threadPreview) id, and values are the thread replies
  final Map<int, List<ThreadModel>> threadComments;
  final Map<int, List<ThreadModel>> threadCommentReplies; // key is the parent comment

  const ThreadPreviewState({this.status = ThreadStatus.initial,
    this.message = '',
    this.threadPreviews = const [],
    this.threadComments = const {},
    this.threadCommentReplies = const {},
    this.data
  });

  @override
  List<Object?> get props => [status, threadPreviews, threadComments];

}