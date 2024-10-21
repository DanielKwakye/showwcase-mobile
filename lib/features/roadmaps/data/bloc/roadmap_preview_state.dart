import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_enums.dart';
import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_model.dart';

part 'roadmap_preview_state.g.dart';

@CopyWith()
class RoadmapPreviewState extends Equatable {

  final String message;
  final RoadmapStatus status;
  final List<RoadmapModel> roadmapPreviews;

  const RoadmapPreviewState({
    this.message = '',
    this.status = RoadmapStatus.initial,
    this.roadmapPreviews = const []
  });

  @override
  List<Object?> get props => [status];

}