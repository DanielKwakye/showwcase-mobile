import 'package:showwcase_v3/features/guestbook/data/models/guestbook_enums.dart';
import 'package:showwcase_v3/features/guestbook/data/models/guestbook_model.dart';


class GuestBookBroadcastEvent {
  final GuestBookBroadcastAction action;
  final GuestBookModel guestbook;
  const GuestBookBroadcastEvent({required this.action, required this.guestbook});
}