import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_enums.dart';
import 'package:showwcase_v3/features/shows/data/models/show_comment_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';

part 'show_preview_state.g.dart';

@CopyWith()
class ShowPreviewState extends Equatable {
  final String message;
  final ShowsStatus status;
  final List<ShowModel> showPreviews;
  final Map<int, List<ShowModel>> recommendedShows; // where the key is the showId the user is viewing currently
  final Map<int, List<ShowCommentModel>> comments; // where the key is the showId

  const ShowPreviewState({
    this.message = '',
    this.status = ShowsStatus.initial,
    this.showPreviews = const [],
    this.recommendedShows = const {},
    this.comments = const {}
  });

  @override
  List<Object?> get props => [status, comments];

}