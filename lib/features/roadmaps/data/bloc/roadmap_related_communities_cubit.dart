import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_cubit.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';

class RoadmapRelatedCommunitiesCubit extends CommunityCubit {

  RoadmapRelatedCommunitiesCubit({required super.communityRepository, required super.authBroadcastRepository, required super.communityBroadcastRepository});

  Future<Either<String, List<CommunityModel>>> fetchRoadmapRelatedCommunities(
      {required int pageKey, required int roadmapId}) {

    // we request for the default page size on the first call and subsequently we skip by the length of shows available
    final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey;
    final path = ApiConfig.fetchRoadmapCommunities(roadmapId: roadmapId, limit: defaultPageSize, skip: skip,);
    return super.fetchCommunities(pageKey: pageKey, path: path);

  }

}