import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/analytics/data/service/analytics_service.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/repositories/auth_broadcast_repository.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_enums.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_state.dart';
import 'package:showwcase_v3/features/communities/data/models/community_broadcast_event.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/data/repositories/community_repository.dart';

import '../repositories/community_broadcast_repository.dart';

class CommunityCubit extends Cubit<CommunityState> {
  final CommunityRepository communityRepository;
  final CommunityBroadcastRepository communityBroadcastRepository;
  StreamSubscription? authBroadcastRepositoryStreamListener;
  StreamSubscription<CommunityBroadcastEvent>? communityBroadcastRepositoryStreamListener;
  final AuthBroadcastRepository authBroadcastRepository;

  CommunityCubit({
    required this.communityRepository,
    required this.authBroadcastRepository,
    required this.communityBroadcastRepository,
  }) : super(const CommunityState()) {
    listenToAuthLogout();
    _listenToCommunityBroadCastStreams();
  }

  void _listenToCommunityBroadCastStreams() async {
    await communityBroadcastRepositoryStreamListener?.cancel();
    communityBroadcastRepository.stream.listen((communityBroadcastEvent) {

      if(communityBroadcastEvent.action == CommunityBroadcastAction.updateCommunity) {

        final updatedCommunity = communityBroadcastEvent.community!;

        emit(state.copyWith(status: CommunityStatus.updateCommunityInProgress));
        // find the thread whose values are updated
        final updatedCommunityList = [...state.communities];
        final communityIndex = updatedCommunityList.indexWhere((element) => element.id == updatedCommunity.id);

        // we can't continue if thread wasn't found
        // For some subclasses of threadCubit, this thread will not be found
        if(communityIndex < 0){return;}

        updatedCommunityList[communityIndex] = updatedCommunity;

        // if thread was found in this cubit then update, and notify all listening UIs
        emit(state.copyWith(
            communities: updatedCommunityList,
            status: CommunityStatus.updateCommunityCompleted,
        ));
      }

    });


  }

  void listenToAuthLogout() async {
    // listen to authCubit changes
    await authBroadcastRepositoryStreamListener?.cancel();

    authBroadcastRepositoryStreamListener =
        authBroadcastRepository.authBroadcastStream.listen((data) {
      if (data.action == AuthBroadcastAction.logout) {
        emit(state.copyWith(
            status: CommunityStatus.resetCommunityStateInProgress));
        emit(const CommunityState(
            status: CommunityStatus.initial));
      }
    });
  }

  // Close stream subscriptions when cubit is disposed to avoid any memory leaks
  @override
  Future<void> close() async {
    await authBroadcastRepositoryStreamListener?.cancel();
    return super.close();
  }

