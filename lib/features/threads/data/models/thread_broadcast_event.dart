import 'package:showwcase_v3/features/threads/data/bloc/thread_enums.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';

class ThreadBroadcastEvent {
  final ThreadBroadcastAction action;
  final ThreadModel thread;
  const ThreadBroadcastEvent({required this.action, required this.thread});
}