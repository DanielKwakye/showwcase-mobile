import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/users/data/bloc/users_cubit.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class RoadmapContributorsCubit extends UsersCubit {

  RoadmapContributorsCubit({required super.userRepository, required super.userBroadcastRepository});

  Future<Either<String, List<UserModel>>> fetchRoadmapContributors(
      {required int pageKey, required int roadmapId}) {

    // we request for the default page size on the first call and subsequently we skip by the length of shows available
    final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey;   // // we request for the default page size on the first call and subsequently we skip by the length of shows available
    final path = ApiConfig.fetchRoadmapContributors(roadmapId: roadmapId, limit: defaultPageSize, skip: skip,);
    return super.fetchUsers(pageKey: pageKey, path: path);

  }
}