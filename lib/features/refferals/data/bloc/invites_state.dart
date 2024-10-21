part of 'invite_cubit.dart';

abstract class InvitesState extends Equatable {
  const InvitesState();
}

class ReferralInitial extends InvitesState {
  @override
  List<Object> get props => [];
}

class ReferralLoading extends InvitesState {
  @override
  List<Object> get props => [];
}

class ReferralSuccess extends InvitesState {
  final InviteResponse invitesResponse ;

 const  ReferralSuccess({required this.invitesResponse});
  @override
  List<Object> get props => [invitesResponse];
}

class ReferralError extends InvitesState {
  final String error ;

  const ReferralError({required this.error});
  @override
  List<Object> get props => [error];
}
