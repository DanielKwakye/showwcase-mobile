import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_enums.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_model.dart';


part 'job_preview_state.g.dart';

@CopyWith()
class JobPreviewState extends Equatable{

  final JobStatus status;
  final String message;
  final List<JobModel> jobPreviews;
  final dynamic data; // holds any temporal data

  // key is the parentThread (threadPreview) id, and values are the thread replies
  final Map<int, List<JobModel>> relatedJobs;

  const JobPreviewState({
    this.status = JobStatus.initial,
    this.message = '',
    this.jobPreviews = const [],
    this.relatedJobs = const {},
    this.data
  });

  @override
  List<Object?> get props => [status, jobPreviews, relatedJobs];

}