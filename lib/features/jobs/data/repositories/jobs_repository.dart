import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/features/companies/data/models/company_model.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_enums.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_filters_model.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_model.dart';

class JobsRepository   {

  final NetworkProvider networkProvider ;

  JobsRepository({required this.networkProvider});

  Future<Either<ApiError, List<JobModel>>> fetchJobs({required String path}) async {
    try {

      final response = await networkProvider.call(path: path, method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final  List<JobModel> jobModel  = List<JobModel>.from(response.data.map((x) => JobModel.fromJson(x)));
        return Right(jobModel);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioException catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }


  Future<Either<ApiError, List<CompanyModel>>> fetchCompanies({int limit = 25, int skip = 0}) async {
    try {
      final path = ApiConfig.fetchCompanies(limit: limit, skip: skip);
      final response =
      await networkProvider.call(path: path, method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final companyResponse = List<CompanyModel>.from(response.data.map((x) => CompanyModel.fromJson(x)));
        return Right(companyResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, JobFiltersModel>> fetchJobFilters() async {
    try {
      final path = ApiConfig.fetchJobFilters;

      final response =
          await networkProvider.call(path: path,
              method: RequestMethod.get,
          );

      if (response!.statusCode == 200) {
        final JobFiltersModel jobFiltersModel = JobFiltersModel.fromJson(response.data);
        return Right(jobFiltersModel);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, JobModel>> fetchJobsPreview({required int jobId}) async {
    try {
      final path = ApiConfig.fetchJobPreview(jobId: jobId);

      final response =
          await networkProvider.call(path: path,
        method: RequestMethod.get,
      );

      if (response!.statusCode == 200) {
        final JobModel jobModel = JobModel.fromJson(response.data);
        return Right(jobModel);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, void>> bookmarkJob({required int jobId, required bool isBookmark}) async {

    try {
      var response = await networkProvider.call(
          path: ApiConfig.bookmark,
          method: isBookmark ? RequestMethod.post : RequestMethod.delete,
          body: {'jobId': jobId});
      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }
}