import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_admin_cubit.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_update_request.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_social_link_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/social_link_list_widget.dart';

class CommunitySocialLinks extends StatefulWidget {
  final CommunityModel? communityModel;

  const CommunitySocialLinks(
      {super.key, required this.communityModel});

  @override
  State<CommunitySocialLinks> createState() => _CommunitySocialLinksState();
}

class _CommunitySocialLinksState extends State<CommunitySocialLinks> {
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  late CommunityAdminCubit communityAdminCubit;
  List<Map<String, dynamic>> companyLinks = [];
  late List<Map<String, dynamic>> socialLinksList;

  @override
  void initState() {
    communityAdminCubit = context.read<CommunityAdminCubit>();
    socialLinksList =  [];
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
          'Social Links',
          style: TextStyle(
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.w700,
              fontSize: defaultFontSize),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: _isLoading,
            builder: (BuildContext context, bool value, Widget? child) {
              return value
                  ? const Center(
                      child: Row(
                      children: [
                        SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator.adaptive(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(kAppBlue),
                              strokeWidth: 1,
                            )),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ))
                  : TextButton(
                      onPressed: () {
                        communityAdminCubit.updateCommunityDetails(
                            updateCommunitiesRequest: UpdateCommunitiesModel(
                              about: widget.communityModel?.about,
                              category:
                                  widget.communityModel?.category,
                              categoryId:
                                  widget.communityModel?.category?.id,
                              coverImageKey:
                                  widget.communityModel!.coverImageKey,
                              description:
                                  widget.communityModel?.description,
                              coverImageKeyRemote:
                                  widget.communityModel!.coverImageKey,
                              pictureKey:
                                  widget.communityModel?.pictureKey,
                              pictureKeyRemote:
                                  widget.communityModel!.pictureKey,
                              name: widget.communityModel?.name,
                              socials: socialLinksList,
                            ),
                            communityId: widget.communityModel!.id!);
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                            color: kAppBlue,
                            fontSize: defaultFontSize,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ));
            },
          ),
        ],
      ),
      body: BlocListener<CommunityAdminCubit, CommunityAdminState>(
        bloc: communityAdminCubit,
        listener: (context, state) {
          if (state is UpdateCommunityLoading) {
            _isLoading.value = true;
          }

          if (state is UpdateCommunitySuccess) {
            _isLoading.value = false;
            context.showSnackBar('Socials Updated Successfully');
          }
          if (state is UpdateCommunityError) {
            _isLoading.value = false;
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SocialLinkListWidget(listener: _onCompanyLinksUpdatedListener,showTooltip: false),
        ),
      ),
    );
  }

  _onCompanyLinksUpdatedListener(List<Map<String, dynamic>> updatedValues) {
    companyLinks = updatedValues;
    socialLinksList = companyLinks.where((element) => element['link'] != "").map((e) {
      final socialLinkIconModel = e["icon"] as SharedSocialLinkIconModel;
      return {
        "id": -1,
        "name": socialLinkIconModel.name,
        "value": e["link"],
      };
    }).toList();
    // List<CommunityLinkModel> optimizedLinks = companyLinks.expand((element) {
    //   return element.entries.map((entry) {
    //     final key = entry.key;
    //     final value = entry.value;
    //     final icon = value['icon'] as SharedSocialLinkIconModel;
    //     return CommunityLinkModel(name: icon.name, value: value['link'], id: -1);
    //   });
    // }).toList();
    // socialLinks.value = optimizedLinks;
  }
}
