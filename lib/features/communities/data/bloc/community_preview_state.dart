import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_enums.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_thread_tag.dart';

part 'community_preview_state.g.dart';

@CopyWith()
class CommunityPreviewState extends Equatable {

  final CommunityStatus status;
  final String message;
  final List<CommunityModel> communityPreviews;
  final Map<int, List<CommunityThreadTagsModel>> communityTags; // where the key is the community id
  final CommunityThreadTagsModel selectedCommunityTag;

  const CommunityPreviewState({
    this.status = CommunityStatus.initial,
    this.message = '',
    this.communityPreviews = const [],
    this.communityTags = const {},
    this.selectedCommunityTag = const CommunityThreadTagsModel(name: 'All',color: '#4595D0'),
  });

  @override
  List<Object?> get props => [status, communityTags, communityPreviews];

}