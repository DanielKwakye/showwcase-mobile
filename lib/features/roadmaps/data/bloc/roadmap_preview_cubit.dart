import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_enums.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_preview_state.dart';
import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_model.dart';
import 'package:showwcase_v3/features/roadmaps/data/repositories/roadmap_repository.dart';

class RoadmapPreviewCubit extends Cubit<RoadmapPreviewState> {

  final RoadmapRepository roadmapRepository;
  RoadmapPreviewCubit({required this.roadmapRepository}) : super(const RoadmapPreviewState());

  RoadmapModel setRoadmapPreview({required RoadmapModel roadmap, bool updateIfExist = true}){
    // updateIfExist, mean if Show Already Exists should it be updated
    // updateIfExist is usually true after we fetch the full show from the server

    /// This method here adds the a given show to the shows of interest
    /// Once a show is previewed it becomes a show of interest

    emit(state.copyWith(status: RoadmapStatus.setRoadmapPreviewInProgress,));
    final roadmapPreviews = [...state.roadmapPreviews];
    final int index = roadmapPreviews.indexWhere((element) => element.id == roadmap.id);
    if(index < 0){

      roadmapPreviews.add(roadmap);

    }else {

      // showPreview has already been added
      // so update it.
      if(updateIfExist) {

        roadmapPreviews[index] = roadmap;
      }

    }

    emit(state.copyWith(
        status: RoadmapStatus.setPreviewPreviewCompleted,
        roadmapPreviews: roadmapPreviews
    ));

    // return the threadPreview for methods that needs it
    final roadmapPreview = state.roadmapPreviews.firstWhere((element) => element.id == roadmap.id);
    return roadmapPreview;

  }

  Future<void> fetchRoadmapPreview({required int roadmapId}) async {
    try {

      emit(state.copyWith(status: RoadmapStatus.roadmapsPreviewLoading));

      final either = await roadmapRepository.fetchRoadmapsPreview(roadmapId: roadmapId);

      either.fold((l) {
        emit(state.copyWith(status: RoadmapStatus.roadmapsPreviewError, message: l.errorDescription));
      }, (r) {


        setRoadmapPreview(roadmap: r, updateIfExist: true);
        emit(state.copyWith(status: RoadmapStatus.roadmapsPreviewSuccessful,));

      });
    } catch (e) {
      emit(state.copyWith(status: RoadmapStatus.roadmapsPreviewError,
          message: e.toString()
      ));
    }
  }

}