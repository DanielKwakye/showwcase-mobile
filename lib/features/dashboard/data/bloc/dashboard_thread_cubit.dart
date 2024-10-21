import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_cubit.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';

class DashboardThreadsCubit extends ThreadCubit {

  DashboardThreadsCubit(super.threadRepository, {required super.threadBroadcastRepository});

  Future<Either<String, List<ThreadModel>>> fetchThreadFeeds(int pageKey) {

    // we request for the default page size on the first call and subsequently we skip by the length of threads available
    final skip = pageKey  > 0 ?  state.threads.length : pageKey;  //
    final path = ApiConfig.fetchDashboardThreads(skip: skip, limit: defaultPageSize);
    return super.fetchThreads(pageKey: pageKey, path: path);

  }

}