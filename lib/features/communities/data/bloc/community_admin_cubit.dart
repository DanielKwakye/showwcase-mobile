import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/features/communities/data/models/community_admin_role.dart';
import 'package:showwcase_v3/features/communities/data/models/community_category_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_role_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_thread_tag.dart';
import 'package:showwcase_v3/features/communities/data/models/community_update_request.dart';
import 'package:showwcase_v3/features/communities/data/models/community_update_welcome_screen.dart';
import 'package:showwcase_v3/features/communities/data/repositories/community_repository.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'community_admin_state.dart';

class CommunityAdminCubit extends Cubit<CommunityAdminState> {

  final CommunityRepository communitiesRepository ;

  CommunityAdminCubit({required this.communitiesRepository}) : super(CommunityAdminInitial());


  void fetchCommunityRoles({required int communityId}) async {
    try {
      emit(CommunityRolesLoading());
      final rolesResponse = await communitiesRepository.fetchCommunityRoles(
          communityId: communityId);
      rolesResponse.fold((l) => emit(CommunityRolesError(apiError: l)),
          (r) => emit(CommunityRolesSuccess(rolesResponse: r)));
    } catch (e) {
      emit(CommunityRolesError(
          apiError: ApiError(errorDescription: e.toString())));
    }
  }

  void fetchCommunityCategories() async {
    try {
      emit(CommunityCategoriesLoading());
      final rolesResponse =
          await communitiesRepository.fetchCommunityCategories();
      rolesResponse.fold((l) => emit(CommunityRolesError(apiError: l)),
          (r) => emit(CommunityCategoriesSuccess(categoriesResponse: r)));
    } catch (e) {
      emit(CommunityCategoriesError(
          apiError: ApiError(errorDescription: e.toString())));
    }
  }

  void updateCommunityRoles(
      {required List<int> permissionIds,
      required int roleId,
      required int communityId}) async {
    try {
      emit(UpdateRolesLoading());
      final rolesResponse = await communitiesRepository.updateCommunityRoles(
          communityId: communityId,
          permissionIds: permissionIds,
          roleId: roleId);
      rolesResponse.fold((l) => emit(UpdateRolesError(apiError: l)),
          (r) => emit(UpdateRolesSuccess(rolesResponse: r)));
    } catch (e) {
      emit(UpdateRolesError(apiError: ApiError(errorDescription: e.toString())));
    }
  }

  void addCommunityRole(
      {required String roleName, required int communityId}) async {
    try {
      emit(AddRolesLoading());
      final rolesResponse = await communitiesRepository.addCommunityRole(
          communityId: communityId, roleName: roleName);
      rolesResponse.fold((l) => emit(AddRolesError(apiError: l)),
          (r) => emit(AddRolesSuccess(rolesResponse: r)));
    } catch (e) {
      emit(AddRolesError(apiError: ApiError(errorDescription: e.toString())));
    }
  }

  void updateCommunityRoleName(
      {required String name,
      required int? communityId,
      required int? roleId}) async {
    try {
      emit(UpdateRoleNameLoading());
      final rolesResponse = await communitiesRepository.updateRoleName(
          communityId: communityId, name: name, roleId: roleId);
      rolesResponse.fold((l) => emit(UpdateRolesError(apiError: l)),
          (r) => emit(const UpdateRoleNameSuccess()));
    } catch (e) {
      emit(UpdateRoleNameError(
          apiError: ApiError(errorDescription: e.toString())));
    }
  }

  void sendCommunityInvite(
      {required int? userId, required int? communityId}) async {
    try {
      emit(SendInviteLoading());
      final rolesResponse = await communitiesRepository.sendCommunityInvite(
          userId: userId, communityId: communityId);
      rolesResponse.fold((l) => emit(SendInviteError(apiError: l)),
          (r) => emit(const SendInviteSuccess()));
    } catch (e) {
      emit(SendInviteError(apiError: ApiError(errorDescription: e.toString())));
    }
  }

  void searchPeople({required String text}) async {
    try {
      emit(SearchPeopleLoading());
      final rolesResponse =
          await communitiesRepository.searchPeople(text: text);
      rolesResponse.fold((l) => emit(SearchPeopleError(apiError: l)),
          (r) => emit(SearchPeopleSuccess(networkResponse: r)));
    } catch (e) {
      emit(SearchPeopleError(
          apiError: ApiError(errorDescription: e.toString())));
    }
  }

  void fetchCommunityTags({required String? slug}) async {
    try {
      emit(CommunityTagsLoading());
      final rolesResponse =
          await communitiesRepository.fetchCommunityTags(slug: slug);
      rolesResponse.fold((l) => emit(CommunityTagsError(apiError: l)),
          (r) => emit(CommunityTagsSuccess(communityTags: r)));
    } catch (e) {
      emit(CommunityTagsError(
          apiError: ApiError(errorDescription: e.toString())));
    }
  }

