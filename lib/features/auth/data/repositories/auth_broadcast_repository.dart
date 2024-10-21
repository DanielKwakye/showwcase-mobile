import 'dart:async';

import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/models/auth_broadcast_event.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class AuthBroadcastRepository {

  final _authBroadcastController = StreamController<AuthBroadCastEvent>.broadcast();

  Stream<AuthBroadCastEvent> get authBroadcastStream => _authBroadcastController.stream;

  void updateUserProfile({required UserModel loggedInUser}) {
    _authBroadcastController.sink.add(AuthBroadCastEvent(action: AuthBroadcastAction.update, loggedInUser: loggedInUser));
  }
  
  void logout() {
    _authBroadcastController.sink.add(const AuthBroadCastEvent(action: AuthBroadcastAction.logout));
  }

}