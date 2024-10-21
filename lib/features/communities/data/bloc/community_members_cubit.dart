import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/users/data/bloc/users_cubit.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class CommunityMembersCubit extends UsersCubit {

  CommunityMembersCubit({required super.userRepository, required super.userBroadcastRepository});

  Future<Either<String, List<UserModel>>> fetchCommunityMembers(
      {required int pageKey, required int communityId}) {

    // we request for the default page size on the first call and subsequently we skip by the length of shows available
    final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey; //
    final path = ApiConfig.fetchCommunitiesMembers(skip: skip,limit: defaultPageSize, communityId: communityId);
    return super.fetchUsers(pageKey: pageKey, path: path);

  }
}