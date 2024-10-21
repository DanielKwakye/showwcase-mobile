import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/features/refferals/data/models/invites_model.dart';
import 'package:showwcase_v3/features/refferals/data/repositories/invites_repository_impl.dart';

part 'invites_state.dart';

class InvitesCubit extends Cubit<InvitesState> {
  final InvitesRepository invitesRepository ;
  InvitesCubit({required this.invitesRepository}) : super(ReferralInitial());

  Future<void> sendInvites({required List<String> emails}) async {
    try {
      emit(ReferralLoading());
      final either = await invitesRepository.sendInvites(emails: emails);
      either.fold((l) {
       emit(ReferralError(error: l.errorDescription));
      }, (r) {
        emit(ReferralSuccess(invitesResponse: r));
      });
    } catch (e) {
      emit(ReferralError(error: e.toString()));
    }
  }
}
