import 'dart:async';

import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class UserBroadcastRepository {

  final _controller = StreamController<UserModel>.broadcast();
  Stream<UserModel> get stream => _controller.stream;

  void updateUser({required UserModel user}) {
    _controller.sink.add(user);
  }

}