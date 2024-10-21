import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_cubit.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_model.dart';

class BookmarkedJobFeedsCubit extends JobsCubit {

  BookmarkedJobFeedsCubit({required super.jobsRepository, required super.jobBroadcastRepository});

  Future<Either<String, List<JobModel>>> fetchBookmarkedJobs(int pageKey, {int? manualSkip, int? manualLimit}) {

    // we request for the default page size on the first call and subsequently we skip by the length of shows available
    // final skip = pageKey  > 0 ?  state.shows.length : pageKey;  //
    final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey;  // even if previous page returned items less than defaultPageSize, still skip by defaultPageSize
    final path = ApiConfig.fetchJobBookmarks(skip: manualSkip ?? skip, limit: manualLimit ?? defaultPageSize);
    return super.fetchJobs(pageKey: pageKey, path: path);

  }

}