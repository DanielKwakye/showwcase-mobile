import 'dart:async';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_enums.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_broadcast_event.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_model.dart';

class JobBroadcastRepository {

  final _controller = StreamController<JobBroadcastEvent>.broadcast();
  Stream<JobBroadcastEvent> get stream => _controller.stream;

  void updateJob({required JobModel job}) {
    _controller.sink.add(JobBroadcastEvent(action: JobBroadcastAction.update, job: job));
  }


}