import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_cubit.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';

class SearchCommunitiesCubit extends CommunityCubit {

  SearchCommunitiesCubit({required super.communityRepository, required super.authBroadcastRepository, required super.communityBroadcastRepository});

  Future<Either<String, List<CommunityModel>>> fetchCommunitiesSearch(
      {required int pageKey, required String searchWord}) {

    // we request for the default page size on the first call and subsequently we skip by the length of shows available
    final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey; // // // we request for the default page size on the first call and subsequently we skip by the length of shows available
    final path =  ApiConfig.search(limit: defaultPageSize, skip: skip, type: 'communities', text: searchWord);
    return super.fetchCommunities(pageKey: pageKey, path: path);

  }

}