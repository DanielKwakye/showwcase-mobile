import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/analytics/data/service/analytics_service.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_enums.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
class CommunityItemWidget extends StatefulWidget {

  final CommunityModel community;
  final bool showJoinedAction;
  final Function() onTap;
  final String containerName;
  final String pageName;
  CommunityItemWidget({Key? key, required this.community, this.showJoinedAction = true, required this.onTap, required this.containerName, required this.pageName}) : super(key: key ?? ValueKey(community.id));

  @override
  State<CommunityItemWidget> createState() => _CommunityItemWidgetState();
}

class _CommunityItemWidgetState extends State<CommunityItemWidget> {

  @override
  void initState() {
    AnalyticsService.instance.sendEventCommunityImpression(communityModel: widget.community,containerName: widget.containerName,pageName: widget.pageName );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String icon = '';
    try{
      icon = widget.community.pictureUrl ?? '';
      //getProjectImage(Uri.decodeFull(community.pictureUrl ?? ''));
    }catch(e) {
      debugPrint("customLog: ${e.toString()}");
    }

    return ListTile(
        contentPadding:  EdgeInsets.symmetric(vertical: widget.community.description.isNullOrEmpty() ? 0 : 5, horizontal: 0),
        onTap: () {
          widget.onTap.call();
        },
        dense: true,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(5),
                color: theme.colorScheme.outline
            ),
            padding: const EdgeInsets.all(0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl:  icon,
                errorWidget: (context, url, error) =>
                    _fallbackIcon(context, widget.community.name ?? 'Communities'),
                placeholder: (ctx, url) =>
                    _fallbackIcon(context, widget.community.name ?? 'Communities'),
                cacheKey: widget.community.pictureKey,
                fit: BoxFit.cover,
                maxHeightDiskCache: 40,
              ),
            ),

            // ,
          ),
        ),
        title: Text('${widget.community.name}',
            style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontWeight: FontWeight.w600,
                fontSize: 14)),
        subtitle:   SeparatedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 5,);
          },
          children: [
            if(!widget.community.description.isNullOrEmpty()) ... {
              Text(
                widget.community.description ?? '',
                style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            },
            if((widget.community.totalMembers ?? 0) > 0) ... {
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(kMembersIconSvg),
                  const SizedBox(width: 5,),
                  Text(widget.community.totalMembers.toString(),
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  )
                ],
              )
            }
          ],
        ),
        trailing: !widget.showJoinedAction ? null : (widget.community.isMember ?? widget.community.isMember ?? false) ? CustomButtonWidget(
          text: 'Joined',
          appearance: Appearance.secondary,
          icon: const Icon(Icons.check, size: 12, color: kAppBlue),
          backgroundColor: kAppBlue.withOpacity(0.2),
          textColor: kAppBlue,
          onPressed: () {
            if(widget.community.id == null){
              return;
            }
            context.read<CommunityCubit>().joinLeaveCommunity(communityModel: widget.community, action: CommunityJoinLeaveAction.leave);
          },
        ): CustomButtonWidget(
          text: 'Join',
          appearance: Appearance.primary,
          onPressed: () {
            if(widget.community.id == null){
              return;
            }
            context.read<CommunityCubit>().joinLeaveCommunity(communityModel: widget.community, action: CommunityJoinLeaveAction.join);
          },
        )

    );
  }

  Widget _fallbackIcon(BuildContext context, String name){
    return Center(child: Text(getInitials(name.toUpperCase()), textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.onBackground,fontSize: 10),));
  }
}
