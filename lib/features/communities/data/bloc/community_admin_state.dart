part of 'community_admin_cubit.dart';

abstract class CommunityAdminState extends Equatable {
  const CommunityAdminState();
}

class CommunityAdminInitial extends CommunityAdminState {
  @override
  List<Object> get props => [];
}



class CommunityCategoriesLoading extends CommunityAdminState {
  @override
  List<Object> get props => [];
}

class CommunityCategoriesSuccess extends CommunityAdminState {
  final List<CommunityCategoryModel> categoriesResponse ;

  const CommunityCategoriesSuccess({required this.categoriesResponse});
  @override
  List<Object> get props => [categoriesResponse];
}

class CommunityCategoriesError extends CommunityAdminState {
  final ApiError apiError ;

  const CommunityCategoriesError({required this.apiError});
  @override
  List<Object> get props => [apiError];
}


class CommunityRolesLoading extends CommunityAdminState {
  @override
  List<Object> get props => [];
}

class CommunityRolesSuccess extends CommunityAdminState {
  final List<CommunityAdminRoleModel> rolesResponse ;

  const CommunityRolesSuccess({required this.rolesResponse});
  @override
  List<Object> get props => [rolesResponse];
}

class CommunityRolesError extends CommunityAdminState {
  final ApiError apiError ;
  const CommunityRolesError({required this.apiError});
  @override
  List<Object> get props => [apiError];
}


class UpdateRolesLoading extends CommunityAdminState {
  @override
  List<Object> get props => [];
}

class UpdateRolesSuccess extends CommunityAdminState {
  final List<CommunityRoleModel> rolesResponse ;

  const UpdateRolesSuccess({required this.rolesResponse});
  @override
  List<Object> get props => [rolesResponse];
}

class UpdateRolesError extends CommunityAdminState {
  final ApiError apiError ;
  const UpdateRolesError({required this.apiError});
  @override
  List<Object> get props => [apiError];
}


class AddRolesLoading extends CommunityAdminState {
  @override
  List<Object> get props => [];
}

class AddRolesSuccess extends CommunityAdminState {
  final CommunityAdminRoleModel rolesResponse ;

  const AddRolesSuccess({required this.rolesResponse});
  @override
  List<Object> get props => [rolesResponse];
}

class AddRolesError extends CommunityAdminState {
  final ApiError apiError ;
  const AddRolesError({required this.apiError});
  @override
  List<Object> get props => [apiError];
}


class UpdateRoleNameLoading extends CommunityAdminState {
  @override
  List<Object> get props => [];
}

class UpdateRoleNameSuccess extends CommunityAdminState {


  const UpdateRoleNameSuccess();
  @override
  List<Object> get props => [];
}

class UpdateRoleNameError extends CommunityAdminState {
  final ApiError apiError ;

  const UpdateRoleNameError({required this.apiError});
  @override
  List<Object> get props => [apiError];
}


class SendInviteLoading extends CommunityAdminState {
  @override
  List<Object> get props => [];
}

class SendInviteSuccess extends CommunityAdminState {

  const SendInviteSuccess();
  @override
  List<Object> get props => [];
}

class SendInviteError extends CommunityAdminState {
  final ApiError apiError ;

  const SendInviteError({required this.apiError});
  @override
  List<Object> get props => [apiError];
}


class SearchPeopleLoading extends CommunityAdminState {
  @override
  List<Object> get props => [];
}

class SearchPeopleSuccess extends CommunityAdminState {
  final List<UserModel> networkResponse ;

  const SearchPeopleSuccess({required this.networkResponse});
  @override
  List<Object> get props => [networkResponse];
}

class SearchPeopleError extends CommunityAdminState {
  final ApiError apiError ;

  const SearchPeopleError({required this.apiError});

  @override
  List<Object> get props => [apiError];
}


class CommunityTagsLoading extends CommunityAdminState {
  @override
  List<Object> get props => [];
}

class CommunityTagsSuccess extends CommunityAdminState {
  final List<CommunityThreadTagsModel> communityTags ;

  const CommunityTagsSuccess({required this.communityTags});
  @override
  List<Object> get props => [communityTags];
}

class CommunityTagsError extends CommunityAdminState {
  final ApiError apiError ;

  const CommunityTagsError({required this.apiError});

  @override
  List<Object> get props => [apiError];
}


class UpdateFeedsTagsLoading extends CommunityAdminState {
  @override
  List<Object> get props => [];
}

class UpdateFeedsTagsSuccess extends CommunityAdminState {
  final List<CommunityThreadTagsModel> communityTags ;

