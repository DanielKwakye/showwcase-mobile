import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_cubit.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class ThreadEditorCommunitiesCubit extends CommunityCubit {

  ThreadEditorCommunitiesCubit({required super.communityRepository, required super.authBroadcastRepository, required super.communityBroadcastRepository});

  /// Fetch current user's communities  -------

  Future<Either<String, List<CommunityModel>>> fetchThreadEditorCommunities({required UserModel userModel, required int pageKey}) {

    final skip = pageKey  > 0 ?  state.communities.length : pageKey;  // // we request for the default page size on the first call and subsequently we skip by the length of shows available
    final path = ApiConfig.fetchUserCommunities(userName: userModel.username ?? '', skip: skip,limit: defaultPageSize);
    return super.fetchCommunities(pageKey: pageKey, path: path);

  }

}