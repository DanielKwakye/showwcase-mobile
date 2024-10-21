// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jobs_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$JobsStateCWProxy {
  JobsState jobs(List<JobModel> jobs);

  JobsState jobFilters(JobFiltersModel? jobFilters);

  JobsState salaryFilter(double salaryFilter);

  JobsState status(JobStatus status);

  JobsState error(String error);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobsState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobsState(...).copyWith(id: 12, name: "My name")
  /// ````
  JobsState call({
    List<JobModel>? jobs,
    JobFiltersModel? jobFilters,
    double? salaryFilter,
    JobStatus? status,
    String? error,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfJobsState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfJobsState.copyWith.fieldName(...)`
class _$JobsStateCWProxyImpl implements _$JobsStateCWProxy {
  const _$JobsStateCWProxyImpl(this._value);

  final JobsState _value;

  @override
  JobsState jobs(List<JobModel> jobs) => this(jobs: jobs);

  @override
  JobsState jobFilters(JobFiltersModel? jobFilters) =>
      this(jobFilters: jobFilters);

  @override
  JobsState salaryFilter(double salaryFilter) =>
      this(salaryFilter: salaryFilter);

  @override
  JobsState status(JobStatus status) => this(status: status);

  @override
  JobsState error(String error) => this(error: error);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobsState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobsState(...).copyWith(id: 12, name: "My name")
  /// ````
  JobsState call({
    Object? jobs = const $CopyWithPlaceholder(),
    Object? jobFilters = const $CopyWithPlaceholder(),
    Object? salaryFilter = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? error = const $CopyWithPlaceholder(),
  }) {
    return JobsState(
      jobs: jobs == const $CopyWithPlaceholder() || jobs == null
          ? _value.jobs
          // ignore: cast_nullable_to_non_nullable
          : jobs as List<JobModel>,
      jobFilters: jobFilters == const $CopyWithPlaceholder()
          ? _value.jobFilters
          // ignore: cast_nullable_to_non_nullable
          : jobFilters as JobFiltersModel?,
      salaryFilter:
          salaryFilter == const $CopyWithPlaceholder() || salaryFilter == null
              ? _value.salaryFilter
              // ignore: cast_nullable_to_non_nullable
              : salaryFilter as double,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as JobStatus,
      error: error == const $CopyWithPlaceholder() || error == null
          ? _value.error
          // ignore: cast_nullable_to_non_nullable
          : error as String,
    );
  }
}

extension $JobsStateCopyWith on JobsState {
  /// Returns a callable class that can be used as follows: `instanceOfJobsState.copyWith(...)` or like so:`instanceOfJobsState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$JobsStateCWProxy get copyWith => _$JobsStateCWProxyImpl(this);
}
