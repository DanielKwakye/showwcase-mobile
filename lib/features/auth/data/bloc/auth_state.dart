import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/models/interest_model.dart';

part 'auth_state.g.dart';

@CopyWith()
class AuthState extends Equatable {
  final AuthStatus status;
  final String message;
  final dynamic extra;
  final GetStartedReason? getStartedReason;
  final List<InterestModel> interests;

  const AuthState({
    this.status = AuthStatus.initial,
    this.message = '',
    this.extra,
    this.getStartedReason,
    this.interests = const [],
  });

  @override
  List<Object?> get props => [status];

}