import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/companies/data/bloc/company_enum.dart';
import 'package:showwcase_v3/features/companies/data/bloc/company_state.dart';
import 'package:showwcase_v3/features/companies/data/models/company_model.dart';
import 'package:showwcase_v3/features/companies/data/repositories/company_repository.dart';

class CompanyCubit extends Cubit<CompanyState> {

  final CompanyRepository companyRepository;

  CompanyCubit({required this.companyRepository}): super(const CompanyState()){
    getCompanyIndustries();
    getCompanyStages();
    getCompanySizes();
  }


  Future<List<CompanyModel>?> searchCompanies({required String keyword}) async {

    try{

      emit(state.copyWith(status: CompanyStatus.searchCompaniesInProgress));

      final either = await companyRepository.searchCompanies(keyword: keyword);
      if(either.isLeft()) {
        final l = either.asLeft();
        emit(state.copyWith(
            status: CompanyStatus.searchCompaniesFailed,
            message: l.errorDescription
        ));
        return null;
      }

      final r = either.asRight();
      emit(state.copyWith(
        status: CompanyStatus.searchCompaniesSuccessful,
      ));
      return r;

    }catch(e) {
      emit(state.copyWith(
          status: CompanyStatus.searchCompaniesFailed,
          message: e.toString()
      ));
      return null;
    }

  }

//  checkIfSlugExistsInProgress
  Future<CompanyModel?> getCompanyBySlug({required String slug}) async {

    try{

      emit(state.copyWith(status: CompanyStatus.getCompanyBySlugInProgress));

      final either = await companyRepository.getCompanyBySlug(slug: slug);
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: CompanyStatus.getCompanyBySlugFailed, message: l.errorDescription));
        return null;
      }

      // then we got a result
      emit(state.copyWith(status: CompanyStatus.getCompanyBySlugSuccessful, ));
      final r = either.asRight();
      return r;


    }catch(e) {
      emit(state.copyWith(status: CompanyStatus.getCompanyBySlugFailed, message: e.toString()));
      return null;
    }

  }


  void getCompanySizes() async {

    try{

      emit(state.copyWith(status: CompanyStatus.getCompanySizesInProgress));

      if(state.companySizes.isNotEmpty) {
        emit(state.copyWith(status: CompanyStatus.getCompanySizesSuccessful,));
      }

      final either = await companyRepository.getCompanySizes();
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: CompanyStatus.getCompanySizesFailed, message: l.errorDescription));
        return null;
      }

      emit(state.copyWith(status: CompanyStatus.getCompanySizesInProgress));
      // then we got a result
      final r = either.asRight();
      emit(state.copyWith(status: CompanyStatus.getCompanySizesSuccessful,
        companySizes: r,
      ));


    }catch(e) {
      emit(state.copyWith(
          status: CompanyStatus.getCompanySizesFailed, message: e.toString(),
      ));
      return null;
    }

  }

  void getCompanyIndustries() async {

    try{

      emit(state.copyWith(status: CompanyStatus.getCompanyIndustriesInProgress));

      if(state.companyIndustries.isNotEmpty) {
        emit(state.copyWith(status: CompanyStatus.getCompanyIndustriesSuccessful,));
      }

      final either = await companyRepository.getCompanyIndustries();
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: CompanyStatus.getCompanyIndustriesFailed, message: l.errorDescription));
        return null;
      }

      emit(state.copyWith(status: CompanyStatus.getCompanyIndustriesInProgress));
      // then we got a result
      final r = either.asRight();
      emit(state.copyWith(status: CompanyStatus.getCompanyIndustriesSuccessful,
          companyIndustries: r
      ));


    }catch(e) {
      emit(state.copyWith(status: CompanyStatus.getCompanyIndustriesFailed, message: e.toString()));
      return null;
    }

  }

  void getCompanyStages() async {

    try{

      emit(state.copyWith(status: CompanyStatus.getCompanyStagesInProgress));

      if(state.companyStages.isNotEmpty) {
        emit(state.copyWith(status: CompanyStatus.getCompanyStagesSuccessful,));
      }

      final either = await companyRepository.getCompanyStages();
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: CompanyStatus.getCompanyStagesFailed, message: l.errorDescription));
        return null;
      }

      emit(state.copyWith(status: CompanyStatus.getCompanyStagesInProgress));
      // then we got a result
      final r = either.asRight();
      emit(state.copyWith(status: CompanyStatus.getCompanyStagesSuccessful,
          companyStages: r
      ));


    }catch(e) {
      emit(state.copyWith(status: CompanyStatus.getCompanyStagesFailed, message: e.toString()));
      return null;
    }

  }



  Future<CompanyModel?> createCompany({required Map<String, dynamic> payload}) async {

    try{

      emit(state.copyWith(status: CompanyStatus.createCompanyInProgress));

      final either = await companyRepository.createCompany(payload: payload);
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: CompanyStatus.createCompanyFailed, message: l.errorDescription));
        return null;
      }

      // then we got a result
      final r = either.asRight();
      // add
      emit(state.copyWith(status: CompanyStatus.createCompanySuccessful, ));
      return r;


    }catch(e) {
      emit(state.copyWith(status: CompanyStatus.createCompanyFailed, message: e.toString()));
      return null;
    }

  }

  Future<void> fetchCompanies({bool replaceFirstPage = false}) async {

    if (!replaceFirstPage && state.hasCompaniesReachedMax) return;

    try {

      emit(state.copyWith(
          status: CompanyStatus.companiesFetching
      ));

      final either = await companyRepository.fetchCompanies(limit: defaultPageSize, skip: replaceFirstPage ? 0 : state.companies.length);

      either.fold((l) {

        emit(state.copyWith(
            message: l.errorDescription,
            status: CompanyStatus.companiesFetchError
        ));

      }, (r) {

        if (replaceFirstPage) {
          emit(state.copyWith(
              status: CompanyStatus.companiesFetchedSuccessful,
              hasCompaniesReachedMax: r.length < defaultPageSize,
              companies: r));
          return;
        }

        if (r.isEmpty) {
          emit(state.copyWith(
            status: CompanyStatus.companiesFetchedSuccessful,
            hasCompaniesReachedMax: true,));
          return;
        }

        emit(state.copyWith(
            companies: List.of(state.companies)..addAll(r),
            status: CompanyStatus.companiesFetchedSuccessful,
            hasCompaniesReachedMax: r.length < defaultPageSize)
        );


      });


    }catch(e) {

      emit(state.copyWith(
          message: e.toString(),
          status: CompanyStatus.companiesFetchError
      ));

    }

  }


}