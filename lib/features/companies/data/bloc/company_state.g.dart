// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CompanyStateCWProxy {
  CompanyState status(CompanyStatus status);

  CompanyState message(String message);

  CompanyState companyIndustries(List<CompanyIndustryModel> companyIndustries);

  CompanyState companySizes(List<CompanySizeModel> companySizes);

  CompanyState hasCompaniesReachedMax(bool hasCompaniesReachedMax);

  CompanyState companyStages(List<CompanyStageModel> companyStages);

  CompanyState companies(List<CompanyModel> companies);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CompanyState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CompanyState(...).copyWith(id: 12, name: "My name")
  /// ````
  CompanyState call({
    CompanyStatus? status,
    String? message,
    List<CompanyIndustryModel>? companyIndustries,
    List<CompanySizeModel>? companySizes,
    bool? hasCompaniesReachedMax,
    List<CompanyStageModel>? companyStages,
    List<CompanyModel>? companies,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCompanyState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCompanyState.copyWith.fieldName(...)`
class _$CompanyStateCWProxyImpl implements _$CompanyStateCWProxy {
  const _$CompanyStateCWProxyImpl(this._value);

  final CompanyState _value;

  @override
  CompanyState status(CompanyStatus status) => this(status: status);

  @override
  CompanyState message(String message) => this(message: message);

  @override
  CompanyState companyIndustries(
          List<CompanyIndustryModel> companyIndustries) =>
      this(companyIndustries: companyIndustries);

  @override
  CompanyState companySizes(List<CompanySizeModel> companySizes) =>
      this(companySizes: companySizes);

  @override
  CompanyState hasCompaniesReachedMax(bool hasCompaniesReachedMax) =>
      this(hasCompaniesReachedMax: hasCompaniesReachedMax);

  @override
  CompanyState companyStages(List<CompanyStageModel> companyStages) =>
      this(companyStages: companyStages);

  @override
  CompanyState companies(List<CompanyModel> companies) =>
      this(companies: companies);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CompanyState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CompanyState(...).copyWith(id: 12, name: "My name")
  /// ````
  CompanyState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? companyIndustries = const $CopyWithPlaceholder(),
    Object? companySizes = const $CopyWithPlaceholder(),
    Object? hasCompaniesReachedMax = const $CopyWithPlaceholder(),
    Object? companyStages = const $CopyWithPlaceholder(),
    Object? companies = const $CopyWithPlaceholder(),
  }) {
    return CompanyState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as CompanyStatus,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      companyIndustries: companyIndustries == const $CopyWithPlaceholder() ||
              companyIndustries == null
          ? _value.companyIndustries
          // ignore: cast_nullable_to_non_nullable
          : companyIndustries as List<CompanyIndustryModel>,
      companySizes:
          companySizes == const $CopyWithPlaceholder() || companySizes == null
              ? _value.companySizes
              // ignore: cast_nullable_to_non_nullable
              : companySizes as List<CompanySizeModel>,
      hasCompaniesReachedMax:
          hasCompaniesReachedMax == const $CopyWithPlaceholder() ||
                  hasCompaniesReachedMax == null
              ? _value.hasCompaniesReachedMax
              // ignore: cast_nullable_to_non_nullable
              : hasCompaniesReachedMax as bool,
      companyStages:
          companyStages == const $CopyWithPlaceholder() || companyStages == null
              ? _value.companyStages
              // ignore: cast_nullable_to_non_nullable
              : companyStages as List<CompanyStageModel>,
      companies: companies == const $CopyWithPlaceholder() || companies == null
          ? _value.companies
          // ignore: cast_nullable_to_non_nullable
          : companies as List<CompanyModel>,
    );
  }
}

extension $CompanyStateCopyWith on CompanyState {
  /// Returns a callable class that can be used as follows: `instanceOfCompanyState.copyWith(...)` or like so:`instanceOfCompanyState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CompanyStateCWProxy get copyWith => _$CompanyStateCWProxyImpl(this);
}
