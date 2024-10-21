import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_enums.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_state.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_broadcast_event.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_filters_model.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_model.dart';
import 'package:showwcase_v3/features/jobs/data/repositories/job_broadcast_repository.dart';
import 'package:showwcase_v3/features/jobs/data/repositories/jobs_repository.dart';

class JobsCubit extends Cubit<JobsState> {
  final JobsRepository jobsRepository ;
  final JobBroadcastRepository jobBroadcastRepository ;
  StreamSubscription<JobBroadcastEvent>? jobBroadcastRepositoryStreamListener;

  JobsCubit({required this.jobsRepository, required this.jobBroadcastRepository}) : super(const JobsState()) {
    _listenToJobBroadCastStreams();
  }

  @override
  Future<void> close() async {
    await jobBroadcastRepositoryStreamListener?.cancel();
    return super.close();
  }

  // listen to updated show streams and update thread states accordingly
  void _listenToJobBroadCastStreams() async {
    await jobBroadcastRepositoryStreamListener?.cancel();
    jobBroadcastRepositoryStreamListener = jobBroadcastRepository.stream.listen((jobBroadcastEvent) {

      if(jobBroadcastEvent.action == JobBroadcastAction.update) {

        final updatedJob = jobBroadcastEvent.job;

        emit(state.copyWith(status: JobStatus.updateJobInProgress));
        // find the thread whose values are updated
        final jobIndex = state.jobs.indexWhere((element) => element.id == updatedJob.id);

        // we can't continue if thread wasn't found
        // For some subclasses of threadCubit, this thread will not be found
        if(jobIndex < 0){return;}

        final updatedJobsList = [...state.jobs];
        updatedJobsList[jobIndex] = updatedJob;

        // if thread was found in this cubit then update, and notify all listening UIs
        emit(state.copyWith(
            jobs: updatedJobsList,
            status: JobStatus.updateJobCompleted,
        ));
      }

    });
  }


  /// Fetch threads from the server by Path
  ///
  Future<Either<String, List<JobModel>>> fetchJobs({required int pageKey, required String path}) async {

    try{

      emit(state.copyWith(status: JobStatus.fetchJobsInProgress));
      final either = await jobsRepository.fetchJobs(path: path);
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: JobStatus.fetchJobsFailed, error: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful
      List<JobModel> r = either.asRight();
      final List<JobModel> jobs = [...state.jobs];
      if(pageKey == 0){
        // if its first page request remove all existing threads
        jobs.clear();
      }

      jobs.addAll(r);

      emit(state.copyWith(
        status: JobStatus.fetchJobsSuccessful,
        jobs: jobs,
      ));

      return Right(r);

    }catch(e){
      debugPrint("customLog: $e");
      emit(state.copyWith(status: JobStatus.fetchJobsFailed, error: e.toString()));
      return Left(e.toString());
    }

  }

  Future<void> fetchJobsFilters() async {

    try {

      emit(state.copyWith(status: JobStatus.jobsFiltersFetching));

      // this is to prevent fetching from the server again when jobs filters are already fetched
      if(state.jobFilters != null){
        emit(state.copyWith(status: JobStatus.jobsFiltersFetchedSuccessful, jobFilters: state.jobFilters,));
        return;
      }

      final either = await jobsRepository.fetchJobFilters();

      either.fold((l) => emit(state.copyWith(
          status: JobStatus.jobsFiltersFetchError, error: l.errorDescription)),
              (r) {
            emit(state.copyWith(jobFilters: r, status: JobStatus.jobsFiltersFetchedSuccessful));
          }
      );

    }catch(e) {

      emit(state.copyWith(
          error: e.toString(),
          status: JobStatus.jobsFiltersFetchError
      ));

    }

  }

  void clearAllJobFilters() {
    emit(state.copyWith(status: JobStatus.togglingJobsFilter));
    emit(state.copyWith(jobFilters: null, salaryFilter: 0.0,
        status: JobStatus.jobsFilterToggled
    ));
  }

