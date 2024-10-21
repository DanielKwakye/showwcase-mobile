import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/job_preview_state.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_enums.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_state.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_broadcast_event.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_model.dart';
import 'package:showwcase_v3/features/jobs/data/repositories/job_broadcast_repository.dart';
import 'package:showwcase_v3/features/jobs/data/repositories/jobs_repository.dart';

class JobPreviewCubit extends Cubit<JobPreviewState> {

  final JobBroadcastRepository jobBroadcastRepository ;
  final JobsRepository jobsRepository ;
  StreamSubscription<JobBroadcastEvent>? jobBroadcastRepositoryStreamListener;
  JobPreviewCubit({required this.jobsRepository, required this.jobBroadcastRepository}): super(const JobPreviewState()) {
    _listenToJobBroadCastStreams();
  }

  @override
  Future<void> close() async {
    await jobBroadcastRepositoryStreamListener?.cancel();
    return super.close();
  }

  // listen to updated thread streams and update thread states accordingly
  void _listenToJobBroadCastStreams() async {

    await jobBroadcastRepositoryStreamListener?.cancel();
    jobBroadcastRepositoryStreamListener = jobBroadcastRepository.stream.listen((jobBroadcastEvent) {

      /// job updated
      if(jobBroadcastEvent.action == JobBroadcastAction.update) {

        final updatedJob = jobBroadcastEvent.job;

        // find the show whose values are updated
        final jobPreviews = [...state.jobPreviews];
        final jobIndex = jobPreviews.indexWhere((element) => element.id == updatedJob.id);

        // we can't continue if job wasn't found
        // For some subclasses of jobCubit, this thread will not be found
        if(jobIndex > -1){
          final updatedJobList = jobPreviews;
          updatedJobList[jobIndex] = updatedJob;

          emit(state.copyWith(status: JobStatus.updateJobInProgress));
          // if Job was found in this cubit then update, and notify all listening UIs
          emit(state.copyWith(
            jobPreviews: updatedJobList,
            status: JobStatus.updateJobCompleted,
          ));
        }

        // check if the updated job is in recommended shows
        final relatedJobsMap = {...state.relatedJobs};
        relatedJobsMap.forEach((key, List<JobModel> relatedJobs) {

          final jobIndex = relatedJobs.indexWhere((element) => element.id == updatedJob.id);
          if(jobIndex > -1){

            relatedJobs[jobIndex] = updatedJob;
            relatedJobsMap[key] = relatedJobs;
          }

        });

        emit(state.copyWith(status: JobStatus.updateJobInProgress));
        emit(state.copyWith(
          relatedJobs: relatedJobsMap,
          status: JobStatus.updateJobCompleted,
        ));


      }


    });
  }

  JobModel setJobPreview({required JobModel job}){

    /// This method here adds the a given thread to the threads of interest
    /// Once a thread is previewed it becomes a thread of interest

    emit(state.copyWith(status: JobStatus.setJobPreviewInProgress,));
    final jobPreviews = [...state.jobPreviews];
    final int index = jobPreviews.indexWhere((element) => element.id == job.id);
    if(index < 0){
      jobPreviews.add(job);
    }else {
      // jobPreview has already been added
      // so update it.
      jobPreviews[index] = job;
    }

    emit(state.copyWith(
        status: JobStatus.setJobPreviewCompleted,
        jobPreviews: jobPreviews
    ));

    // return the threadPreview for methods that needs it
    final threadPreview = state.jobPreviews.firstWhere((element) => element.id == job.id);
    return threadPreview;

  }


  Future<void> fetchJobPreview({required JobModel jobModel}) async {

    try {

      emit(state.copyWith(status: JobStatus.jobsPreviewFetching));
      final either = await jobsRepository.fetchJobsPreview(jobId: jobModel.id!);

      either.fold(
          (l) => emit(state.copyWith(
              status: JobStatus.jobsPreviewFetchingError,
              message: l.errorDescription)), (r) {

        setJobPreview(job: r);
        emit(state.copyWith(status: JobStatus.jobsPreviewFetchingSuccessful));

      });
    }catch(e) {

      emit(state.copyWith(
          message: e.toString(),
          status: JobStatus.jobsPreviewFetchingError
      ));

    }
  }

}