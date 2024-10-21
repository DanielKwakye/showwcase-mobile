import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_enums.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_preview_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_preview_state.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_thread_tag.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/community_thread_tag_item.dart';

class CommunityThreadTagsWidget extends StatefulWidget {

  final CommunityModel communityModel;
  const CommunityThreadTagsWidget({Key? key, required this.communityModel}) : super(key: key);

  @override
  State<CommunityThreadTagsWidget> createState() => _CommunityThreadTagsWidgetState();
}

class _CommunityThreadTagsWidgetState extends State<CommunityThreadTagsWidget> {


  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 5.0,
        ),
        child: Container(
          decoration: BoxDecoration(
              color: theme.colorScheme.background.withAlpha(200),),
          child: Column(
              mainAxisSize: MainAxisSize.min,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 /// Loading tags --------
                 BlocBuilder<CommunityPreviewCubit, CommunityPreviewState>(
                   builder: (context, communityPreviewState) {
                     if(communityPreviewState.status == CommunityStatus.fetchCommunityTagsInProgress){
                       return SingleChildScrollView(
                         scrollDirection: Axis.horizontal,
                         child: Row(
                           children: List<int>.filled(9, 0, growable: false)
                               .map((e) => Shimmer.fromColors(
                             baseColor: theme.colorScheme.outline,
                             highlightColor: theme.colorScheme.outline.withOpacity(0.3),
                             child: Container(
                               width: 80,
                               margin: const EdgeInsets.symmetric(
                                   horizontal: 5, vertical: 10),
                               decoration: BoxDecoration(
                                   color: theme.colorScheme.outline,
                                   borderRadius: BorderRadius.circular(4)),
                             ),
                           )).toList(),
                         ),
                       );
                     }
                     return const SizedBox.shrink();
                   },
                 ),

                 /// When community tags are ready ----
                 BlocSelector<CommunityPreviewCubit, CommunityPreviewState, List<CommunityThreadTagsModel>>(
                   selector: (communityPreviewState) {
                     return communityPreviewState.communityTags[widget.communityModel.id] ?? [];
                   },
                   builder: (context, communityTags) {

                     if(communityTags.isEmpty ) {
                       return const SizedBox.shrink();
                     }

                     return SingleChildScrollView(
                       scrollDirection: Axis.horizontal,
                       child: Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                         child: BlocBuilder<CommunityPreviewCubit, CommunityPreviewState>(
                           buildWhen: (_, next) {
                             return next.status == CommunityStatus.selectCommunityThreadTagCompleted ||
                                 next.status == CommunityStatus.selectCommunityThreadTagInProgress;
                           },
                           builder: (context, comPrevState) {
                             return Row(
                               children: communityTags.map((tag) {

                                 return CommunityCategoryItemWidget(
                                   communityTag: tag,
                                   selected: checksEqual(comPrevState.selectedCommunityTag.name! , tag.name!),
                                   onCategoryTapped: (category) {
                                     context.read<CommunityPreviewCubit>().selectCommunityThreadTag(category);
                                     print(category.name);
                                   },
                                 );
                               }).toList(),
                             );
                           },
                         )


                       ),
                     );
                   },
                 ),
               ],
          )

        ),
      ),
    );
  }
}
