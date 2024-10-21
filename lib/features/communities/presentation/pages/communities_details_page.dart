import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/community_members_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';


class CommunitiesDetailsPage extends StatefulWidget {

  final CommunityModel communityModel ;

  const CommunitiesDetailsPage({Key? key, required this.communityModel}) : super(key: key);

  @override
  State<CommunitiesDetailsPage> createState() => _CommunitiesDetailsPageState();
}

class _CommunitiesDetailsPageState extends State<CommunitiesDetailsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
      final theme = Theme.of(context);
    return SafeArea(
      bottom: true,
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const CustomInnerPageSliverAppBar(pageTitle: "Community Details",),
             const SliverToBoxAdapter(
                child:  SizedBox(
                  height: 20,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),

                  child: Text(
                    widget.communityModel.name ?? '',
                    style: TextStyle(
                        color: theme.colorScheme.onBackground,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child:  SizedBox(
                  height: 8,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    '${widget.communityModel.description} \n\n${widget.communityModel.about ?? ''}',
                    style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              if (widget.communityModel.tags!.isNotEmpty)...{
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 30,
                  ),
                ),
                SliverToBoxAdapter(child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Tags',
                    style: TextStyle(
                        color: theme.colorScheme.onBackground,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ),)
              },
              const SliverToBoxAdapter(child: SizedBox(
                height: 8,
              ),),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 10.0,
                    children: List.generate(widget.communityModel.tags!.length, (index) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                          color: theme.colorScheme.outline,
                          borderRadius: BorderRadius.circular(4)),
                      child:  Text(
                        widget.communityModel.tags![index].tagDescription!,
                        style: const TextStyle(
                            color: kAppGray,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ) ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child:  SizedBox(
                  height: 10,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Members',
                    style: TextStyle(
                        color: theme.colorScheme.onBackground,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: CustomBorderWidget(bottom: 15, top: 15,),),
            CommunityMembersWidget(communityModel: widget.communityModel,)

         ]
          //, body: CommunityMembersList(communityId: widget.communityModel.id!,scrollController: _scrollController,),
        )

      ),
    );
  }
}
