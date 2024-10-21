import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_cubit.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';

import '../../../../core/network/api_config.dart';

class BookmarkThreadsCubit extends ThreadCubit {

  BookmarkThreadsCubit(super.threadRepository, {required super.threadBroadcastRepository});

  Future<Either<String, List<ThreadModel>>> fetchThreadFeeds(int pageKey) {

    // we request for the default page size on the first call and subsequently we skip by the length of threads available
    // final skip = pageKey  > 0 ?  state.threads.length : pageKey;  //
    final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey;  // event if previous page returned items less than defaultPageSize, still skip by defaultPageSize
    final path = ApiConfig.fetchThreadBookmarks(skip: skip, limit: defaultPageSize);
    return super.fetchThreads(pageKey: pageKey, path: path);

  }

}