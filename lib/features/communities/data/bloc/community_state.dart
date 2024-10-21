import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_enums.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';

part 'community_state.g.dart';

@CopyWith()
class CommunityState extends Equatable {

  final CommunityStatus status;
  final String message;
  final List<CommunityModel> communities;
  final CommunityModel? communityDetails;

  const CommunityState(  {
    this.status = CommunityStatus.initial,
    this.message = '',
    this.communityDetails,
    // this.suggestedCommunities = const [],
    // this.communityTags = const [],
    // this.selectedCommunityTag = const CommunityThreadTagsModel(name: 'All'),
    // this.activeCommunities = const [],
    // this.growingCommunities = const [],
    // this.proposedCommunities = const [],
    this.communities = const []
  });

  @override
  List<Object?> get props => [status];
}