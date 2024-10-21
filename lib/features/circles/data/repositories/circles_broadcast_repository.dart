import 'dart:async';

import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/models/auth_broadcast_event.dart';
import 'package:showwcase_v3/features/circles/data/bloc/circles_enums.dart';
import 'package:showwcase_v3/features/circles/data/models/cicles_broadcast_event.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class CirclesBroadcastRepository {

  final _circlesBroadcastController = StreamController<CirclesBroadCastEvent>.broadcast();

  Stream<CirclesBroadCastEvent> get circlesBroadcastStream => _circlesBroadcastController.stream;

  void circleRequestAccepted({required UserModel user}) {
    _circlesBroadcastController.sink.add(CirclesBroadCastEvent(action: CirclesBroadcastAction.circleRequestAccepted, data: user));
  }

  void circleRequestDeclined({required UserModel user}) {
    _circlesBroadcastController.sink.add(CirclesBroadCastEvent(action: CirclesBroadcastAction.circleRequestRejected, data: user));
  }


}