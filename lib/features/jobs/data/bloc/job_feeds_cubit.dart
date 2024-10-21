import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_cubit.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_filters_model.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_model.dart';

class JobFeedsCubit extends JobsCubit {

  JobFeedsCubit({required super.jobsRepository, required super.jobBroadcastRepository});

  Future<Either<String, List<JobModel>>> fetchJobsFeeds({required int pageKey,  JobFiltersModel? jobFilters, double? salary}) {
    // we request for the default page size on the first call and subsequently we skip by the length of shows available
    // final skip = pageKey  > 0 ?  state.shows.length : pageKey;  //
    final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey;  // even if previous page returned items less than defaultPageSize, still skip by defaultPageSize
    // final path = ApiConfig.fetchShowsBookmarks(skip: skip, limit: defaultPageSize);
    final path = ApiConfig.fetchJobFeeds(limit: defaultPageSize, skip: skip, jobFilters: jobFilters, salary: salary);
    return super.fetchJobs(pageKey: pageKey, path: path);

  }


}