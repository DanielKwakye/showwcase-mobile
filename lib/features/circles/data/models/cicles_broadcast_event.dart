import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/circles/data/bloc/circles_enums.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class CirclesBroadCastEvent {
  final CirclesBroadcastAction action;
  final dynamic data;

  const CirclesBroadCastEvent({required this.action, this.data});
}