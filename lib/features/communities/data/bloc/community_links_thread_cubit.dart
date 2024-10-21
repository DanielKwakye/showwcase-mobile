import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_cubit.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';

import '../../../../core/network/api_config.dart';

class CommunityLinkThreadsCubit extends ThreadCubit {

  CommunityLinkThreadsCubit(super.threadRepository, {required super.threadBroadcastRepository});

  Future<Either<String, List<ThreadModel>>> fetchLinkThreadFeeds({required int pageKey,required String communityName,required String? tag,String? feedType}) async {

    // we request for the default page size on the first call and subsequently we skip by the length of threads available
    final skip = pageKey  > 0 ?  state.threads.length : pageKey;  //
    final path = ApiConfig.fetchCommunitiesFeeds(skip: skip, limit: defaultPageSize, orderType: 'newest', communityName: communityName,tag: tag,feedType: feedType);
    return super.fetchThreads(pageKey: pageKey, path: path);

  }

}