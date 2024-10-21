import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_enums.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_state.dart';
import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_model.dart';
import 'package:showwcase_v3/features/roadmaps/data/repositories/roadmap_repository.dart';

class RoadmapCubit extends Cubit<RoadmapState> {

  final RoadmapRepository roadmapRepository;
  RoadmapCubit({required this.roadmapRepository}): super(const RoadmapState());

  Future<Either<String, List<RoadmapModel>>> fetchRoadmaps({int pageKey = 0}) async{

    try {

      emit(state.copyWith(status: RoadmapStatus.fetchRoadmapsInProgress));

      final either = await roadmapRepository.fetchRoadmaps();
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: RoadmapStatus.fetchRoadmapsFailed, message: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful

      final r = either.asRight();
      final roadmaps = r..addAll(additionalRoadmapsInfo);
      emit(state.copyWith(status: RoadmapStatus.fetchRoadmapsSuccessful,
          roadmaps: roadmaps
      ));
      return Right(r);

    } catch (e) {
      emit(state.copyWith(status: RoadmapStatus.fetchRoadmapsFailed, message: e.toString()));
      return Left(e.toString());
    }
  }

  Future<void> fetchRoadmapReadingList({ required int roadmapId }) async{

    try {

      emit(state.copyWith(status: RoadmapStatus.fetchRoadmapReadingListInProgress));

      final either = await roadmapRepository.fetchRoadmapReadersList(roadmapId: roadmapId);
      either.fold((l) {
        emit(state.copyWith(
            status: RoadmapStatus.fetchRoadmapReadingListFailed,
            message: l.errorDescription
        ));
      }, (r) {

        final existingReadersData = {...state.roadmapReaders};
        existingReadersData[roadmapId] = r;
        emit(state.copyWith(
            status: RoadmapStatus.fetchRoadmapReadingListSuccessful,
            roadmapReaders: existingReadersData
        ));
      });
    } catch (e) {
      emit(state.copyWith(status: RoadmapStatus.fetchRoadmapReadingListFailed, message: e.toString()));
    }
  }

}

final List<RoadmapModel> additionalRoadmapsInfo = [
  const RoadmapModel(
    title: 'Would you like to contribute?',
    description: 'Get in touch with us! Send us a DM to @ShowwcaseHQ and help us build Roadmaps for the community.',
    color: '#00618a',
  ),
  const RoadmapModel(
      title: 'Data Structures and Algorithms',
      description: 'Learn and Master Data Structures and Algorithms. The absolute fundamentals of being a developer.',
      color: '#fdc314',
      comingSoon: true
  ),
  const RoadmapModel(
      title: 'DevOps',
      description: 'DevOps combines development (Dev) and operations (Ops) to unite people, process, and technology in application.',
      color: '#e45406',
      comingSoon: true
  ),

];