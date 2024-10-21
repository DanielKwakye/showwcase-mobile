import 'package:showwcase_v3/features/communities/data/bloc/community_enums.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';

class CommunityBroadcastEvent {
  final CommunityBroadcastAction action;
  final CommunityModel? community;
  const CommunityBroadcastEvent({required this.action, this.community});
}