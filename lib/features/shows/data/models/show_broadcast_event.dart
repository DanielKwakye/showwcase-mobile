import 'package:showwcase_v3/features/shows/data/bloc/shows_enums.dart';
import 'package:showwcase_v3/features/shows/data/models/show_comment_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';

class ShowBroadcastEvent {
  final ShowBroadcastAction action;
  final ShowModel? show;
  final ShowCommentModel? comment;
  const ShowBroadcastEvent({required this.action, this.show, this.comment});
}