import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_enums.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_preview_state.dart';
import 'package:showwcase_v3/features/communities/data/models/community_broadcast_event.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_thread_tag.dart';
import 'package:showwcase_v3/features/communities/data/repositories/community_broadcast_repository.dart';
import 'package:showwcase_v3/features/communities/data/repositories/community_repository.dart';

class CommunityPreviewCubit extends Cubit<CommunityPreviewState>{

  final CommunityRepository communityRepository;
  final CommunityBroadcastRepository communityBroadcastRepository;
  StreamSubscription<CommunityBroadcastEvent>? communityBroadcastRepositoryStreamListener;
  CommunityPreviewCubit({ required this.communityRepository, required this.communityBroadcastRepository}): super(const CommunityPreviewState()){
    _listenToCommunityBroadCastStreams();
  }

  // listen to updated thread streams and update thread states accordingly
  void _listenToCommunityBroadCastStreams() async {

    await communityBroadcastRepositoryStreamListener?.cancel();
    communityBroadcastRepositoryStreamListener = communityBroadcastRepository.stream.listen((communityBroadcastEvent) {

      /// show updated
      if(communityBroadcastEvent.action == CommunityBroadcastAction.updateCommunity) {

        final updatedCommunity = communityBroadcastEvent.community!;

        // find the show whose values are updated
        final communityPreviews = [...state.communityPreviews];
        final communityIndex = communityPreviews.indexWhere((element) => element.id == updatedCommunity.id);

        // we can't continue if thread wasn't found
        // For some subclasses of threadCubit, this thread will not be found
        if(communityIndex > -1){
          final updatedCommunityList = communityPreviews;
          updatedCommunityList[communityIndex] = updatedCommunity;

          emit(state.copyWith(status: CommunityStatus.updateCommunityInProgress));
          // if Show was found in this cubit then update, and notify all listening UIs
          emit(state.copyWith(
            communityPreviews: updatedCommunityList,
            status: CommunityStatus.updateCommunityCompleted,
          ));
        }

      }


    });
  }


  CommunityModel setCommunityPreview({required CommunityModel community, bool updateIfExist = true}){
    // updateIfExist, mean if Show Already Exists should it be updated
    // updateIfExist is usually true after we fetch the full show from the server

    /// This method here adds the a given show to the shows of interest
    /// Once a show is previewed it becomes a show of interest

    emit(state.copyWith(status: CommunityStatus.setCommunityPreviewInProgress,));
    final communityPreviews = [...state.communityPreviews];
    final int index = communityPreviews.indexWhere((element) => element.id == community.id);
    if(index < 0){

      communityPreviews.add(community);

    }else {

      // showPreview has already been added
      // so update it.
      if(updateIfExist) {

        communityPreviews[index] = community;
      }

    }

    emit(state.copyWith(
        status: CommunityStatus.setCommunityPreviewCompleted,
        communityPreviews: communityPreviews
    ));

    // return the threadPreview for methods that needs it
    final communityPreview = state.communityPreviews.firstWhere((element) => element.id == community.id);
    return communityPreview;

  }


  void fetchCommunityTags({required CommunityModel communityModel}) async {
    try {
      emit(state.copyWith(status: CommunityStatus.fetchCommunityTagsInProgress,));
      final rolesResponse = await communityRepository.fetchCommunityTags(slug: communityModel.slug);
      rolesResponse.fold(
              (l) => emit(state.copyWith(status: CommunityStatus.fetchCommunityTagsFailed, message: l.errorDescription)),

              (r) {
                // successful
                  final existingTags = {...state.communityTags};
                  existingTags[communityModel.id!] = r..insert(0, const CommunityThreadTagsModel(name: 'All'));
                  emit(state.copyWith(status: CommunityStatus.fetchCommunityTagsSuccessful, communityTags: existingTags));
              });
    } catch (e) {
      emit(state.copyWith(status: CommunityStatus.fetchCommunityTagsFailed, message: e.toString()));
    }
  }

    void selectCommunityThreadTag(CommunityThreadTagsModel tag) {
       emit(state.copyWith(status: CommunityStatus.selectCommunityThreadTagInProgress));
       emit(state.copyWith(
          status: CommunityStatus.selectCommunityThreadTagCompleted,
          selectedCommunityTag: tag,
          // se: tag
       ));
    }

}