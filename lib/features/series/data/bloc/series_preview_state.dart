import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_enums.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/series/data/models/series_review_stats_model.dart';
import 'package:showwcase_v3/features/series/data/models/series_reviewer_model.dart';

part 'series_preview_state.g.dart';

@CopyWith()
class SeriesPreviewState extends Equatable {

  final String message;
  final SeriesStatus status;
  final List<SeriesModel> seriesPreviews;
  final Map<int, SeriesReviewStatsModel> stats; // where the key is series id
  final Map<int, List<SeriesReviewerModel>> reviewers; // where the key is the series id

  const SeriesPreviewState({
    this.message = '',
    this.status = SeriesStatus.initial,
    this.seriesPreviews = const [],
    this.stats = const  {},
    this.reviewers = const  {}
 });

  @override
  List<Object?> get props => [status, stats];

}