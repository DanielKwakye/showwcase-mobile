
import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_cubit.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';

class ProfileShowsCubit extends ShowsCubit {

  ProfileShowsCubit({required super.showsRepository, required super.showsBroadcastRepository});

  Future<Either<String, List<ShowModel>>> fetchProfileShows(int pageKey,String username) {

    // we request for the default page size on the first call and subsequently we skip by the length of shows available
    final skip = pageKey  > 0 ?  state.shows.length : pageKey;  //
    final path = ApiConfig.fetchProfileShows(skip: skip, limit: defaultPageSize,userName: username);
    return super.fetchShows(pageKey: pageKey, path: path);

  }

}