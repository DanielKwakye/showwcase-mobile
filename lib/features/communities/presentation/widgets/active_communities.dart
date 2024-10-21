import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/communities/data/bloc/active_communities_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_enums.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_state.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/community_item_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_app_shimmer.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';

class ActiveCommunities extends StatefulWidget {
  const ActiveCommunities({Key? key}) : super(key: key);

  @override
  State<ActiveCommunities> createState() => _ActiveCommunitiesState();
}

class _ActiveCommunitiesState extends State<ActiveCommunities>
    with AutomaticKeepAliveClientMixin<ActiveCommunities> {
  late ActiveCommunitiesCubit _communitiesListCubit;

  @override
  void initState() {
    super.initState();
    _communitiesListCubit = context.read<ActiveCommunitiesCubit>();
    _communitiesListCubit.fetchActiveCommunities(pageKey: 0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    return Container(
      width: media.size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 11,
          ),
          Text(
            'Most Active Communities',
            style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 11,
          ),
          BlocBuilder<ActiveCommunitiesCubit, CommunityState>(
            buildWhen: (previous, current) {
              return current.status ==
                      CommunityStatus.fetchCommunitiesSuccessful ||
                  current.status == CommunityStatus.fetchCommunitiesFailed;
            },
            builder: (context, state) {
              if (state.status == CommunityStatus.fetchCommunitiesInProgress) {
                return const CustomAppShimmer(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                );
              }
              if (state.status == CommunityStatus.fetchCommunitiesSuccessful) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.separated(
                      itemCount: state.communities.length,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final item = state.communities[index];
                        return BlocSelector<ActiveCommunitiesCubit,
                            CommunityState, CommunityModel>(
                          selector: (state) {
                            return state.communities
                                .firstWhere((element) => element.id == item.id);
                          },
                          builder: (context, community) {
                            return CommunityItemWidget(
                              community: community,
                              onTap: () {
                                context.push(
                                    context.generateRoutePath(
                                        subLocation: communityPreviewPage),
                                    extra: community);
                              },
                              pageName: 'active_community',
                              containerName: 'main',
                            );
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const CustomBorderWidget();
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        // context.router.push(const SeeMoreProposedCommunitiesRoute());
                        context.push(context.generateRoutePath(
                            subLocation: seeMoreActiveCommunities));
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.only(top: 15, bottom: 15, right: 20),
                        child: Text(
                          'See More',
                          style: TextStyle(
                              color: kAppBlue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                );
              }
              // if(state is FetchActiveCommunitiesError){}
              return const SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
