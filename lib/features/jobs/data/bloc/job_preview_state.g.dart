// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_preview_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$JobPreviewStateCWProxy {
  JobPreviewState status(JobStatus status);

  JobPreviewState message(String message);

  JobPreviewState jobPreviews(List<JobModel> jobPreviews);

  JobPreviewState relatedJobs(Map<int, List<JobModel>> relatedJobs);

  JobPreviewState data(dynamic data);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobPreviewState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobPreviewState(...).copyWith(id: 12, name: "My name")
  /// ````
  JobPreviewState call({
    JobStatus? status,
    String? message,
    List<JobModel>? jobPreviews,
    Map<int, List<JobModel>>? relatedJobs,
    dynamic data,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfJobPreviewState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfJobPreviewState.copyWith.fieldName(...)`
class _$JobPreviewStateCWProxyImpl implements _$JobPreviewStateCWProxy {
  const _$JobPreviewStateCWProxyImpl(this._value);

  final JobPreviewState _value;

  @override
  JobPreviewState status(JobStatus status) => this(status: status);

  @override
  JobPreviewState message(String message) => this(message: message);

  @override
  JobPreviewState jobPreviews(List<JobModel> jobPreviews) =>
      this(jobPreviews: jobPreviews);

  @override
  JobPreviewState relatedJobs(Map<int, List<JobModel>> relatedJobs) =>
      this(relatedJobs: relatedJobs);

  @override
  JobPreviewState data(dynamic data) => this(data: data);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobPreviewState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobPreviewState(...).copyWith(id: 12, name: "My name")
  /// ````
  JobPreviewState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? jobPreviews = const $CopyWithPlaceholder(),
    Object? relatedJobs = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
  }) {
    return JobPreviewState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as JobStatus,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      jobPreviews:
          jobPreviews == const $CopyWithPlaceholder() || jobPreviews == null
              ? _value.jobPreviews
              // ignore: cast_nullable_to_non_nullable
              : jobPreviews as List<JobModel>,
      relatedJobs:
          relatedJobs == const $CopyWithPlaceholder() || relatedJobs == null
              ? _value.relatedJobs
              // ignore: cast_nullable_to_non_nullable
              : relatedJobs as Map<int, List<JobModel>>,
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as dynamic,
    );
  }
}

extension $JobPreviewStateCopyWith on JobPreviewState {
  /// Returns a callable class that can be used as follows: `instanceOfJobPreviewState.copyWith(...)` or like so:`instanceOfJobPreviewState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$JobPreviewStateCWProxy get copyWith => _$JobPreviewStateCWProxyImpl(this);
}
