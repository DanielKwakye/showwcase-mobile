import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_state.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/commmunity_settings/community_invite.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/commmunity_settings/community_members.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/commmunity_settings/community_overview.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/commmunity_settings/community_role.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/commmunity_settings/community_welcome_screen.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/commmunity_settings/manage_tags.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';

class CommunitySettings extends StatefulWidget {
  final CommunityModel? communityModel;

  const CommunitySettings({super.key, required this.communityModel});

  @override
  State<CommunitySettings> createState() => _CommunitySettingsState();
}

class _CommunitySettingsState extends State<CommunitySettings> {
  late CommunityModel? communityModel;
  late CommunityCubit communityCubit;

  @override
  void initState() {
    communityModel = widget.communityModel;
    communityCubit = context.read<CommunityCubit>();
    communityCubit.fetchCommunityDetails(
        communitySlug: communityModel?.slug ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onBackground;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: theme.colorScheme.onBackground,
        ),
        elevation: 0.0,
        title: Text(
          'Community Settings',
          style: TextStyle(
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.w700,
              fontSize: defaultFontSize),
        ),
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(2), child: CustomBorderWidget()),
      ),
      body: BlocBuilder<CommunityCubit, CommunityState>(
        bloc: communityCubit,
        builder: (context, state) {
          //todo community
          // if (state.status == CommunityStatus.fetchCommunityDetailsInProgress) {
          //   return OverViewBody(
          //     communityModel: state.communityDetails,
          //     onEdit: () {
          //       communityCubit.fetchCommunityDetails(
          //           communitySlug: communityModel?.slug ?? '');
          //     },
          //   );
          // }
          return OverViewBody(
              communityModel: communityModel,
              onEdit: () {
                communityCubit.fetchCommunityDetails(
                    communitySlug: communityModel?.slug ?? '');
              });
        },
      ),
    );
  }
}

class OverViewBody extends StatelessWidget {
  const OverViewBody({
    super.key,
    required this.communityModel,
    required this.onEdit,
  });

  final CommunityModel? communityModel;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onBackground;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommunityOverview(
                              communityModel: communityModel,
                            ))).then((value) => onEdit());
              },
              leading: Icon(FeatherIcons.grid, color: color, size: 20),
              title: Text(
                'Overview',
                style: TextStyle(
                    color: color,
                    fontSize: defaultFontSize,),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageCommunityRole(
                              communityModel: communityModel,
                            ))).then((value) => onEdit());
              },
              leading: Icon(FeatherIcons.key, color: color, size: 20),
              title: Text(
                'Roles',
                style: TextStyle(
                    color: color,
                    fontSize: defaultFontSize,
                    ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommunityInvite(
                          communityModel: communityModel,
                        ))).then((value) => onEdit());
              },
              leading: Icon(FeatherIcons.userPlus, color: color, size: 20),
              title: Text(
                'Invite',
                style: TextStyle(
                    color: color,
                    fontSize: defaultFontSize,
                    ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageCommunityTags(
                              communityModel: communityModel,
                            ))).then((value) => onEdit());
              },
              leading: Icon(FeatherIcons.settings, color: color, size: 20),
              title: Text(
                'Manage Tags',
                style: TextStyle(
                    color: color,
                    fontSize: defaultFontSize,
                    ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommunityMembers(
                          communityModel: communityModel!,
                        ))).then((value) => onEdit());
              },
              leading: Icon(FeatherIcons.users, color: color, size: 20),
              title:  Text(
                'Members',
                style: TextStyle(
                    color: color,
                    fontSize: defaultFontSize,
                    ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommunityWelcomeScreen(
                              communitiesResponse: communityModel,
                            ))).then((value) => onEdit());
              },
              leading: SvgPicture.asset('assets/svg/welcome.svg',
                  color: color, height: 20),
              title: Text(
                'Welcome Screen',
                style: TextStyle(
                    color: color,
                    fontSize: defaultFontSize,
                    ),
              ),
            ),
            const SizedBox.shrink()
          ],
        )
      ],
    );
  }
}
