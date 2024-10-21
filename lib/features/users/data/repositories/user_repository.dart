import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/companies/data/models/company_model.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_enums.dart';
import 'package:showwcase_v3/features/users/data/models/user_certification_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_experience_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_repository_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_social_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_stack_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_tab_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_tech_stack_model.dart';


class UserRepository {

  final NetworkProvider _networkProvider;
  UserRepository(this._networkProvider);

  Future<Either<ApiError, UserModel>> fetchUserByUsername({required String userName}) async{

    try{
      var response = await _networkProvider.call(path: ApiConfig.fetchProfile(userName: userName), method: RequestMethod.get);
      if (response!.statusCode == 200){

        final userModel = UserModel.fromJson(response.data);
        return Right(userModel);

      }else{
         return Left(ApiError(errorDescription: response.data['error']));
      }
    }on DioError catch(e){
      return Left(ApiError(errorDescription: e.toString()));
    }

  }


  Future<Either<ApiError, List<UserModel>>> searchUser({required String keyword, String type = 'users'}) async {

    try {

      final path = ApiConfig.searchUser(keyword: keyword, type: type);
      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {

        final userList = List<UserModel>.from(response.data.map((x) => UserModel.fromJson(x)));
        return Right(userList);

      } else {

        return Left(ApiError(errorDescription: response.data['error']));

      }
    } on DioException catch (e) {

      return Left(ApiError(errorDescription: e.toString()));

    }

  }


