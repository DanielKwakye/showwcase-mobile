
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/guestbook/data/bloc/guestbook_enums.dart';
import 'package:showwcase_v3/features/guestbook/data/models/guestbook_model.dart';

part 'guestbook_state.g.dart';

@CopyWith()
class GuestbookState extends Equatable {
  final String message;
  final GuestBookStatus status;
  final dynamic data; // you can keep all temporal data here
  final List<GuestBookModel>  guestBookMessages;
 // final CreateGuestbookModel? createGuestbookModel;


  const GuestbookState({
    this.message = '',
    this.status = GuestBookStatus.initial,
    this.data = const {},
    this.guestBookMessages = const [],
   // required this.createGuestbookModel
});

  @override
  List<Object?> get props => [status];
}