  /// positions job filter section
  void selectDeselectJobPositionsFilter(Map<String, dynamic> map){

    emit(state.copyWith(status: JobStatus.togglingJobsFilter));

    JobFiltersModel? filters = state.jobFilters?.copyWith();
    final index = filters!.positions!.indexWhere((element) => element['filter'] == map['filter']);
    filters.positions![index] = map;

    emit(state.copyWith(
        jobFilters: filters,
        status: JobStatus.jobsFilterToggled
    ));

  }

  /// locations job filter section
  void selectDeselectJobLocationFilter(Map<String, dynamic> map){

    emit(state.copyWith(status: JobStatus.togglingJobsFilter));

    final filters = state.jobFilters?.copyWith();
    final index = filters!.locations!.indexWhere((element) => element['filter'] == map['filter']);
    filters.locations![index] = map;

    emit(state.copyWith(
        jobFilters: filters,
        status: JobStatus.jobsFilterToggled
    ));

  }

  /// job types job filter section
  void selectDeselectJobTypesFilter(Map<String, dynamic> map){

    emit(state.copyWith(status: JobStatus.togglingJobsFilter));

    final filters = state.jobFilters?.copyWith();
    final index = filters!.types!.indexWhere((element) => element['filter'] == map['filter']);
    filters.types![index] = map;

    emit(state.copyWith(
        jobFilters: filters,
        status: JobStatus.jobsFilterToggled
    ));
  }

  /// job types job filter section
  void selectDeselectJobStacksFilter(Map<String, dynamic> map){

    emit(state.copyWith(status: JobStatus.togglingJobsFilter));

    final filters = state.jobFilters?.copyWith();
    final index = filters!.stacks!.indexWhere((element) => element['filter'] == map['filter']);
    filters.stacks![index] = map;

    emit(state.copyWith(
        jobFilters: filters,
        status: JobStatus.jobsFilterToggled
    ));

  }


  /// salary job filter section
  void updateSalaryFilter({required double salary}){

    // just save the new salary
    emit(state.copyWith(status: JobStatus.togglingJobsFilter));
    emit(state.copyWith(
      salaryFilter: salary,
      status: JobStatus.jobsFilterToggled,
    ));
  }

  void removeSalaryFilter({bool refreshPage = false}){

    emit(state.copyWith(status: JobStatus.togglingJobsFilter));
    emit(state.copyWith(
        status: JobStatus.jobsFilterToggled,
        salaryFilter: 0.0
    ));
  }

  /// bookmark job
  void bookmarkJob({required JobModel job, required bool isBookmark}) async {

    // job id cannot be null
    if(job.id == null){
      return;
    }

    update() {
      /// The mechanism here is to broadcast the updated Job to the app so that
      /// any subClassed cubit having this job updates accordingly
      final updatedJob = job.copyWith(
          hasBookmarked: isBookmark
      );
      jobBroadcastRepository.updateJob(job: updatedJob);
    }

    reverse(String reason) {
      /// The mechanism here is to broadcast the updated Job to the app so that
      /// any subClassed cubit having this job updates accordingly
      final updatedJob = job.copyWith(
          hasBookmarked: job.hasBookmarked
      );
      jobBroadcastRepository.updateJob(job: updatedJob);
    }


    // optimistic update
    update();

    try{

      final either = await jobsRepository.bookmarkJob(jobId: job.id!, isBookmark: isBookmark);
      either.fold((l) => reverse(l.errorDescription),
              (r) {
            // we do nothing again when its successful, cus we've already called the update() functionality
                emit(state.copyWith(status: JobStatus.refreshBookmarksInProgress));
                emit(state.copyWith(status: JobStatus.refreshBookmarks));
          }
      );
    }catch(e){
      reverse(e.toString());
    }

  }

}