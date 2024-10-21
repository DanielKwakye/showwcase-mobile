import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/explore/data/bloc/explore_enums.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';

part 'explore_state.g.dart';

@CopyWith()
class ExploreState extends Equatable {
  final ExploreStatus status;
  final String message;
  final List<ShowModel> trendingShows;

  const ExploreState( {this.status = ExploreStatus.initial, this.message = '',this.trendingShows = const  [],});

  @override
  List<Object?> get props => [status];
}