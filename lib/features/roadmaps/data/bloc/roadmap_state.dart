import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_enums.dart';
import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_model.dart';
import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_readers_model.dart';

part 'roadmap_state.g.dart';

@CopyWith()
class RoadmapState extends Equatable {

  final RoadmapStatus status;
  final String message;
  final List<RoadmapModel> roadmaps;
  final Map<int, RoadmapReadersModel> roadmapReaders;

  const RoadmapState({
    this.status = RoadmapStatus.initial,
    this.message = '',
    this.roadmaps = const [],
    this.roadmapReaders = const {}
  });

  @override
  List<Object?> get props => [status, roadmapReaders];

}