  void updateFeedsTag(
      {required List<CommunityThreadTagsModel> communityTags,
      required int communityId}) async {
    try {
      emit(UpdateFeedsTagsLoading());
      final rolesResponse = await communitiesRepository.updateFeedsTag(
          communityTags: communityTags, communityId: communityId);
      rolesResponse.fold((l) => emit(UpdateFeedsTagsError(apiError: l)), (r) {
        emit(UpdateFeedsTagsSuccess(communityTags: r));
        emit(CommunityTagsSuccess(communityTags: r));
      });
    } catch (e) {
      emit(UpdateFeedsTagsError(
          apiError: ApiError(errorDescription: e.toString())));
    }
  }

  void updateCommunityDetails(
      {required UpdateCommunitiesModel? updateCommunitiesRequest,
      required int communityId}) async {
    try {
      emit(UpdateCommunityLoading());
      final rolesResponse = await communitiesRepository.updateCommunityDetails(
          updateCommunitiesRequest: updateCommunitiesRequest,
          communityId: communityId);
      rolesResponse.fold((l) => emit(UpdateCommunityError(apiError: l)),
          (r) => emit(UpdateCommunitySuccess(communityModel: r)));
    } catch (e) {
      emit(UpdateCommunityError(
          apiError: ApiError(errorDescription: e.toString())));
    }
  }

  void updateInterests(
      {required String slug, required List<String> interests}) async {
    try {
      emit(UpdateInterestsLoading());
      final rolesResponse = await communitiesRepository.updateInterests(
          slug: slug, interests: interests);
      rolesResponse.fold((l) => emit(UpdateInterestsError(apiError: l)),
          (r) => emit(const UpdateInterestsSuccess()));
    } catch (e) {
      emit(UpdateInterestsError(
          apiError: ApiError(errorDescription: e.toString())));
    }
  }


  void assignMemberRole(
      {required int? userId,
      required int? roleId,
      required int? communityId}) async {
    try {
      emit(AssignMemberRoleLoading());
      final rolesResponse = await communitiesRepository.assignMemberRole(
          userId: userId, roleId: roleId, communityId: communityId);
      rolesResponse.fold((l) => emit(AssignMemberRoleError(apiError: l)),
          (r) => emit(const AssignMemberRoleSuccess()));
    } catch (e) {
      emit(AssignMemberRoleError(
          apiError: ApiError(errorDescription: e.toString())));
    }
  }

  void updateCommunityWelcomeScreen(
      {required CommunityUpdateWelcomeScreen? updateWelcomeScreen}) async {
    try {
      emit(UpdateCommunityLoading());
      final rolesResponse =
          await communitiesRepository.updateCommunityWelcomeScreen(
              updateWelcomeScreen: updateWelcomeScreen);
      rolesResponse.fold((l) => emit(UpdateCommunityError(apiError: l)),
          (r) => emit(UpdateCommunitySuccess(communityModel: r)));
    } catch (e) {
      emit(UpdateCommunityError(
          apiError: ApiError(errorDescription: e.toString())));
    }
  }

  void searchCommunityTag({required String text}) async {
    try {
      emit(SearchPeopleLoading());
      final rolesResponse =
          await communitiesRepository.searchCommunityTag(keyword: text);
      rolesResponse.fold((l) => emit(SearchPeopleError(apiError: l)),
          (r) => emit(SearchTagsSuccess(tagSuggestions: r)));
    } catch (e) {
      emit(SearchPeopleError(
          apiError: ApiError(errorDescription: e.toString())));
    }
  }

  void deleteCommunityRole(
      {required int? roleId, required int? communityId}) async {
    try {
      emit(DeleteRoleLoading());
      final rolesResponse = await communitiesRepository.deleteCommunityRole(
          roleId: roleId, communityId: communityId);
      rolesResponse.fold((l) => emit(DeleteRoleError(apiError: l)),
          (r) => emit(const DeleteRoleSuccess()));
    } catch (e) {
      emit(DeleteRoleError(apiError: ApiError(errorDescription: e.toString())));
    }
  }

  void updateCommunityTag(
      {required List<String> tags, required int? communityId}) async {
    try {
      emit(UpdateCommunityTagsLoading());
      final rolesResponse = await communitiesRepository.updateCommunityTag(
          tags: tags, communityId: communityId);
      rolesResponse.fold((l) => emit(UpdateCommunityTagsError(apiError: l)),
          (r) => emit(UpdateCommunityTagsSuccess(successResponse: r)));
    } catch (e) {
      emit(UpdateCommunityTagsError(
          apiError: ApiError(errorDescription: e.toString())));
    }
  }

  void deleteCommunity({ required int? communityId}) async {
    try {
      emit(DeleteCommunityLoading());
      final rolesResponse = await communitiesRepository.deleteCommunity(communityId: communityId);
      rolesResponse.fold((l) => emit(DeleteCommunityError(apiError: l)),
          (r) => emit(DeleteCommunitySuccess(result: r)));
    } catch (e) {
      emit(DeleteCommunityError(
          apiError: ApiError(errorDescription: e.toString())));
    }
  }

  void fetchInterests()async{
    try{
      emit(FetchInterestsLoading());
      final either = await communitiesRepository.fetchInterests();
      either.fold((l) => emit(FetchInterestsError(error: l.errorDescription)), (r) => emit(FetchInterestsSuccess(result: r)));
    }catch(e){
      emit(FetchInterestsError(error: e.toString()));
    }
  }
}
