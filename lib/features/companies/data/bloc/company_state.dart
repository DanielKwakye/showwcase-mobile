import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/companies/data/bloc/company_enum.dart';
import 'package:showwcase_v3/features/companies/data/models/company_industry_model.dart';
import 'package:showwcase_v3/features/companies/data/models/company_model.dart';
import 'package:showwcase_v3/features/companies/data/models/company_size_model.dart';

import '../models/company_stage_model.dart';

part 'company_state.g.dart';

@CopyWith()
class CompanyState extends Equatable {

  final CompanyStatus status;
  final String message;
  final List<CompanyIndustryModel> companyIndustries;
  final List<CompanySizeModel> companySizes;
  final List<CompanyStageModel> companyStages;
  final List<CompanyModel> companies;
  final bool hasCompaniesReachedMax;

  const CompanyState({
    this.status = CompanyStatus.initial,
    this.message = '',
    this.companyIndustries = const [],
    this.companySizes = const [],
    this.hasCompaniesReachedMax = false,
    this.companyStages = const [],
    this.companies = const [],
  });

  @override
  List<Object?> get props => [status];

}