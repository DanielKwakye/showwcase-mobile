import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/features/circles/data/bloc/circles_enums.dart';
import 'package:showwcase_v3/features/circles/data/bloc/circles_state.dart';
import 'package:showwcase_v3/features/circles/data/models/send_circle_model.dart';
import 'package:showwcase_v3/features/circles/data/repositories/circles_broadcast_repository.dart';
import 'package:showwcase_v3/features/circles/data/repositories/circles_repository.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class CirclesCubit extends Cubit<CirclesState> {
  final CirclesRepository circlesRepository;
  final CirclesBroadcastRepository circlesBroadcastRepository;

  CirclesCubit({required this.circlesRepository, required this.circlesBroadcastRepository}) : super(const CirclesState());

  void fetchReasons() async {
    try {
      emit(state.copyWith(status: CircleStatus.fetchCircleReasonsInProgress));
      final either = await circlesRepository.fetchCircleReasons();
      either.fold(
          (l) => emit(state.copyWith(
              status: CircleStatus.fetchCircleReasonsFailed,
              message: l.errorDescription)),
          (r) => emit(state.copyWith(reasons: r)));
    } catch (e) {
      emit(state.copyWith(
          status: CircleStatus.fetchCircleReasonsFailed,
          message: e.toString()));
    }
  }

  void sendCircleInvite(
      {required SendCircleModel sendCircleRequest,
      bool? isUpdate = false}) async {
    try {
      emit(state.copyWith(status: CircleStatus.sendCircleInviteInProgress));
      final either = await circlesRepository.sendCircleInvite(
          sendCircleRequest: sendCircleRequest, isUpdate: isUpdate);
      either.fold(
          (l) => emit(state.copyWith(
              status: CircleStatus.sendCircleInviteFailed,
              message: l.errorDescription)),
          (r) => emit(state.copyWith(status: CircleStatus.sendCircleInviteCompleted,)));
    } catch (e) {
      emit(state.copyWith(
          status: CircleStatus.sendCircleInviteFailed, message: e.toString()));
    }
  }

  void handleCircleInvite(UserModel user, {int? userId, required CirclesBroadcastAction circleAction}) async {
    try {
      emit(state.copyWith(status: CircleStatus.handleCircleInviteInProgress));
      String action = circleAction == CirclesBroadcastAction.circleRequestAccepted ? 'accept' : 'decline';
      
      final either = await circlesRepository.handleCircleInvite(action: action, userId: userId);
      either.fold(
          (l) => emit(state.copyWith(
              status: CircleStatus.handleCircleInviteFailed,
              message: l.errorDescription)),
          (r) {

            // you can use the circlesBroadcastRepository to emit to userProfileCubit
            if(circleAction == CirclesBroadcastAction.circleRequestAccepted) {
              circlesBroadcastRepository.circleRequestAccepted(user: user.copyWith(
                  isColleague: 'active'
              ));
            }else {
              circlesBroadcastRepository.circleRequestDeclined(user: user.copyWith(
                  isColleague: 'declined'
              ));
            }

            emit(
              state.copyWith(status: CircleStatus.handleCircleInviteCompleted,
                data: circleAction
              ));
          });
    } catch (e) {
      emit(state.copyWith(
          status: CircleStatus.handleCircleInviteFailed, message: e.toString()));
    }
  }
}
