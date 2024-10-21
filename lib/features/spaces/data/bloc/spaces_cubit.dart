import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/spaces/data/bloc/spaces_enums.dart';
import 'package:showwcase_v3/features/spaces/data/bloc/spaces_state.dart';
import 'package:showwcase_v3/features/spaces/data/models/space_model.dart';
import 'package:showwcase_v3/features/spaces/data/repositories/spaces_repository.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class SpacesCubit extends Cubit<SpacesState> {

  final SpacesRepository spacesRepository;
  SpacesCubit({required this.spacesRepository}) : super(const SpacesState());

  void createNewSpace({required String title}) async {

    try {
      emit(state.copyWith(status: SpacesStatus.createNewSpaceInProgress));
      final either = await spacesRepository.createNewSpace(title: title);
      if(either.isLeft()) {
        final l = either.asLeft();
        emit(state.copyWith(status: SpacesStatus.createNewSpaceFailed, message: l.errorDescription));
        return;
      }

      //! created
      emit(state.copyWith(status: SpacesStatus.createNewSpaceSuccessful));


    }catch(e) {
      emit(state.copyWith(status: SpacesStatus.createNewSpaceFailed, message: e.toString()));
    }

  }

  void fetchOngoingSpaces() async {

    try{
      emit(state.copyWith(status: SpacesStatus.fetchOngoingSpacesInProgress));
      final either = await spacesRepository.fetchOngoingSpaces();
      if(either.isLeft()) {
        final l = either.asLeft();
        emit(state.copyWith(status: SpacesStatus.fetchOngoingSpacesFailed, message: l.errorDescription));
        return;
      }

      final stream = either.asRight();
      stream.listen((event) {


        final docs = event.docs;

        final ongoingSpaces = [...state.ongoingSpaces];
        for (final doc in docs) {
          Map<String, dynamic> data = doc.data();
          final creator = UserModel.fromJson(data['creator'] as Map<String, dynamic>);
          final title = data['title'] as String;
          final id = doc.id;
          final indexFound = ongoingSpaces.indexWhere((element) => element.id == id);
          if(indexFound > -1) {
            continue;
          }
          ongoingSpaces.insert(0, SpaceModel(id: id, title: title, creator: creator));
        }


        emit(state.copyWith(status: SpacesStatus.fetchOngoingSpacesRefreshing));
        emit(state.copyWith(status: SpacesStatus.fetchOngoingSpacesRefreshed,
            ongoingSpaces: ongoingSpaces
        ));

      });

    }catch(e){
      emit(state.copyWith(status: SpacesStatus.fetchOngoingSpacesFailed, message: e.toString()));
    }
  }

  void closeSpace({required SpaceModel spaceModel,  required RTCVideoRenderer localVideo}) {
    spacesRepository.hangUp(spaceId: spaceModel.id, localVideo: localVideo);
  }


  void joinSpace({required SpaceModel spaceModel, required RTCVideoRenderer remoteVideo}) async {
    spacesRepository.joinSpace(spaceId: spaceModel.id, remoteVideo: remoteVideo);
  }

}