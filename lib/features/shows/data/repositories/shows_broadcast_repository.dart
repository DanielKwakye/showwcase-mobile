import 'dart:async';

import 'package:showwcase_v3/features/shows/data/bloc/shows_enums.dart';
import 'package:showwcase_v3/features/shows/data/models/show_broadcast_event.dart';
import 'package:showwcase_v3/features/shows/data/models/show_comment_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';


class ShowsBroadcastRepository {

  final _controller = StreamController<ShowBroadcastEvent>.broadcast();
  Stream<ShowBroadcastEvent> get stream => _controller.stream;

  void updateShow({required ShowModel updatedShow}) {
    _controller.sink.add(ShowBroadcastEvent(action: ShowBroadcastAction.updateShow, show: updatedShow));
  }

  void updateComment({required ShowCommentModel comment}) {
    _controller.sink.add(ShowBroadcastEvent(action: ShowBroadcastAction.updateComment, comment: comment));
  }

  void addComment({required ShowCommentModel comment}) {
    _controller.sink.add(ShowBroadcastEvent(action: ShowBroadcastAction.createComment, comment: comment));
  }

  void removeComment({required ShowCommentModel comment})  {
    _controller.sink.add(ShowBroadcastEvent(action: ShowBroadcastAction.deleteComment, comment: comment));
  }

}