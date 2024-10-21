import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_cubit.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';

class RoadmapArchivedShowsCubit extends ShowsCubit {

  RoadmapArchivedShowsCubit({required super.showsRepository, required super.showsBroadcastRepository});

  Future<Either<String, List<ShowModel>>> fetchRoadmapArchivedShows(
      {required int pageKey, required int roadmapId}) {

    // we request for the default page size on the first call and subsequently we skip by the length of shows available
    final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey; //
    final path = ApiConfig.fetchRoadmapShowsInArchive(roadmapId: roadmapId, limit: defaultPageSize, skip: skip,);
    return super.fetchShows(pageKey: pageKey, path: path);

  }

}