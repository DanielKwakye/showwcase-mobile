import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_cubit.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';

class SeriesFeedsCubit extends SeriesCubit {

  SeriesFeedsCubit({required super.seriesRepository, required super.showsBroadcastRepository});

  Future<Either<String, List<SeriesModel>>> fetchSeriesFeeds(int pageKey) {

    // we request for the default page size on the first call and subsequently we skip by the length of items available
    final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey;  // even if previous page returned items less than defaultPageSize, still skip by defaultPageSize
    final path = ApiConfig.fetchSeries(skip: skip, limit: defaultPageSize);
    return super.fetchSeries(pageKey: pageKey, path: path);

  }



}