  /// All infinite scroll community list can Subclass CommunityCubit and use this method
  Future<Either<String, List<CommunityModel>>> fetchCommunities({required int pageKey, required String path}) async {
    try {
      emit(state.copyWith(status: CommunityStatus.fetchCommunitiesInProgress));
      final either = await communityRepository.fetchCommunities(path: path);

      if (either.isLeft()) {
        final l = either.asLeft();
        emit(state.copyWith(status: CommunityStatus.fetchCommunitiesFailed, message: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful
      List<CommunityModel> r = either.asRight();
      final List<CommunityModel> communities = [...state.communities];
      if (pageKey == 0) {
        // if its first page request remove all existing threads
        communities.clear();
      }

      communities.addAll(r);

      emit(state.copyWith(status: CommunityStatus.fetchCommunitiesSuccessful, communities: communities));

      return Right(r);

    } catch (e) {
      debugPrint("customLog: $e");
      emit(state.copyWith(status: CommunityStatus.fetchCommunitiesFailed, message: e.toString()));
      return Left(e.toString());
    }
  }


  //  void featureAndUnFeature(
  //       {required String action, required int communityId}) async {
  //     try {
  //       emit(ManageFeatureLoading());
  //       final rolesResponse = await communitiesRepository.featureAndUnFeature(
  //           action: action, communityId: communityId);
  //       rolesResponse.fold((l) => emit(ManageFeatureError(apiError: l)),
  //           (r) => emit(const ManageFeatureSuccess()));
  //     } catch (e) {
  //       emit(ManageFeatureError(
  //           apiError: ApiError(errorDescription: e.toString())));
  //     }
  //   }

  void joinLeaveCommunity(
      {required CommunityModel communityModel,
      required CommunityJoinLeaveAction action}) async {
    if (communityModel.id == null) {
      return;
    }

    // get the existing value of the field to be updated .....
    final isMember = communityModel.isMember; // existing value

    // optimistic update
    void update() {
      final updatedCommunity = communityModel.copyWith(isMember: action == CommunityJoinLeaveAction.join);
      // broadcast for other cubits
      communityBroadcastRepository.updateCommunity(updatedCommunity: updatedCommunity);
    }

    void reverse(String reason) {

      final updatedCommunity = communityModel.copyWith(isMember: isMember);
      // broadcast for other cubits
      communityBroadcastRepository.updateCommunity(updatedCommunity: updatedCommunity);

    }

    try {
      // optimistic update!
      update();

      final either = await communityRepository.joinAndLeaveCommunity(
          communityId: communityModel.id!, action: action.name);

      either.fold((l) => reverse(l.errorDescription), (r) {
        AnalyticsService.instance.sendEventCommunityJoin(communityModel: communityModel);
        // already emitted success so not action is required
      });
    } catch (e) {
      reverse(e.toString());
    }
  }

  void featureAndUnFeature(
      {required CommunityModel communityModel,
        required FeatureUnfeatureCommunityAction action}) async {
    if (communityModel.id == null) {
      return;
    }

    final isFeatured = communityModel.isFeatured; // existing value

    // optimistic update
    void update() {

      final updatedCommunity = communityModel.copyWith(isFeatured: action == FeatureUnfeatureCommunityAction.feature);
      communityBroadcastRepository.updateCommunity(updatedCommunity: updatedCommunity);
    }

    void reverse(String reason) {

      final updatedCommunity = communityModel.copyWith(isFeatured: isFeatured);
      communityBroadcastRepository.updateCommunity(updatedCommunity: updatedCommunity);

    }

    try {
      // optimistic update!
      update();

      final either = await communityRepository.joinAndLeaveCommunity(communityId: communityModel.id!, action: action.name);

      either.fold((l) => reverse(l.errorDescription), (r) {
        // already emitted success so not action is required

      });
    } catch (e) {
      reverse(e.toString());
    }
  }



  Future<List<CommunityModel>?> searchCommunities(
      {required String keyword}) async {
    try {
      emit(state.copyWith(status: CommunityStatus.searchCommunitiesInProgress));

      final either = await communityRepository.searchCommunities(
        keyword: keyword,
      );

      if (either.isLeft()) {
        final l = either.asLeft();
        emit(state.copyWith(
            status: CommunityStatus.searchCommunitiesFailed,
            message: l.errorDescription));
        return null;
      }

      //! successful
      final r = either.asRight();
      emit(state.copyWith(
        status: CommunityStatus.searchCommunitiesSuccessful,
      ));
      return r;
    } catch (e) {
      emit(state.copyWith(
          status: CommunityStatus.searchCommunitiesFailed,
          message: e.toString()));
      return null;
    }
  }


  void fetchCommunityDetails({required String communitySlug}) async {
    try {
      emit(state.copyWith(
          status: CommunityStatus.fetchCommunityDetailsInProgress));
      final communityDetails = await communityRepository.fetchCommunityDetails(
          communityName: communitySlug);

      communityDetails.fold(
          (l) => emit(state.copyWith(
              status: CommunityStatus.fetchCommunityDetailsFailed,
              message: l.errorDescription)),
          (r) => emit(state.copyWith(
              status: CommunityStatus.fetchCommunityDetailsSuccessful,
               communityDetails: r //todo community
          )));
    } catch (e) {
      emit(state.copyWith(
          status: CommunityStatus.fetchCommunityDetailsFailed,
          message: e.toString()));
    }
  }


  // This is stateless, (Does not keep the data in state) and just returns the data to the caller
  Future<CommunityModel?> getCommunityFromSlug({required String slug}) async {

    try {

      final either = await communityRepository.fetchCommunityDetails(communityName: slug);
      if(either.isLeft()){
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


  // void reportCommunity({required CommunityReportRequest reportRequest}) async {
  //   try {
  //     appLayoutRepository.setPageLoading();
  //
  //     final either = await communityRepository.reportCommunity(reportRequest: reportRequest);
  //
  //     either.fold(
  //             (l) {
  //           // return sharedCubit.showPageError(error: l.errorDescription);
  //           appLayoutRepository.setPageError(message: l.errorDescription);
  //
  //         },
  //             (r) {
  //           appLayoutRepository.setPageSuccess(message: "Thanks for the feedback. The reported community is now under investigation");
  //         }
  //
  //     );
  //
  //   } catch (e) {
  //     // return sharedCubit.showPageError(error: l.errorDescription);
  //     appLayoutRepository.setPageError(message: e.toString());
  //   }
  // }

  // void selectCommunityThreadTag(CommunityThreadTagsModel tags) {
  //    emit(state.copyWith(status: CommunityStatus.communityTagProgress));
  //   emit(state.copyWith(
  //       status: CommunityStatus.communityTagSelected,
  //       selectedCommunityTag: tags));
  // }
}
