import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/features/communities/data/models/community_admin_role.dart';
import 'package:showwcase_v3/features/communities/data/models/community_category_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_report_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_role_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_thread_tag.dart';
import 'package:showwcase_v3/features/communities/data/models/community_update_request.dart';
import 'package:showwcase_v3/features/communities/data/models/community_update_welcome_screen.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class CommunityRepository {
  final NetworkProvider networkProvider;
  const CommunityRepository(this.networkProvider);


  Future<Either<ApiError, List<CommunityModel>>> fetchCommunities({required String path}) async {
    try {
      var response = await networkProvider.call(
          path: path,
          method: RequestMethod.get);
      if (response!.statusCode == 200) {
        final communities = List<CommunityModel>.from(
            response.data.map((x) => CommunityModel.fromJson(x)));
        return Right(communities);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioException catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }


  Future<Either<ApiError, List<CommunityModel>>> fetchSuggestedCommunities({int limit = 25, int skip = 0}) async{
    try {
      var response = await networkProvider.call(
          path: ApiConfig.fetchInterestingCommunities(limit: limit,skip: skip),
          method: RequestMethod.get);
      if (response!.statusCode == 200) {
        final communities = List<CommunityModel>.from(response.data.map((x) => CommunityModel.fromJson(x)));
        return Right(communities);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, void>> joinAndLeaveCommunity({required int communityId, required String action})async {
    /// actions are [join, leave]
    try {
      var response = await networkProvider.call(path: ApiConfig.joinAndLeaveCommunity(actionType: action, communityId: communityId), method: RequestMethod.post);
      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<CommunityModel>>> fetchUserCommunities({required String userName,int limit = 25, int skip = 0,})async {
    try {
      var response = await networkProvider.call(
          path: ApiConfig.fetchUserCommunities(userName: userName,skip: skip,limit: limit),
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final List<CommunityModel> communitiesResponse = List<CommunityModel>.from(response.data.map((x) => CommunityModel.fromJson(x)));
        return Right(communitiesResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }   on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<CommunityModel>>> searchCommunities({required String keyword}) async {
    try {

      final path = ApiConfig.searchCommunities(keyword: keyword);
      final response = await networkProvider.call(path: path, method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final List<CommunityModel> communitiesResponse = List<CommunityModel>.from(response.data.map((x) => CommunityModel.fromJson(x)));
        return Right(communitiesResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }

    }  catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<CommunityThreadTagsModel>>> fetchCommunityTags({required String? slug})async {
    try {
      final path = ApiConfig.fetchCommunityTags(slug: slug);
      var response = await networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final List<CommunityThreadTagsModel> tagsResponse = List<CommunityThreadTagsModel>.from(response.data.map((x) => CommunityThreadTagsModel.fromJson(x)));
        return Right(tagsResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }   on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }


  Future<Either<ApiError, bool>> reportCommunity({required CommunityReportModel reportRequest}) async {
    try {
      var response = await networkProvider.call(
          path: ApiConfig.complaints,
          method: RequestMethod.post,
          body: reportRequest.toJson());
      if (response!.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(ApiError(errorDescription: response.data['error'] ?? "Unable to submit report"));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, CommunityModel>> fetchCommunityDetails({required String communityName}) async {
    try {
      final path = ApiConfig.fetchCommunityDetails(slug: communityName);
      var response =
      await networkProvider.call(path: path, method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final communityDetails =
        CommunityModel.fromJson(response.data);
        return Right(communityDetails);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<String>>> searchCommunityTag({required String keyword})async {
    try {
      final path = ApiConfig.searchCommunityTag(keyword: keyword);
      var response = await networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final List<String> searchResponse = List<String>.from(response.data.map((x) => x));
        return Right(searchResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }   on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }


  Future<Either<ApiError, List<CommunityThreadTagsModel>>> updateFeedsTag({required List<CommunityThreadTagsModel> communityTags,required int communityId}) async{
    try {
      final path = ApiConfig.updateFeedsTag(communityId: communityId);
      var response = await networkProvider.call(
          path: path,
          body: communityTags.map((e) => e.toJson()).toList(),
          method: RequestMethod.put);

      if (response!.statusCode == 200) {
        final List<CommunityThreadTagsModel> tagsResponse = List<CommunityThreadTagsModel>.from(response.data.map((x) => CommunityThreadTagsModel.fromJson(x)));
        return Right(tagsResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }   on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, void>> featureAndUnFeature({required String action,required int communityId}) async{

    try {
      final path = ApiConfig.featureAndUnFeature(action: action, communityId: communityId);
      var response = await networkProvider.call(
          path: path,
          method: RequestMethod.post);

      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }   on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, void>> updateInterests({required String slug, required List<String> interests}) async{

    try {
      final path = ApiConfig.updateCommunityInterest(slug: slug);
      var response = await networkProvider.call(
          path: path,
          body: {'interests': interests},
          method: RequestMethod.post);

      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }   on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<CommunityCategoryModel>>> fetchCommunityCategories() async {
    try {
      final path = ApiConfig.fetchCommunityCategory ;
      var response = await networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final List<CommunityCategoryModel> categoriesResponse = List<CommunityCategoryModel>.from(response.data.map((x) => CommunityCategoryModel.fromJson(x)));
        return Right(categoriesResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }   on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<CommunityAdminRoleModel>>> fetchCommunityRoles({required int communityId})async {
    try {
      final path = ApiConfig.fetchCommunityRoles(communityId: communityId);
      var response = await networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final List<CommunityAdminRoleModel> rolesResponse = List<CommunityAdminRoleModel>.from(response.data.map((x) => CommunityAdminRoleModel.fromJson(x)));
        return Right(rolesResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }   on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }


  Future<Either<ApiError, List<CommunityRoleModel>>> updateCommunityRoles({required List<int> permissionIds,required int roleId,required int communityId}) async {

    try {
      final path = ApiConfig.updateCommunityRoles(communityId: communityId,roleID: roleId);
      var response = await networkProvider.call(
          path: path,
          body: {
            "permissionsIds": permissionIds
          },
          method: RequestMethod.post);

      if (response!.statusCode == 200) {
        final List<CommunityRoleModel> rolesResponse = List<CommunityRoleModel>.from(response.data.map((x) => CommunityRoleModel.fromJson(x)));
        return Right(rolesResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }   on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, CommunityAdminRoleModel>> addCommunityRole({required String roleName,required int communityId}) async {
    try {
      final path = ApiConfig.fetchCommunityRoles(communityId: communityId,);
      var response = await networkProvider.call(
          path: path,
          body: {
            "name": roleName
          },
          method: RequestMethod.post);

      if (response!.statusCode == 200) {
        final CommunityAdminRoleModel rolesResponse =  CommunityAdminRoleModel.fromJson(response.data);
        return Right(rolesResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }   on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, void>> updateRoleName({required String? name,required int? roleId,required int? communityId}) async{
    try {
      final path = ApiConfig.updateCommunityRoleName(communityId: communityId, roleID: roleId,);
      var response = await networkProvider.call(
          path: path,
          body: {'name': name},
          method: RequestMethod.put);

      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }   on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, void>> sendCommunityInvite({required int? userId, required int? communityId}) async {
    try {
      final path = ApiConfig.sendCommunityInvite(communityId: communityId,);
      var response = await networkProvider.call(
          path: path,
          body: {'userIds': [userId]},
          method: RequestMethod.post);

      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }   on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<UserModel>>> searchPeople({required String text}) async {
    try {
      final path = ApiConfig.search(limit: 5, skip: 0, type: 'users', text: text);

      var response = await networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final userResponse = List<UserModel>.from(response.data.map((x) => UserModel.fromJson(x)));
        return Right(userResponse);


      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, CommunityModel>> updateCommunityDetails({required UpdateCommunitiesModel? updateCommunitiesRequest,required int communityId})async {
    try {
      final path = ApiConfig.updateCommunityDetails(communityId: communityId,);
      var response = await networkProvider.call(
          path: path,
          body: updateCommunitiesRequest?.toJson(),
          method: RequestMethod.put);

      if (response!.statusCode == 200) {
        final CommunityModel communitiesResponse = CommunityModel.fromJson(response.data);
        return Right(communitiesResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }   on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<dynamic> assignMemberRole({required int? userId, required int? roleId,required int? communityId}) async {
    late String result;
    try {
      final path = ApiConfig.assignCommunityRoles(communityId: communityId!);
      var response = await networkProvider.call(path: path, method: RequestMethod.put,body: {
        "userId": userId,
        "roleId": roleId
      });
      if (response!.statusCode == 200) {
        result = response.data;
      } else {
        result = response.data['error'];
      }
    } on DioError catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<Either<ApiError, CommunityModel>> updateCommunityWelcomeScreen({required CommunityUpdateWelcomeScreen? updateWelcomeScreen,}) async{
    try {
      final path = ApiConfig.updateCommunityDetails(communityId: updateWelcomeScreen!.id!,);
      var response = await networkProvider.call(
          path: path,
          body: updateWelcomeScreen.toJson(),
          method: RequestMethod.put);

      if (response!.statusCode == 200) {
        final CommunityModel communitiesResponse = CommunityModel.fromJson(response.data);
        return Right(communitiesResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }   on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, void>> deleteCommunityRole({ required int? roleId, required int? communityId})async {
    try {
      final path = ApiConfig.updateCommunityRoleName(communityId: communityId, roleID: roleId,);
      var response = await networkProvider.call(
          path: path,
          method: RequestMethod.delete);

      if (response!.statusCode == 200) {

        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }   on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<String>>> updateCommunityTag({required List<String> tags, required int? communityId})async{
    try {
      final path = ApiConfig.updateCommunityTag(communityId: communityId!,);
      var response = await networkProvider.call(
          path: path,
          body: {'tags': tags},
          method: RequestMethod.put);

      if (response!.statusCode == 200) {
        final List<String> searchResponse = List<String>.from(response.data.map((x) => x));
        return Right(searchResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }   on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, String>> deleteCommunity({required int? communityId}) async {
    try {
      final path = ApiConfig.updateCommunityDetails(communityId: communityId!,);
      var response = await networkProvider.call(
          path: path,
          method: RequestMethod.delete);

      if (response!.statusCode == 200) {
        final String result = response.data;
        return Right(result);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }   on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<String>>> fetchInterests()async {
    try {
      late List<String> result;

      final response = await networkProvider.call(path: ApiConfig.interests, method:  RequestMethod.get);
      if (response!.statusCode == 200) {
        result = List<String>.from(response.data.map((x) => x));
        return Right(result);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }




}