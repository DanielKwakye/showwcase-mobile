import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_enums.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part "users_state.g.dart";

@CopyWith()
class UsersState extends Equatable {

  final UserStatus status;
  final String message;

  final  List<UserModel> users; // users subclassing UserCubit can use this state for keeping infinite user list
  // where the String key is the username of the user of interest // key defaults to currentLoggedInUser

  const UsersState( {
    this.status = UserStatus.initial,
    this.message = '',
    this.users = const [],
  });

  @override
  List<Object?> get props => [status, users];

}