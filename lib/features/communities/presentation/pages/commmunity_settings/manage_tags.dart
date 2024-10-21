import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_admin_cubit.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_thread_tag.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/commmunity_settings/add_tag.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/commmunity_settings/edit_tags.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_app_shimmer.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';


class ManageCommunityTags extends StatefulWidget {
  final CommunityModel? communityModel;

  const ManageCommunityTags({super.key, required this.communityModel});

  @override
  State<ManageCommunityTags> createState() => _ManageCommunityTagsState();
}

class _ManageCommunityTagsState extends State<ManageCommunityTags> {
  late CommunityAdminCubit communityAdminCubit;

  @override
  void initState() {
    communityAdminCubit = context.read<CommunityAdminCubit>();
    communityAdminCubit.fetchCommunityTags(
        slug: widget.communityModel!.slug!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: theme.colorScheme.onBackground,
        ),
        elevation: 0.0,
        title: Text(
          'Manage Tags',
          style: TextStyle(
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.w700,
              fontSize: defaultFontSize),
        ),
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(2), child: CustomBorderWidget()),
      ),
      body: BlocConsumer<CommunityAdminCubit, CommunityAdminState>(
        bloc: communityAdminCubit,
        buildWhen: (previous, current) {
          if (current is CommunityTagsLoading ||
              current is CommunityTagsSuccess ||
              current is CommunityTagsError) {
            return true;
          }
          return false;
        },
        listener: (context, state) {
          if (state is UpdateFeedsTagsLoading) {
          }
          if (state is UpdateFeedsTagsSuccess) {
            context.showSnackBar('Tag Deleted successfully');
          }
          if (state is UpdateFeedsTagsError) {
            context.showSnackBar(state.apiError.errorDescription.toString(), appearance: Appearance.error);
          }
        },
          builder: (context, state) {
          if (state is CommunityTagsLoading) {
            return const CustomAppShimmer(
              repeat: 20,
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
            );
          }
          if (state is CommunityTagsSuccess) {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding:  EdgeInsets.zero,
                  itemCount: state.communityTags.length,
                  itemBuilder: (BuildContext context, int index) {
                    Color color = Color(int.parse('0xff${state.communityTags[index].color?.substring(1)}'));
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        communitiesAction(context: context, theme: theme, communityTags: state.communityTags, index: index);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            child: Text(
                              '${state.communityTags[index].name}',
                              style: TextStyle(
                                  color: color, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Icon(Icons.edit_outlined,
                              size: 20, color: theme.colorScheme.onPrimary)
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                ),
                const SizedBox(height: 20,),
                CustomButtonWidget(
                  text: 'Add Tags',
                  expand: true,
                  icon: Icon(
                    Icons.add,
                    color: theme.colorScheme.onBackground,
                  ),
                  backgroundColor: theme.brightness == Brightness.dark
                      ? const Color(0xff202021)
                      : const Color(0xffF7F7F7),
                  outlineColor: Colors.transparent,
                  appearance: Appearance.clean,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommunityAddTag(
                              communityModel:
                              widget.communityModel,
                              communityTags: const [],
                            ))).then((value) => (){
                      communityAdminCubit.fetchCommunityTags(
                          slug: widget.communityModel!.slug!);
                    });
                  },
                ),
              ],
            );
          }
          if (state is CommunityTagsError) {}
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void communitiesAction(
      {required BuildContext context,
      required ThemeData theme,
      List<CommunityThreadTagsModel>? communityTags,
      required int index}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          bottom: true,
          child: SizedBox(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 4,
                    width: 44,
                    decoration: BoxDecoration(
                        color: theme.colorScheme.onBackground.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditCommunityTags(
                                    communityModel:
                                        widget.communityModel,
                                    communityTags: communityTags,
                                    index: index,
                                  )));
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: theme.colorScheme.onBackground,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Edit Tags',
                          style: TextStyle(
                              color: theme.colorScheme.onBackground,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.pop(context);
                      communityTags?.removeAt(index);
                      communityAdminCubit.updateFeedsTag(communityTags: communityTags ?? [], communityId: widget.communityModel!.id!);
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/delete.svg',
                          color: theme.colorScheme.onBackground,
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Delete Tags',
                          style: TextStyle(
                              color: theme.colorScheme.onBackground,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
