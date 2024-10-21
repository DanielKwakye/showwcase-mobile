import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_cubit.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';

class RoadmapSeriesCubit extends SeriesCubit {

  RoadmapSeriesCubit({required super.seriesRepository, required super.showsBroadcastRepository});

  Future<Either<String, List<SeriesModel>>> fetchRoadmapSeriesCubit(
      {required int pageKey, required int roadmapId}) {

    // we request for the default page size on the first call and subsequently we skip by the length of shows available
    final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey;   //
    final path =  ApiConfig.fetchRoadmapSeries(roadmapId: roadmapId, limit: defaultPageSize, skip: skip);
    return super.fetchSeries(pageKey: pageKey, path: path);

  }

}