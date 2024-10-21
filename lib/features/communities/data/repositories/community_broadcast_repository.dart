import 'dart:async';

import 'package:showwcase_v3/features/communities/data/bloc/community_enums.dart';
import 'package:showwcase_v3/features/communities/data/models/community_broadcast_event.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';


class CommunityBroadcastRepository {

  final _controller = StreamController<CommunityBroadcastEvent>.broadcast();
  Stream<CommunityBroadcastEvent> get stream => _controller.stream;

  void updateCommunity({required CommunityModel updatedCommunity}) {
    _controller.sink.add(CommunityBroadcastEvent(action: CommunityBroadcastAction.updateCommunity, community: updatedCommunity));
  }


}