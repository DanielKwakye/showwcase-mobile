import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/analytics/data/service/analytics_service.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/repositories/auth_broadcast_repository.dart';
import 'package:showwcase_v3/features/circles/data/bloc/circles_enums.dart';
import 'package:showwcase_v3/features/circles/data/repositories/circles_broadcast_repository.dart';
import 'package:showwcase_v3/features/companies/data/models/company_model.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_enums.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_certification_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_experience_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_profile_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_stack_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_tech_stack_model.dart';
import 'package:showwcase_v3/features/users/data/repositories/user_broadcast_repository.dart';
import 'package:showwcase_v3/features/users/data/repositories/user_repository.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final UserRepository userRepository;
  final AuthBroadcastRepository authBroadcastRepository;
  final UserBroadcastRepository userBroadcastRepository;
  final CirclesBroadcastRepository circlesBroadcastRepository;

  StreamSubscription<UserModel>? authBroadcastRepositoryStreamListener;
  late String _localPath;
  StreamSubscription<CirclesBroadcastAction>?
      circlesBroadcastRepositoryStreamListener;

  UserProfileCubit({
    required this.userRepository,
    required this.authBroadcastRepository,
    required this.userBroadcastRepository,
    required this.circlesBroadcastRepository,
  }) : super(const UserProfileState()) {
    listenToAuthUserChanges();
    listenToCircleChanges();
  }

  void listenToAuthUserChanges() async {
    // listen to authCubit changes
    await authBroadcastRepositoryStreamListener?.cancel();

    authBroadcastRepository.authBroadcastStream.listen((event) {
      if (event.action == AuthBroadcastAction.update) {
        setUserInfo(userInfo: event.loggedInUser!, emitToSubscribers: false);
      }
      if (event.action == AuthBroadcastAction.logout) {
        emit(state.copyWith(status: UserStatus.resetStateInProgress));
        emit(const UserProfileState(status: UserStatus.initial));
      }
    });
  }

  void listenToCircleChanges() async {
    // listen to authCubit changes
    await circlesBroadcastRepositoryStreamListener?.cancel();

    circlesBroadcastRepository.circlesBroadcastStream.listen((event) {
      if (event.action == CirclesBroadcastAction.circleRequestAccepted) {
        final acceptedUser = event.data as UserModel;
        setUserInfo(userInfo: acceptedUser, emitToSubscribers: false);
      }
      if (event.action == CirclesBroadcastAction.circleRequestRejected) {
        final rejectedUser = event.data as UserModel;
        setUserInfo(userInfo: rejectedUser, emitToSubscribers: false);
      }
    });
  }

  // Close stream subscriptions when cubit is disposed to avoid any memory leaks
  @override
  Future<void> close() async {
    await authBroadcastRepositoryStreamListener?.cancel();
    return super.close();
  }

  /// This method here adds the user to the users of interest
  UserProfileModel? setUserInfo(
      {required UserModel userInfo, bool emitToSubscribers = true}) {
    if (userInfo.username == null) {
      return null;
    }

    emit(state.copyWith(
      status: UserStatus.setUserInfoInProgress,
    ));
    final profiles = [...state.userProfiles];
    final int index =
        profiles.indexWhere((element) => element.username == userInfo.username);
    if (index < 0) {
      profiles.add(
          UserProfileModel(username: userInfo.username, userInfo: userInfo));
    } else {
      // user has already been added
      final userProfile = profiles[index];
      final updatedUser = userProfile.copyWith(userInfo: userInfo);
      profiles[index] = updatedUser;
    }

    //! if this updatedUser is the currentUser, then update the currentUser constant as well
    // to maintain consistency
    final currentUser = AppStorage.currentUserSession;
    if (userInfo.username == currentUser?.username) {
      AppStorage.currentUserSession = userInfo;
    }

    if (emitToSubscribers) {
      userBroadcastRepository.updateUser(user: userInfo);
    }

    emit(state.copyWith(
        status: UserStatus.setUserInfoCompleted, userProfiles: profiles));

    // return the userProfile for methods that needs it
    final userProfile = state.userProfiles
        .firstWhere((element) => element.username == userInfo.username);
    return userProfile;
  }

  /// This method returns a [UserProfileModel] from the server by the given username
  /// assigned to the [state.selectedUserProfile]  state
  Future<void> fetchUserProfileByUsername({required String username}) async {
    try {
      emit(state.copyWith(
        status: UserStatus.fetchUserByUsernameInProgress,
      ));
      final existingUser = state.userProfiles
          .firstWhereOrNull((element) => element.username == username);
      // notify UI that there's already an existing user of interest in Memory (cache) before fetching from server
      if (existingUser != null) {
        emit(state.copyWith(status: UserStatus.fetchUserByUsernameSuccessful));
      }

      final either =
          await userRepository.fetchUserByUsername(userName: username);
      if (either.isLeft()) {
        final l = either.asLeft();
        emit(state.copyWith(
            message: l.errorDescription,
            status: UserStatus.fetchUserByUsernameFailed));
        return;
      }

      // successful

      final r = either.asRight();
      // and then update the local version with data from server ----
      setUserInfo(userInfo: r);

      // just to make sure the update from the server is emitted to the UI
      emit(state.copyWith(
        status: UserStatus.fetchUserByUsernameInProgress,
      ));
      emit(state.copyWith(status: UserStatus.fetchUserByUsernameSuccessful));
    } catch (e) {
      emit(state.copyWith(
          message: e.toString(), status: UserStatus.fetchUserByUsernameFailed));
    }
  }

  // This is stateless, (Does not keep the user in state) and just returns the user to the caller
  Future<UserModel?> getUserInfoUsername({required String username}) async {
    try {
      final either =
          await userRepository.fetchUserByUsername(userName: username);
      if (either.isLeft()) {
        final l = either.asLeft();
        return null;
      }

      // successful

      final r = either.asRight();
      return r;
    } catch (e) {
      return null;
    }
  }

  /// This method [followAndUnfollowUser] uses optimistic update mechanism
  /// The [UserStatus.followAndUnfollowUserSuccessful] is emitted immediately to the UI before data is sent to server
  ///
  /// The user passed to this parameter is added to [state.isFollowed] list
  void followAndUnfollowUser(
      {required UserModel userInfo, required FollowerAction action}) async {
    final currentUser = AppStorage.currentUserSession!;

    update() {
      setUserInfo(
          userInfo: userInfo.copyWith(
              isFollowed: action == FollowerAction.follow ? 'basic' : false));
      // increase or decrease the totalFollowing of the currentUser
      setUserInfo(
          userInfo: currentUser.copyWith(
              totalFollowing: action == FollowerAction.follow
                  ? (currentUser.totalFollowing ?? 0) + 1
                  : (currentUser.totalFollowing ?? 1) - 1));
      emit(state.copyWith(
        status: UserStatus.followAndUnfollowUserSuccessful,
      ));
    }

    reverse(String reason) {
      // reverse to as it was if it fails
      setUserInfo(
          userInfo: userInfo.copyWith(
              isFollowed: userInfo.isFollowed,
              totalFollowing: userInfo.totalFollowing));
      // reverse the total following of the currentUser;
      setUserInfo(
          userInfo:
              currentUser.copyWith(totalFollowing: currentUser.totalFollowing));
      emit(state.copyWith(
        message: reason,
        status: UserStatus.followAndUnfollowUserFailed,
      ));
    }

    try {
      // userId is required
      emit(state.copyWith(
        status: UserStatus.followAndUnfollowUserInProgress,
      ));

      // user id cannot be null .......
      if (userInfo.id == null) {
        emit(state.copyWith(
          message: "Invalid user",
          status: UserStatus.followAndUnfollowUserFailed,
        ));
        return;
      }

      //  STEP 1. is to call update so that the UI gets updated immediately
      update();

      final either = await userRepository.followAndUnfollow(
          userId: userInfo.id!, action: action);

      either?.fold((l) => reverse(l.errorDescription), (r) {
        // state has already been updated with optimistic update
        AnalyticsService.instance.sendEventProfileFollowAndUnfollow(
            userModel: userInfo, action: action);
      });
    } catch (e) {
      reverse(e.toString());
    }
  }

  /// This method fetches the user tabs and assigns to tabs inside  [state.userProfiles] depending on
  /// the userType parameter
  Future<void> fetchUserTabs({required UserModel userModel}) async {
    try {
      // just to make sure
      final user = setUserInfo(userInfo: userModel);

      emit(state.copyWith(status: UserStatus.fetchUserTabsInProgress));

      // if there are user tabs already in state, update UI with it
      // then fetch the latest update from the server
      if ((user?.tabs ?? []).isNotEmpty) {
        emit(state.copyWith(status: UserStatus.fetchUserTabsSuccessful));
      }

      final either =
          await userRepository.fetchUserTabs(userName: userModel.username!);

      either.fold(
          (l) => emit(state.copyWith(
              status: UserStatus.fetchUserTabsFailed,
              message: l.toString())), (r) {
        // set profile tabs ----

        final profiles = [...state.userProfiles];
        final int profileIndex = profiles
            .indexWhere((element) => element.username == userModel.username);

        final profileFound = profiles[profileIndex].copyWith(tabs: r);
        profiles[profileIndex] = profileFound;

        emit(state.copyWith(status: UserStatus.fetchUserTabsInProgress));
        emit(state.copyWith(
            status: UserStatus.fetchUserTabsSuccessful,
            userProfiles: profiles));
      });
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.fetchUserTabsFailed, message: e.toString()));
    }
  }

  /// This method [blockAndUnblockUser] uses optimistic update mechanism
  ///
  /// Added block and unblock user
  void blockAndUnblockUser(
      {required UserModel userInfo, required BlockAction action}) async {
    update() {
      setUserInfo(
          userInfo: userInfo.copyWith(
              isBlocked: action == BlockAction.block ? true : false));

      emit(state.copyWith(
        status: UserStatus.blockAndUnblockUserSuccessful,
      ));
    }

    reverse(String reason) {
      setUserInfo(userInfo: userInfo.copyWith(isBlocked: userInfo.isBlocked));

      emit(state.copyWith(
        message: reason,
        status: UserStatus.blockAndUnblockUserFailed,
      ));
    }

    try {
      emit(state.copyWith(status: UserStatus.blockAndUnblockUserInProgress));

      update();

      final either = await userRepository.blockAndUnblockUser(
          userName: userInfo.username ?? '', actionType: action);

      either.fold((l) => reverse(l.errorDescription), (r) {
        // success has already been called
      });
    } catch (e) {
      reverse(e.toString());
    }
  }

  /// Modules under the user_section tab

  /// About module
  void fetchAbout(
      {required String username, required UserType usertype}) async {
    try {
      emit(state.copyWith(status: UserStatus.fetchAboutInProgress));

      // automatically returns cache first if we use [BlocSelector]

      final either =
          await userRepository.fetchUserByUsername(userName: username);
      either.fold((l) {
        emit(state.copyWith(
            status: UserStatus.fetchAboutFailed, message: l.errorDescription));
      }, (r) {
        // update the userInfo with the about
        setUserInfo(userInfo: r);
        emit(state.copyWith(
          status: UserStatus.fetchAboutSuccessful,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.fetchAboutFailed, message: e.toString()));
    }
  }

  /// Github repositories
  void fetchGithubRepositories({required UserModel userModel}) async {
    try {
      emit(state.copyWith(
        status: UserStatus.fetchGithubRepositoriesInProgress,
      ));
      final either = await userRepository.fetchGithubRepositories(
          userName: userModel.username!);
      either.fold((l) {
        emit(state.copyWith(
            status: UserStatus.fetchGithubRepositoriesFailed,
            message: l.errorDescription));
      }, (r) {
        final userProfiles = [...state.userProfiles];
        final userProfileIndex = userProfiles
            .indexWhere((element) => element.username == userModel.username);
        final userProfile = userProfiles[userProfileIndex];

        // the server is the main source of truth, so just replace every tech stack with data from server
        userProfiles[userProfileIndex] =
            userProfile.copyWith(featuredRepositories: r);

        emit(state.copyWith(
            status: UserStatus.fetchGithubRepositoriesSuccessful,
            userProfiles: userProfiles));
      });
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.fetchGithubRepositoriesFailed,
          message: e.toString()));
    }
  }

  void fetchFeaturedCommunities({required UserModel userModel}) async {
    if (userModel.username == null) {
      return;
    }

    try {
      emit(state.copyWith(
          status: UserStatus.fetchFeaturedCommunitiesInProgress));

      final either = await userRepository.fetchFeaturedCommunities(
          userName: userModel.username!);
      either.fold((l) {
        emit(state.copyWith(
            status: UserStatus.fetchFeaturedCommunitiesFailed,
            message: l.errorDescription));
      }, (r) {
        final userProfiles = [...state.userProfiles];
        final userProfileIndex = userProfiles
            .indexWhere((element) => element.username == userModel.username);
        final userProfile = userProfiles[userProfileIndex];

        // the server is the main source of truth, so just replace every tech stack with data from server
        userProfiles[userProfileIndex] =
            userProfile.copyWith(featuredCommunities: r);

        emit(state.copyWith(
            status: UserStatus.fetchFeaturedCommunitiesSuccessful,
            userProfiles: userProfiles));
      });
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.fetchFeaturedCommunitiesFailed,
          message: e.toString()));
    }
  }

  void fetchFeaturedProjects({required UserModel userModel}) async {
    if (userModel.username == null) {
      return;
    }

    try {
      emit(state.copyWith(status: UserStatus.fetchFeaturedProjectsInProgress));

      final either = await userRepository.fetchFeaturedProjects(
          userName: userModel.username!);
      either.fold((l) {
        emit(state.copyWith(
            status: UserStatus.fetchFeaturedProjectsFailed,
            message: l.errorDescription));
      }, (r) {
        final userProfiles = [...state.userProfiles];
        final userProfileIndex = userProfiles
            .indexWhere((element) => element.username == userModel.username);
        final userProfile = userProfiles[userProfileIndex];

        // the server is the main source of truth, so just replace every tech stack with data from server
        userProfiles[userProfileIndex] =
            userProfile.copyWith(featuredProjects: r);

        emit(state.copyWith(
            status: UserStatus.fetchFeaturedProjectsSuccessful,
            userProfiles: userProfiles));
      });
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.fetchFeaturedProjectsFailed,
          message: e.toString()));
    }
  }

  //Professionalism -> profile tags (Expertise)
  //  fetching and saving of profile tags is done with the updateAuthUserDetails method

  Future<List<UserStackModel>?> searchUserTechStacks(
      {required String keyword}) async {
    try {
      emit(state.copyWith(status: UserStatus.searchUserTechStacksInProgress));

      final either = await userRepository.searchTechStacks(query: keyword);

      if (either.isLeft()) {
        final l = either.asLeft();
        emit(state.copyWith(
            status: UserStatus.searchUserTechStacksFailed,
            message: l.errorDescription));
        return null;
      }

      final r = either.asRight();
      emit(state.copyWith(status: UserStatus.searchUserTechStacksSuccessful));
      return r;
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.searchUserTechStacksFailed,
          message: e.toString()));
      return null;
    }
  }

  Map<String, List<UserTechStackModel?>> getCategorisedTechStacks(
      List<UserTechStackModel?> techStacks) {
    final filteredAllEmptySubCategories = techStacks.where((element) =>
        element?.stack?.subCategory != null &&
        element?.stack?.subCategory != '');

    // Separate the UserTechStackModel objects into two groups: Featured and Non-Featured
    final featuredTechStacks = filteredAllEmptySubCategories
        .where((element) => element?.isFeatured == true);
    final nonFeaturedTechStacks = filteredAllEmptySubCategories
        .where((element) => element?.isFeatured != true);

    // Group the non-featured UserTechStackModel objects by their subCategory as before
    final nonFeaturedGrouped = groupBy(nonFeaturedTechStacks,
        (UserTechStackModel? element) => element?.stack?.subCategory ?? "");

    // Create a new category "Featured" and put the featured UserTechStackModel objects under it

    final Map<String, List<UserTechStackModel?>> allGrouped = {};
    if (featuredTechStacks.isNotEmpty) {
      allGrouped.addAll({"Featured": featuredTechStacks.toList()});
    }

    allGrouped.addAll(nonFeaturedGrouped);

    return allGrouped;
  }

  // Map<String, List<UserTechStackModel?>> getCategorisedTechStacks(List<UserTechStackModel?> techStacks, ) {
  //   final filteredAllEmptySubCategories = techStacks.where((element) => element?.stack?.subCategory != null && element?.stack?.subCategory !=  '');
  //   return groupBy(filteredAllEmptySubCategories, (UserTechStackModel? element) => element?.stack?.subCategory ?? "");
  // }

  String getTechExperienceNameFromValue(UserTechStackModel model) {
    final techExp = techStackExperiences
        .where((element) => (element['value'] as int) == model.experience)
        .firstOrNull;
    if (techExp == null) {
      return '';
    }
    return techExp['title'] as String;
  }

  // this method Adds a tech stack locally and then to the server,
  // uses the optimistic update feature
  void addTechStack(
      {required UserModel userModel,
      required UserTechStackModel techStackModel}) async {
    update() {
      final userProfiles = [...state.userProfiles];
      final userProfileIndex = userProfiles
          .indexWhere((element) => element.username == userModel.username);
      final userProfile = userProfiles[userProfileIndex];
      final techStacks = [...userProfile.techStacks];

      // add the new techStack
      techStacks.remove(techStackModel);
      techStacks.add(techStackModel);

      userProfiles[userProfileIndex] =
          userProfile.copyWith(techStacks: techStacks);

      emit(state.copyWith(
          status: UserStatus.addTechStackSuccessful,
          userProfiles: userProfiles));
    }

    reverse(String reason) {
      final userProfiles = [...state.userProfiles];
      final userProfileIndex = userProfiles
          .indexWhere((element) => element.username == userModel.username);
      final userProfile = userProfiles[userProfileIndex];
      final techStacks = [...userProfile.techStacks];

      // remove the added techStack
      techStacks.remove(techStackModel);

      userProfiles[userProfileIndex] =
          userProfile.copyWith(techStacks: techStacks);

      emit(state.copyWith(
          status: UserStatus.addTechStackFailed, userProfiles: userProfiles));
    }

    try {
      emit(state.copyWith(status: UserStatus.addTechStackInProgress));
      update();

      final either = await userRepository.updateTechStack(
          userTechStackModel: techStackModel, deleteStacks: false);
      either.fold((l) => reverse(l.errorDescription), (r) {
        // do nothing because a success event has already been raised
      });
    } catch (e) {
      reverse(e.toString());
    }
  }

  // this method Removes a tech stack locally and then from the server,
  // uses the optimistic update feature
  void removeTechStack(
      {required UserModel userModel,
      required UserTechStackModel techStackModel}) async {
    final existingUserProfiles = state.userProfiles;
    final existingUserProfile = existingUserProfiles
        .where((element) => element.username == userModel.username)
        .firstOrNull;
    if (existingUserProfile == null) {
      return;
    }
    final existingTechStacks = existingUserProfile.techStacks;

    update() {
      final userProfiles = [...state.userProfiles];
      final userProfileIndex = userProfiles
          .indexWhere((element) => element.username == userModel.username);
      final userProfile = userProfiles[userProfileIndex];
      final techStacks = [...userProfile.techStacks];

      // remove the new techStack
      final selectedTechStackIndex = techStacks
          .indexWhere((element) => element.stackId == techStackModel.stackId);
      if (selectedTechStackIndex < 0) {
        return;
      }
      techStacks.removeAt(selectedTechStackIndex);

      userProfiles[userProfileIndex] =
          userProfile.copyWith(techStacks: techStacks);

      emit(state.copyWith(
          status: UserStatus.removeTechStackSuccessful,
          userProfiles: userProfiles));
    }

    reverse(String reason) {
      final userProfiles = [...state.userProfiles];
      final userProfileIndex = userProfiles
          .indexWhere((element) => element.username == userModel.username);
      final userProfile = userProfiles[userProfileIndex];

      // reverse back to the previous tech stacks
      userProfiles[userProfileIndex] =
          userProfile.copyWith(techStacks: [...existingTechStacks]);

      emit(state.copyWith(
          status: UserStatus.removeTechStackFailed,
          userProfiles: userProfiles));
    }

    try {
      emit(state.copyWith(status: UserStatus.removeTechStackInProgress));
      update();

      final either = await userRepository.updateTechStack(
          userTechStackModel: techStackModel, deleteStacks: true);
      either.fold((l) => reverse(l.errorDescription), (r) {
        // do nothing because a success event has already been raised
      });
    } catch (e) {
      reverse(e.toString());
    }
  }

  // set tech stack as featured
  void markTechStackAsFeatured(
      {required UserModel userModel,
      required UserTechStackModel techStackModel}) async {
    update() {
      final userProfiles = [...state.userProfiles];
      final userProfileIndex = userProfiles
          .indexWhere((element) => element.username == userModel.username);
      final userProfile = userProfiles[userProfileIndex];
      final techStacks = [...userProfile.techStacks];
      final selectedTechStackIndex = techStacks
          .indexWhere((element) => element.stackId == techStackModel.stackId);
      if (selectedTechStackIndex < 0) {
        return;
      }
      final selectedTechStack = techStacks[selectedTechStackIndex];

      // this is where we set the new isFeatured value
      techStacks[selectedTechStackIndex] = selectedTechStack.copyWith(
        isFeatured: techStackModel.isFeatured,
      );
      userProfiles[userProfileIndex] =
          userProfile.copyWith(techStacks: techStacks);

      emit(state.copyWith(
          status: UserStatus.markTechStackAsFeaturedSuccessful,
          userProfiles: userProfiles));
    }

    reverse(String reason) {
      final userProfiles = [...state.userProfiles];
      final userProfileIndex = userProfiles
          .indexWhere((element) => element.username == userModel.username);
      final userProfile = userProfiles[userProfileIndex];
      final techStacks = [...userProfile.techStacks];
      final selectedTechStackIndex =
          techStacks.indexWhere((element) => element.id == techStackModel.id);
      if (selectedTechStackIndex < 0) {
        return;
      }
      final selectedTechStack = techStacks[selectedTechStackIndex];

      // this is where we reverse it
      techStacks[selectedTechStackIndex] = selectedTechStack.copyWith(
          isFeatured: !selectedTechStack.isFeatured!);
      userProfiles[userProfileIndex] =
          userProfile.copyWith(techStacks: techStacks);

      emit(state.copyWith(
          status: UserStatus.markTechStackAsFeaturedFailed,
          userProfiles: userProfiles));
    }

    try {
      emit(
          state.copyWith(status: UserStatus.markTechStackAsFeaturedInProgress));
      update();

      final either = await userRepository.updateTechStack(
          userTechStackModel: techStackModel, deleteStacks: false);
      either.fold((l) => reverse(l.errorDescription), (r) {
        // do nothing because a success event has already been raised
      });
    } catch (e) {
      reverse(e.toString());
    }
  }

  // this method updates a tech stack locally and then from the server,
  // uses the optimistic update feature
  void updateTechStackExperience(
      {required UserModel userModel,
      required UserTechStackModel techStackModel}) async {
    final existingUserProfiles = state.userProfiles;
    final existingUserProfile = existingUserProfiles
        .where((element) => element.username == userModel.username)
        .firstOrNull;
    if (existingUserProfile == null) {
      return;
    }
    final existingTechStacks = existingUserProfile.techStacks;

    update() {
      final userProfiles = [...state.userProfiles];
      final userProfileIndex = userProfiles
          .indexWhere((element) => element.username == userModel.username);
      final userProfile = userProfiles[userProfileIndex];
      final techStacks = [...userProfile.techStacks];
      final selectedTechStackIndex = techStacks
          .indexWhere((element) => element.stackId == techStackModel.stackId);
      if (selectedTechStackIndex < 0) {
        return;
      }
      final selectedTechStack = techStacks[selectedTechStackIndex];

      // this is where we set the new isFeatured value
      techStacks[selectedTechStackIndex] = selectedTechStack.copyWith(
        experience: techStackModel.experience,
      );

      userProfiles[userProfileIndex] =
          userProfile.copyWith(techStacks: techStacks);

      emit(state.copyWith(
          status: UserStatus.updateTechStackExperienceSuccessful,
          userProfiles: userProfiles));
    }

    reverse(String reason) {
      final userProfiles = [...state.userProfiles];
      final userProfileIndex = userProfiles
          .indexWhere((element) => element.username == userModel.username);
      final userProfile = userProfiles[userProfileIndex];

      // reverse back to the previous tech stacks
      userProfiles[userProfileIndex] =
          userProfile.copyWith(techStacks: [...existingTechStacks]);

      emit(state.copyWith(
          status: UserStatus.updateTechStackExperienceFailed,
          userProfiles: userProfiles));
    }

    try {
      emit(state.copyWith(
          status: UserStatus.updateTechStackExperienceInProgress));
      update();

      final either = await userRepository.updateTechStack(
          userTechStackModel: techStackModel, deleteStacks: false);
      either.fold((l) => reverse(l.errorDescription), (r) {
        // do nothing because a success event has already been raised
      });
    } catch (e) {
      reverse(e.toString());
    }
  }

  void fetchTechStacks({required UserModel userModel}) async {
    if (userModel.username == null) {
      return;
    }

    try {
      emit(state.copyWith(status: UserStatus.fetchTechStacksInProgress));

      final either =
          await userRepository.fetchTechStacks(userName: userModel.username!);
      either.fold((l) {
        emit(state.copyWith(
            status: UserStatus.fetchTechStacksFailed,
            message: l.errorDescription));
      }, (r) {
        final userProfiles = [...state.userProfiles];
        final userProfileIndex = userProfiles
            .indexWhere((element) => element.username == userModel.username);
        final userProfile = userProfiles[userProfileIndex];

        // the server is the main source of truth, so just replace every tech stack with data from server
        userProfiles[userProfileIndex] = userProfile.copyWith(techStacks: r);

        emit(state.copyWith(
            status: UserStatus.fetchTechStacksSuccessful,
            userProfiles: userProfiles));
      });
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.fetchTechStacksFailed, message: e.toString()));
    }
  }

  void addExperience(
    UserModel userModel, {
    String? title,
    bool? current,
    DateTime? startDate,
    DateTime? endDate,
    CompanyModel? company,
    String? description,
    List<UserStackModel>? stacks,
  }) async {
    try {
      emit(state.copyWith(status: UserStatus.addExperienceInProgress));

      final either = await userRepository.addExperience(
          title: title,
          current: current,
          startDate: startDate,
          endDate: endDate,
          company: company,
          description: description,
          stacks: stacks);

      either.fold(
          (l) => emit(state.copyWith(
              status: UserStatus.addExperienceFailed,
              message: l.errorDescription)), (r) {
        final userProfiles = [...state.userProfiles];
        final userProfileIndex = userProfiles
            .indexWhere((element) => element.username == userModel.username);
        final userProfile = userProfiles[userProfileIndex];

        // the server is the main source of truth, so just replace every tech stack with data from server
        final experiences = [...userProfile.experiences];
        experiences.add(r);
        userProfiles[userProfileIndex] =
            userProfile.copyWith(experiences: experiences);

        emit(state.copyWith(
            status: UserStatus.addExperienceSuccessful,
            userProfiles: userProfiles));

        // fetch all experiences to update data from the server
        fetchExperiences(userModel);
      });
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.addExperienceFailed, message: e.toString()));
    }
  }

  void addUserExperienceStack(
    UserModel userModel, {
    required UserExperienceModel userExperienceModel,
    required UserStackModel stackModel,
  }) async {
    optimisticUpdate({bool reverse = false, String? reason}) {
      final userProfiles = [...state.userProfiles];
      final userProfileIndex = userProfiles
          .indexWhere((element) => element.username == userModel.username);
      final userProfile = userProfiles[userProfileIndex];

      final experiences = [...userProfile.experiences];
      final selectedExperienceIndex = experiences
          .indexWhere((element) => element.id == userExperienceModel.id);
      final selectedExperience = experiences[selectedExperienceIndex];

      final selectedExperienceStacksCopied = <UserTechStackModel>[
        ...(selectedExperience.stacks ?? <UserTechStackModel>[])
      ];

      if (reverse) {
        /// Remove the added tech stack once server fails
        selectedExperienceStacksCopied.removeWhere(
          (element) =>
              element.experienceId == userExperienceModel.id &&
              element.stackId == stackModel.id,
        );
      } else {
        /// Add the tech stack immediately
        selectedExperienceStacksCopied.add(UserTechStackModel(
            experienceId: userExperienceModel.id,
            stackId: stackModel.id,
            stack: stackModel));
      }

      final copiedExp =
          selectedExperience.copyWith(stacks: selectedExperienceStacksCopied);

      experiences[selectedExperienceIndex] = copiedExp;
      userProfiles[userProfileIndex] =
          userProfile.copyWith(experiences: experiences);

      if (reverse) {
        emit(state.copyWith(
            status: UserStatus.addUserExperienceStackFailed,
            message: reason ?? 'Unable to update tech stack',
            userProfiles: userProfiles));
      } else {
        emit(state.copyWith(
            status: UserStatus.addUserExperienceStackSuccessful,
            userProfiles: userProfiles));
      }
    }

    try {
      emit(state.copyWith(
        status: UserStatus.addUserExperienceStackInProgress,
      ));
      // update
      optimisticUpdate();

      final either = await userRepository.addUserExperienceStack(
          stackModel: stackModel, userExperienceModel: userExperienceModel);
      either.fold((l) {
        optimisticUpdate(reverse: true, reason: l.errorDescription);
      }, (r) {
        // state and UI already updated so no need to do anything here

        fetchExperiences(userModel);
      });
    } catch (e) {
      optimisticUpdate(reverse: true, reason: e.toString());
    }
  }

  void deleteUserExperienceStack(
    UserModel userModel, {
    required UserExperienceModel userExperienceModel,
    required UserTechStackModel techStackModel,
  }) async {
    optimisticUpdate({bool reverse = false, String? reason}) {
      final userProfiles = [...state.userProfiles];
      final userProfileIndex = userProfiles
          .indexWhere((element) => element.username == userModel.username);
      final userProfile = userProfiles[userProfileIndex];

      final experiences = [...userProfile.experiences];
      final selectedExperienceIndex = experiences
          .indexWhere((element) => element.id == userExperienceModel.id);
      final selectedExperience = experiences[selectedExperienceIndex];

      final selectedExperienceStacksCopied = <UserTechStackModel>[
        ...(selectedExperience.stacks ?? <UserTechStackModel>[])
      ];

      if (reverse) {
        /// re-Add the tech stack once server fails
        selectedExperienceStacksCopied.add(techStackModel);
      } else {
        /// Remove stack
        selectedExperienceStacksCopied.removeWhere(
          (element) =>
              element.experienceId == userExperienceModel.id &&
              element.stackId == techStackModel.stackId,
        );
      }

      final copiedExp =
          selectedExperience.copyWith(stacks: selectedExperienceStacksCopied);

      experiences[selectedExperienceIndex] = copiedExp;
      userProfiles[userProfileIndex] =
          userProfile.copyWith(experiences: experiences);

      if (reverse) {
        emit(state.copyWith(
            status: UserStatus.deleteUserExperienceStackFailed,
            message: reason ?? 'Unable to remove tech stack',
            userProfiles: userProfiles));
      } else {
        emit(state.copyWith(
            status: UserStatus.deleteUserExperienceStackSuccessful,
            userProfiles: userProfiles));
      }
    }

    try {
      emit(state.copyWith(
        status: UserStatus.deleteUserExperienceStackInProgress,
      ));
      // update
      optimisticUpdate();

      final either = await userRepository.deleteUserExperienceStack(
          stackModel: techStackModel.stack,
          userExperienceModel: userExperienceModel);
      either.fold((l) {
        optimisticUpdate(reverse: true, reason: l.errorDescription);
      }, (r) {
        // state and UI already updated so no need to do anything here

        fetchExperiences(userModel);
      });
    } catch (e) {
      optimisticUpdate(reverse: true, reason: e.toString());
    }
  }

  void updateExperience(
    UserModel userModel,
    UserExperienceModel experience, {
    String? title,
    bool? current,
    DateTime? startDate,
    DateTime? endDate,
    CompanyModel? company,
    String? description,
  }) async {
    try {
      emit(state.copyWith(status: UserStatus.updateExperienceInProgress));
      final either = await userRepository.updateExperience(experience,
          title: title,
          current: current,
          startDate: startDate,
          endDate: endDate,
          company: company,
          description: description);

      either.fold(
          (l) => emit(state.copyWith(
              status: UserStatus.updateExperienceFailed,
              message: l.errorDescription)), (r) {
        final userProfiles = [...state.userProfiles];
        final userProfileIndex = userProfiles
            .indexWhere((element) => element.username == userModel.username);
        final userProfile = userProfiles[userProfileIndex];

        // the server is the main source of truth, so just replace every tech stack with data from server
        final experiences = [...userProfile.experiences];
        final selectedExperienceIndex =
            experiences.indexWhere((element) => element.id == experience.id);
        experiences[selectedExperienceIndex] = r;
        userProfiles[userProfileIndex] =
            userProfile.copyWith(experiences: experiences);

        emit(state.copyWith(
            status: UserStatus.updateExperienceSuccessful,
            userProfiles: userProfiles));

        // fetch all experiences to update data from the server
        fetchExperiences(userModel);
      });
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.updateExperienceFailed, message: e.toString()));
    }
  }

  void deleteExperience(
      UserModel userModel, UserExperienceModel experience) async {
    try {
      emit(state.copyWith(status: UserStatus.deleteExperienceInProgress));

      final either = await userRepository.deleteExperience(experience);
      either.fold(
          (l) => emit(state.copyWith(
              status: UserStatus.deleteExperienceFailed,
              message: l.errorDescription)), (r) {
        final userProfiles = [...state.userProfiles];
        final userProfileIndex = userProfiles
            .indexWhere((element) => element.username == userModel.username);
        final userProfile = userProfiles[userProfileIndex];

        // the server is the main source of truth, so just replace every tech stack with data from server
        final experiences = [...userProfile.experiences];
        experiences.removeWhere((element) => element.id == experience.id);
        userProfiles[userProfileIndex] =
            userProfile.copyWith(experiences: experiences);
        emit(state.copyWith(
            status: UserStatus.deleteExperienceSuccessful,
            userProfiles: userProfiles));
      });
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.deleteExperienceFailed, message: e.toString()));
    }
  }

  void fetchExperiences(UserModel userModel) async {
    try {
      emit(state.copyWith(status: UserStatus.fetchExperiencesInProgress));

      final either = await userRepository.fetchExperiences(userModel);
      either.fold(
          (l) => emit(state.copyWith(
              status: UserStatus.fetchExperiencesFailed,
              message: l.errorDescription)), (r) {
        final userProfiles = [...state.userProfiles];
        final userProfileIndex = userProfiles
            .indexWhere((element) => element.username == userModel.username);
        final userProfile = userProfiles[userProfileIndex];

        // the server is the main source of truth, so just replace every tech stack with data from server
        userProfiles[userProfileIndex] = userProfile.copyWith(experiences: r);
        emit(state.copyWith(
            status: UserStatus.fetchExperiencesSuccessful,
            userProfiles: userProfiles));
      });
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.fetchExperiencesFailed, message: e.toString()));
    }
  }

