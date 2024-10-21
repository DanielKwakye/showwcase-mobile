
import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_cubit.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';


class ProfileThreadsCubit extends ThreadCubit {

  ProfileThreadsCubit(super.threadRepository, {required super.threadBroadcastRepository});

  Future<Either<String, List<ThreadModel>>> fetchThreadFeeds(int pageKey,String username) {

    // we request for the default page size on the first call and subsequently we skip by the length of threads available
    final skip = pageKey  > 0 ?  state.threads.length : pageKey;  //
    final path = ApiConfig.fetchProfileThreads(skip: skip, limit: defaultPageSize, userName: username, type: 'parent');
    return super.fetchThreads(pageKey: pageKey, path: path);

  }
}
