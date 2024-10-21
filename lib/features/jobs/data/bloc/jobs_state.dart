import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/companies/data/models/company_model.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_enums.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_filters_model.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_model.dart';

part 'jobs_state.g.dart';

@CopyWith()
class JobsState extends Equatable {

  final JobStatus status;
  final String error;
  final List<JobModel> jobs;
  final JobFiltersModel? jobFilters;
  final double salaryFilter;

  const JobsState({
    this.jobs = const [],
    this.jobFilters,
    this.salaryFilter = 0.0,
    this.status = JobStatus.initial,
    this.error = '',
  });

  @override
  List<Object?> get props => [jobs, status];


}