  Future<Either<ApiError, void>>? followAndUnfollow({required int userId, required FollowerAction action}) async {

    try {

      var response = await _networkProvider.call(
          path: ApiConfig.followAndUnfollow(actionType: action.name),
          method: RequestMethod.post,
          body: {"userId": userId});

      if (response!.statusCode == 200 && response.data['success'] == true){
        return const Right(null);
      }else{
        return Left(ApiError(errorDescription: response.data['error']));
      }

    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }


  Future<Either<ApiError, void>> blockAndUnblockUser({required String userName, required BlockAction actionType})async {
    try {

      var response = await _networkProvider.call(path: ApiConfig.blockAndUnblock(userName: userName, actionType: actionType.name), method:  RequestMethod.post);

      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }


  /// Tabs

  Future<Either<ApiError, List<UserTabModel>>> fetchUserTabs({required String userName}) async {

    try{

      final path = ApiConfig.fetchUserTabs(userName: userName);
      var response = await _networkProvider.call(path: path, method: RequestMethod.get);

      if (response!.statusCode == 200){
        final tabs = List<UserTabModel>.from(response.data["tabs"].map((x) => UserTabModel.fromJson(x)));
        return Right(tabs);
      }else{
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }on DioError catch(e){
      return Left(ApiError(errorDescription: e.toString()));
    }

  }


  /// User section ------


  // Repositories
  Future<Either<ApiError, List<UserRepositoryModel>>> fetchGithubRepositories({required String userName}) async {

    try {
      var response = await _networkProvider.call(
          path: ApiConfig.fetchRepositories(userName: userName),
          method: RequestMethod.get);
      if (response!.statusCode == 200) {

        final userRepositoryResponse = List<UserRepositoryModel>.from(response.data.map((x) => UserRepositoryModel.fromJson(x)));
        return Right(userRepositoryResponse);

      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  // Under Professionalism -----------
  // worked-withs --------
  Future<Either<ApiError, List<UserModel>>> fetchWorkedWiths({required int userId}) async {

    try {
      var response = await _networkProvider.call(
          path: ApiConfig.fetchWorkedWiths(userId: userId),
          method: RequestMethod.get);
      if (response!.statusCode == 200) {

        final workedWiths = List<UserModel>.from(response.data.map((x) => UserModel.fromJson(x)));
        return Right(workedWiths);

      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  // profile tags

  // the method below will be used when creating a new tag

  // Future<Either<ApiError, List<UserTagModel>>> saveTags({required List<Map<String, dynamic>> tags}) async{
  //   try {
  //     var response = await _networkProvider.call(path: ApiConfig.profileTags, method: RequestMethod.post,body: {'tags':tags});
  //     if (response!.statusCode == 200) {
  //       final tags = List<UserTagModel>.from(response.data.map((x) => UserTagModel.fromJson(x)));
  //       return Right(tags);
  //     } else {
  //       return Left(ApiError(errorDescription: response.data['error']));
  //     }
  //   } on DioError catch (e) {
  //     return Left(ApiError(errorDescription: e.toString()));
  //   }
  // }

  Future<Either<ApiError, List<UserStackModel>>> searchTechStacks({required String query}) async {
    try {
      var response = await _networkProvider.call(
        path: ApiConfig.searchTechStacks(query: query),
        method: RequestMethod.get,
      );
      if (response!.statusCode == 200) {
        final userStacksResponse = List<UserStackModel>.from(response.data.map((x) => UserStackModel.fromJson(x))).toList();
        return Right(userStacksResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, void>> updateTechStack({required UserTechStackModel userTechStackModel, bool deleteStacks = false}) async {
    try {

      final String url = deleteStacks ? '${ApiConfig.stacks}/${userTechStackModel.stackId}' : ApiConfig.stacks ;
      final body = {
        "experience": userTechStackModel.experience,
        "isFeatured": userTechStackModel.isFeatured,
        "stackId": userTechStackModel.stackId,
      };

      final response = await _networkProvider.call(
          path: url,
          method: deleteStacks ? RequestMethod.delete : RequestMethod.post,
          body: body);
      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError,List<UserTechStackModel>>> fetchTechStacks({required String userName}) async {

    try {
      var response = await _networkProvider.call(
          path: ApiConfig.fetchStacks(userName: userName),
          method: RequestMethod.get);
      if (response!.statusCode == 200) {
        final userStacksResponse = List<UserTechStackModel>.from(response.data.map((x) => UserTechStackModel.fromJson(x)));
        return Right(userStacksResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<CommunityModel>>> fetchFeaturedCommunities(
      {required String userName}) async {

    try {
      var response = await _networkProvider.call(
          path: ApiConfig.fetchFeaturedCommunities(userName: userName),
          method: RequestMethod.get);
      if (response!.statusCode == 200) {
        final featuredCommunities = List<CommunityModel>.from(response.data.map((x) => CommunityModel.fromJson(x)));
        return Right(featuredCommunities);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }  catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, List<ShowModel>>> fetchFeaturedProjects(
      {required String userName}) async {

    try {
      var response = await _networkProvider.call(
          path: ApiConfig.fetchUserProjects(userName: userName),
          method: RequestMethod.get);
      if (response!.statusCode == 200) {

        final userProjectResponse = List<ShowModel>.from(
            response.data.map((x) => ShowModel.fromJson(x))
        );
        return Right(userProjectResponse);

      } else {

        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));

    }

  }

/// End of user section -----

  Future<Either<ApiError, UserExperienceModel>> addExperience({
    String? title,
    bool? current,
    DateTime? startDate,
    DateTime? endDate,
    CompanyModel? company,
    String? description,
    List<UserStackModel>? stacks,
  }) async {
    try {

      String url = ApiConfig.profileExperiences ;
      final modifiedStacks = (stacks ?? []).map((e) => e.id!).toList();

      final response = await _networkProvider.call(path: url, method: RequestMethod.post, body: {
        'title': title,
        'companyId': company?.id,
        'companyName': company?.name,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'current': current,
        'description': description,
        'stacks': modifiedStacks,
      });
      if (response!.statusCode == 200) {
        var experience = UserExperienceModel.fromJson(response.data);
        if(experience.companyName == null){
           experience = experience.copyWith(
             companyName: company?.name
           );
        }
        return Right(experience);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, UserExperienceModel>> updateExperience(UserExperienceModel userExperienceModel, {
    String? title,
    bool? current,
    DateTime? startDate,
    DateTime? endDate,
    CompanyModel? company,
    String? description,
  }) async {
    try {

      String url = '${ApiConfig.profileExperiences}/${userExperienceModel.id}';
      // final modifiedStacks = (stacks ?? []).map((e) => e.id!).toList();

      final response = await _networkProvider.call(path: url,
          method: RequestMethod.put, body: {
            'id': userExperienceModel.id,
            'title': title,
            'companyId': company?.id,
            'companyName': company?.name,
            'startDate': startDate?.toIso8601String(),
            'endDate': endDate?.toIso8601String(),
            'current': current,
            'description': description,
            // 'stacks': modifiedStacks,
          });

      if (response!.statusCode == 200) {
        var experience = UserExperienceModel.fromJson(response.data);
        if(experience.companyName == null){
           experience = experience.copyWith(
             companyName: company?.name
           );
        }
        return Right(experience);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, UserTechStackModel>> addUserExperienceStack({
    required UserExperienceModel userExperienceModel,
    required UserStackModel? stackModel,
  }) async {

    try {

      String url = ApiConfig.profileExperiencesStacks(stackId: userExperienceModel.id);
      // final modifiedStacks = (stacks ?? []).map((e) => e.id!).toList();

      final response = await _networkProvider.call(path: url,
          method: RequestMethod.post, body: {
            'experienceId': userExperienceModel.id,
            'stackId': stackModel?.id,
          });

      if (response!.statusCode == 200) {
        final stack = UserTechStackModel.fromJson(response.data);
        return Right(stack);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, void>> deleteUserExperienceStack({
    required UserExperienceModel userExperienceModel,
    required UserStackModel? stackModel,
  }) async {

    try {

      String url = ApiConfig.profileExperiencesStacks(stackId: userExperienceModel.id);
      // final modifiedStacks = (stacks ?? []).map((e) => e.id!).toList();

      final response = await _networkProvider.call(path: url,
          method: RequestMethod.delete, body: {
            'experienceId': userExperienceModel.id,
            'stackId': stackModel?.id,
          });

      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, void>> deleteExperience(UserExperienceModel userExperienceModel) async {
    try {

      String url = '${ApiConfig.profileExperiences}/${userExperienceModel.id}';

      final response = await _networkProvider.call(path: url,
          method: RequestMethod.delete);

      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<UserExperienceModel>>> fetchExperiences(UserModel userModel) async {
    try {

      String url = ApiConfig.fetchExperiences(userName: userModel.username ?? '');

      final response = await _networkProvider.call(path: url,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final list = List<UserExperienceModel>.from(response.data.map((x) => UserExperienceModel.fromJson(x)));
        return Right(list);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }



  Future<Either<ApiError, UserCertificationModel>> addCertification({
    String? attachmentUrl,
    String? title,
    CompanyModel? company,
    DateTime? startDate,
    DateTime? endDate,
    bool? current,
    String? certificationId,
    String? url
  }) async {
    try {

      String url = ApiConfig.profileCertifications ;

      final response = await _networkProvider.call(path: url, method: RequestMethod.post, body: {
        'attachmentUrl': attachmentUrl,
        'title': title,
        'organizationId': company?.id,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'current': current,
        'credentialId': certificationId,
        'url': url,
      });
      if (response!.statusCode == 200) {
        final certification = UserCertificationModel.fromJson(response.data);
        return Right(certification);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<UserCertificationModel>>> fetchCertifications(UserModel userModel) async {
    try {

      String url = ApiConfig.fetchCertifications(userName: userModel.username ?? '');

      final response = await _networkProvider.call(path: url,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final list = List<UserCertificationModel>.from(response.data.map((x) => UserCertificationModel.fromJson(x)));
        return Right(list);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, UserCertificationModel>> updateCertification(
      UserCertificationModel userCertificationModel, {
    String? attachmentUrl,
    String? title,
    CompanyModel? company,
    DateTime? startDate,
    DateTime? endDate,
    bool? current,
    String? certificationId,
    String? url
  }) async {
    try {

      String url = '${ApiConfig.profileCertifications}/${userCertificationModel.id}';

      final response = await _networkProvider.call(path: url,
          method: RequestMethod.put, body: {
            'id': userCertificationModel.id,
            'title': title,
            'organizationId': company?.id,
            'organizationName': company?.name,
            'startDate': startDate?.toIso8601String(),
            'endDate': endDate?.toIso8601String(),
            'current': current,
            'credentialId': certificationId,
            'url': certificationId,
            'attachmentUrl': attachmentUrl,
          });

      if (response!.statusCode == 200) {
        var certification = UserCertificationModel.fromJson(response.data);
        if(certification.organizationName == null){
          certification = userCertificationModel.copyWith(
              organizationName: company?.name
          );
        }
        return Right(certification);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, void>> deleteCertification(UserCertificationModel userCertificationModel) async {
    try {

      String url = '${ApiConfig.profileCertifications}/${userCertificationModel.id}';

      final response = await _networkProvider.call(path: url,
          method: RequestMethod.delete);

      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<UserModel>>> fetchUserList({required String path}) async {

    try {
      var response = await _networkProvider.call(path: path,
          method: RequestMethod.get);
      if (response!.statusCode == 200) {
        final users = List<UserModel>.from(response.data.map((x) => UserModel.fromJson(x))).where((element) => element.username != null).toList();
        return Right(users);
      }else{
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }  catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }


  Future<Either<ApiError, UserSocialModel>> fetchUserSocials({required String userName}) async {

    try {

      var response = await _networkProvider.call(
          path: ApiConfig.fetchSocials(userName: userName),
          method: RequestMethod.get);

      if (response!.statusCode == 200) {

        if(response.data == null){
          return const Right(UserSocialModel(links: []));
        }

        if(response.data is List){
          if((response.data as List).isEmpty) {
            return const Right(UserSocialModel(
                links: [],));
          }
        }

        if(response.data is Map){
          if((response.data as Map).isEmpty) {
            return const Right(UserSocialModel(
                links: []
            ));
          }
        }

        final userSocialResponse = UserSocialModel.fromJson(response.data);

        return Right(userSocialResponse);

      } else {

        return Left(ApiError(errorDescription: response.data['error'] ?? '' ));

      }
    }  catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  /// CustomTabs
  Future<Either<ApiError, List<ShowModel>>> fetchCustomFeaturedProjects(UserModel userModel, List<int> projectIds) async  {

    try {

      String path = ApiConfig.fetchCustomFeaturedProjects(userName: userModel.username!);

      final queryParams = <String, dynamic>{};
      queryParams['projectIds'] = projectIds;

      var response = await _networkProvider.call(
          path: path, method: RequestMethod.get,
          queryParams: queryParams
      );

      if (response!.statusCode == 200) {
        final notificationsResponse = List<ShowModel>.from(response.data.map((x) => ShowModel.fromJson(x)));

        return Right(notificationsResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }  catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<SeriesModel>>> fetchCustomFeaturedSeries(UserModel userModel, List<int> seriesIds) async  {

    try {

      String path = ApiConfig.fetchCustomFeaturedSeries(userName: userModel.username!);

      final queryParams = <String, dynamic>{};
      queryParams['seriesIds'] = seriesIds;

      var response = await _networkProvider.call(
          path: path, method: RequestMethod.get,
          queryParams: queryParams
      );

      if (response!.statusCode == 200) {
        final seriesResponse = List<SeriesModel>.from(response.data.map((x) => SeriesModel.fromJson(x)));
        return Right(seriesResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }  catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

}