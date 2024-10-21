import 'dart:async';

import 'package:showwcase_v3/features/threads/data/bloc/thread_enums.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_broadcast_event.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';

class ThreadBroadcastRepository {

  final _controller = StreamController<ThreadBroadcastEvent>.broadcast();
  Stream<ThreadBroadcastEvent> get stream => _controller.stream;

  void updateThread({required ThreadModel thread}) {
    _controller.sink.add(ThreadBroadcastEvent(action: ThreadBroadcastAction.update, thread: thread));
  }

  void addThread({required ThreadModel thread}) {
    _controller.sink.add(ThreadBroadcastEvent(action: thread.parentId == null ? ThreadBroadcastAction.create : ThreadBroadcastAction.reply,
        thread: thread));
  }

  void removeThread({required ThreadModel thread}) {
    _controller.sink.add(ThreadBroadcastEvent(action: ThreadBroadcastAction.delete, thread: thread));
  }

}