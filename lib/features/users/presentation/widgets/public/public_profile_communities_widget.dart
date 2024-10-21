import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/community_item_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class PublicProfileCommunitiesWidget extends StatelessWidget {
  final UserModel userModel;

  const PublicProfileCommunitiesWidget({Key? key, required this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocSelector<UserProfileCubit, UserProfileState,
        List<CommunityModel>?>(
      selector: (userState) {
        final userProfiles = userState.userProfiles;
        final index = userProfiles
            .indexWhere((element) => element.username == userModel.username);
        if (index < 0) {
          return null;
        }
        return userProfiles[index].featuredCommunities;
      },
      builder: (context, featuredCommunities) {
        if ((featuredCommunities ?? []).isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            const Row(
              children: [
                Text(
                  'Member of',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            if ((featuredCommunities ?? []).isEmpty) ...{
              const SizedBox.shrink()
            } else ...{
              const SizedBox(
                height: 15,
              ),
              ListView.separated(
                separatorBuilder: (_, index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: featuredCommunities!.length,
                itemBuilder: (context, index) {
                  final community = featuredCommunities[index];
                  return CommunityItemWidget(
                    community: community,
                    onTap: () {
                      context.push(
                          context.generateRoutePath(
                              subLocation: communityPreviewPage),
                          extra: community);
                    },
                    showJoinedAction: false,
                    pageName: 'profile_communities',
                    containerName: 'profile_communities'
                  );
                },
              )
            }
          ],
        );
      },
    );
  }
}
