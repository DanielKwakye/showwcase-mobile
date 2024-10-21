import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class AuthBroadCastEvent {
  final AuthBroadcastAction action;
  final UserModel? loggedInUser;

  const AuthBroadCastEvent({required this.action, this.loggedInUser});
}