  const UpdateFeedsTagsSuccess({required this.communityTags});
  @override
  List<Object> get props => [communityTags];
}

class UpdateFeedsTagsError extends CommunityAdminState {
  final ApiError apiError ;

  const UpdateFeedsTagsError({required this.apiError});

  @override
  List<Object> get props => [apiError];
}


class UpdateCommunityLoading extends CommunityAdminState {
  @override
  List<Object> get props => [];
}

class UpdateCommunitySuccess extends CommunityAdminState {
  final CommunityModel communityModel ;

  const UpdateCommunitySuccess({required this.communityModel});
  @override
  List<Object> get props => [communityModel];
}

class UpdateCommunityError extends CommunityAdminState {
  final ApiError apiError ;

  const UpdateCommunityError({required this.apiError});

  @override
  List<Object> get props => [apiError];
}



class UpdateInterestsLoading extends CommunityAdminState {
  @override
  List<Object> get props => [];
}

class UpdateInterestsSuccess extends CommunityAdminState {

  const UpdateInterestsSuccess();
  @override
  List<Object> get props => [];
}

class UpdateInterestsError extends CommunityAdminState {
  final ApiError apiError ;

  const UpdateInterestsError({required this.apiError});

  @override
  List<Object> get props => [apiError];
}


class ManageFeatureLoading extends CommunityAdminState {
  @override
  List<Object> get props => [];
}

class ManageFeatureSuccess extends CommunityAdminState {

  const ManageFeatureSuccess();
  @override
  List<Object> get props => [];
}

class ManageFeatureError extends CommunityAdminState {
  final ApiError apiError ;

  const ManageFeatureError({required this.apiError});

  @override
  List<Object> get props => [apiError];
}


class AssignMemberRoleLoading extends CommunityAdminState {
  @override
  List<Object> get props => [];
}

class AssignMemberRoleSuccess extends CommunityAdminState {

  const AssignMemberRoleSuccess();
  @override
  List<Object> get props => [];
}

class AssignMemberRoleError extends CommunityAdminState {
  final ApiError apiError ;

  const AssignMemberRoleError({required this.apiError});

  @override
  List<Object> get props => [apiError];
}


class SearchTagsLoading extends CommunityAdminState {
  @override
  List<Object> get props => [];
}

class SearchTagsSuccess extends CommunityAdminState {
  final List<String> tagSuggestions ;

  const SearchTagsSuccess({required this.tagSuggestions});
  @override
  List<Object> get props => [tagSuggestions];
}

class SearchTagsError extends CommunityAdminState {
  final ApiError apiError ;

  const SearchTagsError({required this.apiError});

  @override
  List<Object> get props => [apiError];
}



class DeleteRoleLoading extends CommunityAdminState {
  @override
  List<Object> get props => [];
}

class DeleteRoleSuccess extends CommunityAdminState {

  const DeleteRoleSuccess();
  @override
  List<Object> get props => [];
}

class DeleteRoleError extends CommunityAdminState {
  final ApiError apiError ;

  const DeleteRoleError({required this.apiError});

  @override
  List<Object> get props => [apiError];
}



class UpdateCommunityTagsLoading extends CommunityAdminState {
  @override
  List<Object> get props => [];
}

class UpdateCommunityTagsSuccess extends CommunityAdminState {
  final List<String> successResponse ;

  const UpdateCommunityTagsSuccess({required this.successResponse});
  @override
  List<Object> get props => [successResponse];
}

class UpdateCommunityTagsError extends CommunityAdminState {
  final ApiError apiError ;

  const UpdateCommunityTagsError({required this.apiError});

  @override
  List<Object> get props => [apiError];
}


class DeleteCommunityLoading extends CommunityAdminState {
  @override
  List<Object> get props => [];
}

class DeleteCommunitySuccess extends CommunityAdminState {
  final String result ;

  const DeleteCommunitySuccess({required this.result});
  @override
  List<Object> get props => [result];
}

class DeleteCommunityError extends CommunityAdminState {
  final ApiError apiError ;

  const DeleteCommunityError({required this.apiError});

  @override
  List<Object> get props => [apiError];
}


class FetchInterestsLoading extends CommunityAdminState {
  @override
  List<Object> get props => [];
}

class FetchInterestsSuccess extends CommunityAdminState {
  final List<String> result;

  const FetchInterestsSuccess({required this.result});

  @override
  List<Object> get props => [result];
}

class FetchInterestsError extends CommunityAdminState {
  final String error;

  const FetchInterestsError({required this.error});

  @override
  List<Object> get props => [error];
}




