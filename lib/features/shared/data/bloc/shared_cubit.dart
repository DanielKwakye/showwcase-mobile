import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/shared/data/bloc/shared_enum.dart';
import 'package:showwcase_v3/features/shared/data/bloc/shared_state.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_link_preview_meta_model.dart';
import 'package:showwcase_v3/features/shared/data/repositories/shared_repository.dart';

class SharedCubit extends Cubit<SharedState>{

  final SharedRepository sharedRepository;
  SharedCubit({required this.sharedRepository}): super(const SharedState()) {
    fetchSocialLinkIcons();
  }

  void fetchSocialLinkIcons() async {

    try {

      emit(state.copyWith(status: SharedStatus.fetchSocialLinksInProgress,));

      if(state.socialLinkIcons.isNotEmpty) {
        emit(state.copyWith(status: SharedStatus.fetchSocialLinksSuccessful,));
      }

      emit(state.copyWith(

      ));
      final either = await sharedRepository.fetchSocialLinkIcons();
      either.fold((l) => emit(state.copyWith(status: SharedStatus.fetchSocialsLinksFailed, message: l.errorDescription)),
              (r) {

                emit(state.copyWith(status: SharedStatus.fetchSocialLinksInProgress,));
                emit(state.copyWith(status: SharedStatus.fetchSocialLinksSuccessful, socialLinkIcons: r));

              });
    } catch (e) {

      emit(state.copyWith(status: SharedStatus.fetchSocialsLinksFailed, message: e.toString()));

    }
  }

  void fetchTwitterBlock({required String tweetId}) async {
    try{
      emit(state.copyWith(
          status: SharedStatus.fetchingTwitterBlockInProgress
      ));

      final either = await sharedRepository.fetchTwitterDetails(tweetId: tweetId);
      either.fold(
              (l) => emit(state.copyWith(
              status: SharedStatus.fetchingTwitterBlockFailed
          )),
              (r) => emit(state.copyWith(
              status: SharedStatus.fetchingTwitterBlockSuccessful,
              twitter: r
          ))
      );

    }catch(e){
      emit(state.copyWith(
          status: SharedStatus.fetchingTwitterBlockFailed,
          message: e.toString()
      ));
    }
  }

  Future<SharedLinkPreviewMetaModel?> fetchPreviewMetaDataFromUrl({required String url}) async {
    try {

      emit(state.copyWith(status: SharedStatus.fetchPreviewMetaDataFromUrlInProgress,));

      final either = await sharedRepository.fetchPreviewMetaDataFromUrl(url: url);

      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: SharedStatus.fetchPreviewMetaDataFromUrlFailed, message: l.errorDescription,));
        return null;
      }

      // successful
      final r = either.asRight();
      emit(state.copyWith(status: SharedStatus.fetchPreviewMetaDataFromUrlSuccessful));
      return r;

    } catch (e) {
      debugPrint("customLog: ${e.toString()}");
      emit(state.copyWith(status: SharedStatus.fetchPreviewMetaDataFromUrlFailed, message: e.toString(),));
      return null;
    }
  }


}