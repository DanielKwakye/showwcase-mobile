import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:showwcase_v3/features/shared/data/bloc/shared_enum.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_social_link_model.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_twitter_model.dart';

part 'shared_state.g.dart';

@CopyWith()
class SharedState {
  final SharedStatus status;
  final String message;
  final List<SharedSocialLinkIconModel> socialLinkIcons;
  final SharedTwitterModel? twitter;
  const SharedState({
    this.status = SharedStatus.initial,
    this.message = '',
    this.twitter,
    this.socialLinkIcons = const []
  });
}