//  addCertification
  void addCertification(UserModel userModel,
      {String? attachmentUrl,
      String? title,
      CompanyModel? company,
      DateTime? startDate,
      DateTime? endDate,
      bool? current,
      String? certificationId,
      String? url}) async {
    try {
      emit(state.copyWith(status: UserStatus.addCertificationInProgress));

      final either = await userRepository.addCertification(
          attachmentUrl: attachmentUrl,
          title: title,
          current: current,
          startDate: startDate,
          endDate: endDate,
          company: company,
          url: url,
          certificationId: certificationId);

      either.fold(
          (l) => emit(state.copyWith(
              status: UserStatus.addCertificationFailed,
              message: l.errorDescription)), (r) {
        final userProfiles = [...state.userProfiles];
        final userProfileIndex = userProfiles
            .indexWhere((element) => element.username == userModel.username);
        final userProfile = userProfiles[userProfileIndex];

        // the server is the main source of truth, so just replace every tech stack with data from server
        final certifications = [...userProfile.certifications];
        certifications.add(r);
        userProfiles[userProfileIndex] =
            userProfile.copyWith(certifications: certifications);

        emit(state.copyWith(
            status: UserStatus.addCertificationSuccessful,
            userProfiles: userProfiles));

        // fetch all experiences to update data from the server
        fetchCertifications(userModel);
      });
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.addCertificationFailed, message: e.toString()));
    }
  }

  void fetchCertifications(UserModel userModel) async {
    try {
      emit(state.copyWith(status: UserStatus.fetchCertificationsInProgress));

      final either = await userRepository.fetchCertifications(userModel);
      either.fold(
          (l) => emit(state.copyWith(
              status: UserStatus.fetchCertificationsFailed,
              message: l.errorDescription)), (r) {
        final userProfiles = [...state.userProfiles];
        final userProfileIndex = userProfiles
            .indexWhere((element) => element.username == userModel.username);
        final userProfile = userProfiles[userProfileIndex];

        // the server is the main source of truth, so just replace every tech stack with data from server
        userProfiles[userProfileIndex] =
            userProfile.copyWith(certifications: r);
        emit(state.copyWith(
            status: UserStatus.fetchCertificationsSuccessful,
            userProfiles: userProfiles));
      });
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.fetchCertificationsFailed, message: e.toString()));
    }
  }

  void updateCertification(
      UserModel userModel, UserCertificationModel credential,
      {String? attachmentUrl,
      String? title,
      CompanyModel? company,
      DateTime? startDate,
      DateTime? endDate,
      bool? current,
      String? certificationId,
      String? url}) async {
    try {
      emit(state.copyWith(status: UserStatus.updateCertificationInProgress));
      final either = await userRepository.updateCertification(credential,
          title: title,
          current: current,
          startDate: startDate,
          endDate: endDate,
          company: company,
          attachmentUrl: attachmentUrl,
          url: url);

      either.fold(
          (l) => emit(state.copyWith(
              status: UserStatus.updateCertificationFailed,
              message: l.errorDescription)), (r) {
        final userProfiles = [...state.userProfiles];
        final userProfileIndex = userProfiles
            .indexWhere((element) => element.username == userModel.username);
        final userProfile = userProfiles[userProfileIndex];

        // the server is the main source of truth, so just replace every tech stack with data from server
        final certifications = [...userProfile.certifications];
        final selectedCredentialIndex =
            certifications.indexWhere((element) => element.id == credential.id);
        certifications[selectedCredentialIndex] = r;
        userProfiles[userProfileIndex] =
            userProfile.copyWith(certifications: certifications);

        emit(state.copyWith(
            status: UserStatus.updateCertificationSuccessful,
            userProfiles: userProfiles));

        // fetch all experiences to update data from the server
        fetchCertifications(userModel);
      });
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.updateCertificationFailed, message: e.toString()));
    }
  }

  void deleteCertification(
      UserModel userModel, UserCertificationModel certification) async {
    try {
      emit(state.copyWith(status: UserStatus.deleteCertificationInProgress));

      final either = await userRepository.deleteCertification(certification);
      either.fold(
          (l) => emit(state.copyWith(
              status: UserStatus.deleteCertificationFailed,
              message: l.errorDescription)), (r) {
        final userProfiles = [...state.userProfiles];
        final userProfileIndex = userProfiles
            .indexWhere((element) => element.username == userModel.username);
        final userProfile = userProfiles[userProfileIndex];

        // the server is the main source of truth, so just replace every tech stack with data from server
        final certifications = [...userProfile.certifications];
        certifications.removeWhere((element) => element.id == certification.id);
        userProfiles[userProfileIndex] =
            userProfile.copyWith(certifications: certifications);
        emit(state.copyWith(
            status: UserStatus.deleteCertificationSuccessful,
            userProfiles: userProfiles));
      });
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.deleteCertificationFailed, message: e.toString()));
    }
  }

  Future<List<UserModel>?> searchUser({required String keyword}) async {
    try {
      emit(state.copyWith(status: UserStatus.searchUserLoading));

      final either = await userRepository.searchUser(keyword: keyword);

      if (either.isLeft()) {
        final l = either.asLeft();
        emit(state.copyWith(
            status: UserStatus.searchUserFailed, message: l.errorDescription));
        return null;
      }

      //! successful
      final r = either.asRight();
      emit(state.copyWith(
        status: UserStatus.searchUserSuccessful,
      ));
      return r;
    } catch (e) {
      debugPrint('error: $e');
      emit(state.copyWith(
          status: UserStatus.searchUserFailed, message: e.toString()));
      return null;
    }
  }

  void fetchSocials({required String userName}) async {
    try {
      emit(state.copyWith(status: UserStatus.fetchUsersSocialInProgress));

      final either = await userRepository.fetchUserSocials(userName: userName);
      either.fold(
          (l) => emit(state.copyWith(
              status: UserStatus.fetchUsersSocialFailed,
              message: l.errorDescription)), (r) {
        emit(state.copyWith(
            status: UserStatus.fetchUsersSocialSuccessful,
            social: {userName: r}));
      });
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.fetchUsersSocialFailed, message: e.toString()));
    }
  }

  Future<Either<String, List<UserModel>>> fetchUserCollaborators(
      {UserModel? user, required int pageKey}) async {
    try {
      emit(state.copyWith(status: UserStatus.fetchUserCollaboratorsInProgress));
      user = user ??= AppStorage.currentUserSession;

      final usersMap = {...state.collaborators};
      final List<UserModel> users = usersMap[user!.username] ?? <UserModel>[];

      final skip = pageKey > 0 ? defaultPageSize : pageKey;
      final path = ApiConfig.fetchCircleMembers(
          userId: user.id!, skip: skip, limit: defaultPageSize);
      final either = await userRepository.fetchUserList(path: path);

      if (either.isLeft()) {
        final l = either.asLeft();
        emit(state.copyWith(
            status: UserStatus.fetchUserCollaboratorsFailed,
            message: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful
      List<UserModel> r = either.asRight();
      if (pageKey == 0) {
        // if its first page request remove all existing threads
        users.clear();
      }

      users.addAll(r);

      usersMap[user.username!] = users;

      emit(state.copyWith(
          status: UserStatus.fetchUserCollaboratorsSuccessful,
          collaborators: usersMap));

      return Right(r);
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.fetchUserCollaboratorsFailed,
          message: e.toString()));
      return Left(e.toString());
    }

    // // we request for the default page size on the first call and subsequently we skip by the length of shows available
    // final skip = pageKey  > 0 ?  defaultPageSize : pageKey;  //
    // final path =  ApiConfig.fetchCircleMembers(userId: user.id!, skip: skip,limit: defaultPageSize);
    // return _fetchUsers(pageKey: pageKey, path: path);
    //
  }

  Future<Either<String, List<UserModel>>> fetchUserFollowers(
      {UserModel? user, required int pageKey}) async {
    try {
      emit(state.copyWith(status: UserStatus.fetchUserFollowersInProgress));
      user = user ??= AppStorage.currentUserSession;

      final usersMap = {...state.followers};
      final List<UserModel> users = usersMap[user!.username] ?? <UserModel>[];

      final skip = pageKey > 0 ? defaultPageSize : pageKey;
      final path = ApiConfig.fetchFollowers(
          userId: user.id!, skip: skip, limit: defaultPageSize);
      final either = await userRepository.fetchUserList(path: path);

      if (either.isLeft()) {
        final l = either.asLeft();
        emit(state.copyWith(
            status: UserStatus.fetchUserFollowersFailed,
            message: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful
      List<UserModel> r = either.asRight();
      if (pageKey == 0) {
        // if its first page request remove all existing threads
        users.clear();
      }

      users.addAll(r);

      usersMap[user.username!] = users;

      emit(state.copyWith(
          status: UserStatus.fetchUserFollowersSuccessful,
          followers: usersMap));

      return Right(r);
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.fetchUserFollowersFailed, message: e.toString()));
      return Left(e.toString());
    }
  }

  Future<Either<String, List<UserModel>>> fetchUserFollowing(
      {UserModel? user, required int pageKey}) async {
    try {
      emit(state.copyWith(status: UserStatus.fetchUserFollowingInProgress));
      user = user ??= AppStorage.currentUserSession;

      final usersMap = {...state.following};
      final List<UserModel> users = usersMap[user!.username] ?? <UserModel>[];

      final skip = pageKey > 0 ? defaultPageSize : pageKey;
      final path = ApiConfig.fetchFollowing(
          userId: user.id!, skip: skip, limit: defaultPageSize);
      final either = await userRepository.fetchUserList(path: path);

      if (either.isLeft()) {
        final l = either.asLeft();
        emit(state.copyWith(
            status: UserStatus.fetchUserFollowingFailed,
            message: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful
      List<UserModel> r = either.asRight();
      if (pageKey == 0) {
        // if its first page request remove all existing threads
        users.clear();
      }

      users.addAll(r);

      usersMap[user.username!] = users;

      emit(state.copyWith(
          status: UserStatus.fetchUserFollowingSuccessful,
          following: usersMap));

      return Right(r);
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.fetchUserFollowingFailed, message: e.toString()));
      return Left(e.toString());
    }
  }

  void fetchCustomFeaturedShows(
      {required UserModel userModel, required List<int> projectIds}) async {
    try {
      emit(state.copyWith(
          status: UserStatus.fetchCustomFeaturedShowsInProgress));
      final either = await userRepository.fetchCustomFeaturedProjects(
          userModel, projectIds);
      if (either.isLeft()) {
        final l = either.asLeft();
        emit(state.copyWith(
            status: UserStatus.fetchCustomFeaturedShowsFailed,
            message: l.errorDescription));
        return;
      }

      // successful
      final r = either.asRight();
      final customFeaturedShows = {...state.customFeaturedShows};
      customFeaturedShows[userModel.username!] = r;

      emit(state.copyWith(
          status: UserStatus.fetchCustomFeaturedShowsSuccessful,
          customFeaturedShows: customFeaturedShows));
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.fetchCustomFeaturedShowsFailed,
          message: e.toString()));
    }
  }

  void fetchCustomFeaturedSeries(
      {required UserModel userModel, required List<int> seriesIds}) async {
    try {
      emit(state.copyWith(
          status: UserStatus.fetchCustomFeaturedSeriesInProgress));
      final either =
          await userRepository.fetchCustomFeaturedSeries(userModel, seriesIds);
      if (either.isLeft()) {
        final l = either.asLeft();
        emit(state.copyWith(
            status: UserStatus.fetchCustomFeaturedSeriesFailed,
            message: l.errorDescription));
        return;
      }

      // successful
      final r = either.asRight();

      final customFeaturedSeries = {...state.customFeaturedSeries};
      customFeaturedSeries[userModel.username!] = r;

      emit(state.copyWith(
          status: UserStatus.fetchCustomFeaturedSeriesSuccessful,
          customFeaturedSeries: customFeaturedSeries));
    } catch (e) {
      emit(state.copyWith(
          status: UserStatus.fetchCustomFeaturedSeriesFailed,
          message: e.toString()));
    }
  }



  void downloadResume({required String resumeUrl,required String userName}) async {

    final localPath = await _prepareSaveDir();
    try {
      emit(state.copyWith(status: UserStatus.downloadResumeLoading,));
      await Dio().download(resumeUrl, '$localPath/$userName.pdf',onReceiveProgress: ((received, total){}));
      emit(state.copyWith(status: UserStatus.downloadResumeSuccess,));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.downloadResumeError, message: e.toString(),));
    }


  }

  Future<String> _prepareSaveDir() async {
    final localPath = (await _findLocalPath())!;

    debugPrint(localPath);
    final savedDir = Directory(localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    return localPath;
  }

  Future<String?> _findLocalPath() async {
    if (Platform.isAndroid) {
      return "/sdcard/download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }

}
