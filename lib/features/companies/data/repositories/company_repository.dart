import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/features/companies/data/models/company_industry_model.dart';
import 'package:showwcase_v3/features/companies/data/models/company_model.dart';
import 'package:showwcase_v3/features/companies/data/models/company_size_model.dart';
import 'package:showwcase_v3/features/companies/data/models/company_stage_model.dart';

class CompanyRepository {

  final NetworkProvider _networkProvider;
  CompanyRepository(this._networkProvider);

  Future<Either<ApiError, List<CompanyModel>?>> searchCompanies({required String keyword}) async {

    try{
      var response = await _networkProvider.call(path: ApiConfig.searchCompanies(query: keyword), method: RequestMethod.get);
      if(response!.statusCode == 200){
        final cities =  List<CompanyModel>.from(response.data.map((x) => CompanyModel.fromJson(x)));
        return Right(cities);
      }else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch(e){
      return Left(ApiError(errorDescription: e.toString()));
    }

  }


  Future<Either<ApiError, CompanyModel>> getCompanyBySlug({required String slug}) async{

    try{
      final response = await _networkProvider.call(path: ApiConfig.getCompanyBySlug(slug: slug), method: RequestMethod.get);
      if(response!.statusCode == 200){

        final companyFound = CompanyModel.fromJson(response.data);
        return  Right(companyFound);

      }else{
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioException catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, List<CompanySizeModel>>> getCompanySizes() async{

    try{
      final response = await _networkProvider.call(path: ApiConfig.getCompanySizes, method: RequestMethod.get);
      if(response!.statusCode == 200){

        final companySizes =  List<CompanySizeModel>.from(response.data.map((x) => CompanySizeModel.fromJson(x)));
        return Right(companySizes);

      }else{
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, List<CompanyIndustryModel>>> getCompanyIndustries() async{

    try{
      final response = await _networkProvider.call(path: ApiConfig.getCompanyIndustries, method: RequestMethod.get);
      if(response!.statusCode == 200){

        final companyIndustries =  List<CompanyIndustryModel>.from(response.data.map((x) => CompanyIndustryModel.fromJson(x)));
        return Right(companyIndustries);

      }else{
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, List<CompanyStageModel>>> getCompanyStages() async{

    try{
      final response = await _networkProvider.call(path: ApiConfig.getCompanyStages, method: RequestMethod.get);
      if(response!.statusCode == 200){

        final companyStages =  List<CompanyStageModel>.from(response.data.map((x) => CompanyStageModel.fromJson(x)));
        return Right(companyStages);

      }else{
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, CompanyModel>> createCompany({required Map<String, dynamic> payload}) async{

    try{
      final response = await _networkProvider.call(
          path: ApiConfig.companies,
          method: RequestMethod.post,
          body: payload
      );
      if(response!.statusCode == 200){

        final companyFound = CompanyModel.fromJson(response.data);
        return  Right(companyFound);

      }else{
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, List<CompanyModel>>> fetchCompanies({int limit = 25, int skip = 0}) async {
    try {
      final path = ApiConfig.fetchCompanies(limit: limit, skip: skip);
      final response =
      await _networkProvider.call(path: path, method: RequestMethod.get);

      if (response!.statusCode == 200) {
        List<CompanyModel> companyResponse = List<CompanyModel>.from(response.data.map((x) => CompanyModel.fromJson(x)));
        return Right(companyResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

}