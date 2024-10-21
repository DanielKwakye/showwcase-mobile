import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_cubit.dart';

import '../../../shows/data/models/show_model.dart';

class BookmarkShowsCubit extends ShowsCubit {

  BookmarkShowsCubit({required super.showsRepository, required super.showsBroadcastRepository});

  Future<Either<String, List<ShowModel>>> fetchBookmarkedShows(int pageKey) {

    // we request for the default page size on the first call and subsequently we skip by the length of shows available
    // final skip = pageKey  > 0 ?  state.shows.length : pageKey;  //
    final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey;  // even if previous page returned items less than defaultPageSize, still skip by defaultPageSize
    final path = ApiConfig.fetchShowsBookmarks(skip: skip, limit: defaultPageSize);
    return super.fetchShows(pageKey: pageKey, path: path);

  }

}