import 'dart:async';

import 'package:showwcase_v3/features/guestbook/data/models/guestbook_boradcast_event.dart';
import 'package:showwcase_v3/features/guestbook/data/models/guestbook_enums.dart';
import 'package:showwcase_v3/features/guestbook/data/models/guestbook_model.dart';

class GuestBookBroadcastRepository {

  final _controller = StreamController<GuestBookBroadcastEvent>.broadcast();
  Stream<GuestBookBroadcastEvent> get stream => _controller.stream;

  void updateThread({required GuestBookModel thread}) {
    _controller.sink.add(GuestBookBroadcastEvent(action: GuestBookBroadcastAction.edit, guestbook: thread));
  }

  void addThread({required GuestBookModel guestbook}) {
    _controller.sink.add(GuestBookBroadcastEvent(action: GuestBookBroadcastAction.create,
        guestbook: guestbook));
  }

  void removeThread({required GuestBookModel thread}) {
    _controller.sink.add(GuestBookBroadcastEvent(action: GuestBookBroadcastAction.delete, guestbook: thread));
  }

}