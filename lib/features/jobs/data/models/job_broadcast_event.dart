import 'package:showwcase_v3/features/jobs/data/bloc/jobs_enums.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_model.dart';

class JobBroadcastEvent {
  final JobBroadcastAction action;
  final JobModel job;
  const JobBroadcastEvent({required this.action, required this.job});
}