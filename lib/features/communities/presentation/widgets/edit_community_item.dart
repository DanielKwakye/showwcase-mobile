import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_enums.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/commmunity_settings/edit_community_info.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';

class EditCommunityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool shouldOpenNewPage;
  final VoidCallback? onUpdated;
  final CommunityModel? communityModel;
  final CommunityUpdateType infoType;

  const EditCommunityItem({super.key, required this.title, required this.subtitle, required this.shouldOpenNewPage, this.onUpdated, required this.communityModel, required this.infoType});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (shouldOpenNewPage) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditCommunityInfo(communityModel: communityModel,infoType: infoType),settings: RouteSettings(arguments: {'page_title':'edit_community_info','page_id': AppStorage.currentUserSession!.id}),)).then((value) {
            onUpdated!();
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomBorderWidget(),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex:2,
                  child: Text(title,
                      style: TextStyle(
                          color: theme(context).colorScheme.onBackground,
                          fontSize: defaultFontSize,
                          fontWeight: FontWeight.w700)),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          subtitle,
                          style: TextStyle(
                              color: !shouldOpenNewPage ? theme(context).colorScheme.onPrimary : theme(context).colorScheme.onBackground,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(width: 15,),
                      if(shouldOpenNewPage) Icon(Icons.arrow_forward_ios,size: 10,color: theme(context).colorScheme.onPrimary),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          //const CustomBorderWidget(),
        ],
      ),
    ) ;
  }
}
