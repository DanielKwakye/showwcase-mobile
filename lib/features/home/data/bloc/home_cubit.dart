import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_enums.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_state.dart';


// This cubit basically helps with communication between home scaffold and its children
// For better UX gestures
class HomeCubit extends Cubit<HomeState> {

  HomeCubit(): super(const HomeState());



  /// when an already active index is tapped
  onActiveIndexTapped(int index){
    emit(state.copyWith(status: HomeStatus.onActiveIndexTappedInProgress));
    emit(state.copyWith(
        status: HomeStatus.onActiveIndexTappedCompleted,
        data: index
    ));
  }

  /// when a page within a scaffold is scrolling
  onPageScroll(PageScrollDirection direction){
    emit(state.copyWith(status: HomeStatus.onPageScrollInProgress));
    emit(state.copyWith(status: HomeStatus.onPageScrollCompleted,
      data: direction
    ));
  }

  /// show page loading
  //! parameters: { attachImage: File? , attachVideo: bool?, progress: double? };
  enablePageLoad({Map<String, dynamic> parameters = const {}}){
    emit(state.copyWith(status: HomeStatus.enablePageLoadInProgress));
    emit(state.copyWith(status: HomeStatus.enablePageLoad, data: parameters));
  }

  dismissPageLoad(){
    emit(state.copyWith(status: HomeStatus.dismissPageLoadInProgress));
    emit(state.copyWith(status: HomeStatus.dismissPageLoad));
  }

  redirectLinkToPage({required String url, required String fallBackRoutePath, required dynamic fallBackRoutePathData, bool hideLoader = false}){
    emit(state.copyWith(status: HomeStatus.redirectLinkToPageInProgress));
    emit(state.copyWith(status: HomeStatus.redirectLinkToPageRequested,
      data: {
          "url": url,
          "fallBackRoutePath": fallBackRoutePath,
          "fallBackRoutePathData": fallBackRoutePathData,
          "hideLoader": hideLoader
      }
    ));
  }

  requestSystemOverlayUpdate({Brightness? brightness}){
    emit(state.copyWith(status: HomeStatus.requestSystemOverlayUpdateInProgress));
    emit(state.copyWith(status: HomeStatus.requestSystemOverlayUpdateCompleted, data: brightness));
  }


}