import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_enums.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_state.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';

class ForYouFeedsThreadCubit extends ThreadCubit {

  ForYouFeedsThreadCubit(super.threadRepository, {required super.threadBroadcastRepository}) {
    threadBroadcastRepository.stream.listen((event) {

      ///! When a thread is created immediately show it in the For Yous
      if(event.action == ThreadBroadcastAction.create){
        final thread = event.thread;

        // if its a main thread
        if(thread.parentId == null){
          emit(state.copyWith(status: ThreadStatus.refreshThreadInProgress));
          final threadList = [...state.threads];
          threadList.insert(0, thread);
          emit(state.copyWith(status: ThreadStatus.refreshThreadsCompleted, threads: threadList));
        }
      }

    });
  }

  Future<Either<String, List<ThreadModel>>> fetchThreadFeeds(int pageKey) {

    // we request for the default page size on the first call and subsequently we skip by the length of threads available
    // final skip = pageKey  > 0 ?  state.threads.length : pageKey;  //
    final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey;  // even if previous page returned items less than defaultPageSize, still skip by defaultPageSize
    final path = ApiConfig.fetchForYouThreadFeeds(skip: skip, limit: defaultPageSize);
    return super.fetchThreads(pageKey: pageKey, path: path);

  }

}