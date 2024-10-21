import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_admin_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_enums.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_state.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_update_welcome_screen.dart';
import 'package:showwcase_v3/features/communities/data/models/welcome_screen_response.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/commmunity_settings/edit_welcome_screen.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';

class CommunityWelcomeScreen extends StatefulWidget {
  final CommunityModel? communitiesResponse;

  const CommunityWelcomeScreen({super.key, required this.communitiesResponse});

  @override
  State<CommunityWelcomeScreen> createState() => _CommunityWelcomeScreenState();
}

class _CommunityWelcomeScreenState extends State<CommunityWelcomeScreen> {
  late ValueNotifier<CommunityModel?> communitiesResponse;

  List<WelcomeScreenResponse> welcomeScreenResponse = [];
  late ValueNotifier<bool> _isWelcomeScreenEnabled;
  late CommunityAdminCubit communityAdminCubit;
  late CommunityCubit communityCubit;
  late String _welcomeText;

  @override
  void initState() {
    communityAdminCubit = context.read<CommunityAdminCubit>();
    communityCubit = context.read<CommunityCubit>();
    communitiesResponse = ValueNotifier(widget.communitiesResponse);
    communityCubit.fetchCommunityDetails(
        communitySlug: communitiesResponse.value?.slug ?? '');
    seedList(widget.communitiesResponse!);
    super.initState();
  }

  void seedList(CommunityModel communityModel) {
    _isWelcomeScreenEnabled =
        ValueNotifier<bool>(communityModel.enableWelcomeScreen ?? false);
    if (communityModel.welcomeScreen != null) {
      welcomeScreenResponse = List<WelcomeScreenResponse>.from(
          jsonDecode(communityModel.welcomeScreen!)
              .map((x) => WelcomeScreenResponse.fromJson(x)));
    } else {
      _welcomeText =
          "[{\"sectionName\":{\"emoji\":\"🐝\",\"title\":\"About this community\"},\"description\":\"Lorem Ipsum is simply dummy text of the printing and typesetting industry.\"},{\"sectionName\":{\"emoji\":\"🐝\",\"title\":\"Rules of the community\"},\"description\":\"Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.\"},{\"sectionName\":{\"emoji\":\"🐝\",\"title\":\"How you can make the most of this community\"},\"description\":\"It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\"}]";
      welcomeScreenResponse = List<WelcomeScreenResponse>.from(
          jsonDecode(_welcomeText)
              .map((x) => WelcomeScreenResponse.fromJson(x)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: theme.colorScheme.onBackground,
          ),
          elevation: 0.0,
          title: Text(
            'Welcome Screen',
            style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontWeight: FontWeight.w700,
                fontSize: defaultFontSize),
          ),
          bottom: const PreferredSize(
              preferredSize: Size.fromHeight(2), child: CustomBorderWidget()),
        ),
        body: BlocListener<CommunityCubit, CommunityState>(
          bloc: communityCubit,
          listener: (context, state) {
            if (state.status ==
                CommunityStatus.fetchCommunityDetailsInProgress) {}
            //todo community
            // if(state.status == CommunityStatus.fetchCommunityDetailsSuccessful){
            //   communitiesResponse.value = state.communityDetails ;
            //   _isWelcomeScreenEnabled.value = communitiesResponse.value!.enableWelcomeScreen! ;
            //   seedList(state.communityDetails);
            //   setState(() {});
            // }
            if (state.status == CommunityStatus.fetchCommunityDetailsFailed) {}
          },
          child: ValueListenableBuilder(
            valueListenable: communitiesResponse,
            builder: (BuildContext context,
                CommunityModel? communitiesResponseValue, Widget? child) {
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ValueListenableBuilder(
                    valueListenable: _isWelcomeScreenEnabled,
                    builder: (context, bool? value, child) {
                      return value!
                          ? Column(
                              children: [
                                const Text(
                                  'If you enable this Welcome Screen, new members will view this in a modal before they can view or join your community.This helps new members understand more about what this community is about and how nerdy it really is!',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                        child: Text(
                                      'Enable Welcome Screen',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    )),
                                    Switch.adaptive(
                                      value: value,
                                      activeColor: kAppBlue,
                                      onChanged: (value) {
                                        _isWelcomeScreenEnabled.value = value;
                                        CommunityModel? communityModel =
                                            communitiesResponse.value!.copyWith(
                                          enableWelcomeScreen: value,
                                        );
                                        communityAdminCubit
                                            .updateCommunityWelcomeScreen(
                                                updateWelcomeScreen:
                                                    CommunityUpdateWelcomeScreen
                                                        .fromJson(communityModel
                                                            .toJson()));
                                      },
                                    )
                                  ],
                                )
                              ],
                            )
                          : const Text(
                              'Set up a Welcome Screen that appears in front of developers when they land on your community. this can make they learn more about why they should join!',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Here is an example:',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        border: Border.all(color: theme.colorScheme.outline)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: SizedBox(
                            height: 80,
                            width: 80,
                            child: CachedNetworkImage(
                              imageUrl: profileCoverImageUrl(
                                  imageKey:
                                      communitiesResponseValue?.pictureKey ??
                                          'N/A'),
                              errorWidget: (context, url, error) => Container(
                                color: kAppBlue,
                              ),
                              placeholder: (ctx, url) => Container(
                                color: kAppBlue,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                            child: Text(
                          '${communitiesResponseValue?.name}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        )),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: Text(
                          '${communitiesResponseValue?.description}',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: theme.colorScheme.onPrimary),
                        )),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'What you need to know',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: theme.colorScheme.onPrimary),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ListView.separated(
                          itemCount: welcomeScreenResponse.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${welcomeScreenResponse[index].sectionName?.emoji}'),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Expanded(
                                          child: Text(
                                        '${welcomeScreenResponse[index].sectionName?.title}',
                                        style: TextStyle(
                                            color:
                                                theme.colorScheme.onBackground),
                                      ))
                                    ],
                                  ),
                                  textColor: theme.colorScheme.onBackground,
                                  iconColor: theme.colorScheme.onBackground,
                                  collapsedIconColor:
                                      theme.colorScheme.onBackground,
                                  expandedAlignment: Alignment.topLeft,
                                  trailing: ValueListenableBuilder(
                                    valueListenable: _isWelcomeScreenEnabled,
                                    builder: (BuildContext context, bool value,
                                        Widget? child) {
                                      return !value
                                          ? const Icon(Icons
                                              .keyboard_arrow_right_outlined)
                                          : IconButton(
                                              icon: Icon(
                                                Icons.edit_outlined,
                                                color:
                                                    theme.colorScheme.onPrimary,
                                                size: 15,
                                              ),
                                              onPressed: () {
                                                moduleActions(
                                                    context, index, theme);
                                              },
                                            );
                                    },
                                  ),
                                  childrenPadding: const EdgeInsets.all(15),
                                  children: [
                                    Text(
                                      '${welcomeScreenResponse[index].description}',
                                      style: TextStyle(
                                          color:
                                              theme.colorScheme.onBackground),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ValueListenableBuilder(
                          valueListenable: _isWelcomeScreenEnabled,
                          builder: (BuildContext context, bool value,
                              Widget? child) {
                            return value
                                ? Center(
                                    child: CustomButtonWidget(
                                      backgroundColor:
                                          theme.colorScheme.surface,
                                      text: 'Add new module',
                                      textColor: theme.colorScheme.onBackground,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditWelcomeScreen(
                                                      welcomeScreenResponse:
                                                          WelcomeScreenResponse(
                                                              description: '',
                                                              sectionName:
                                                                  SectionName(
                                                                      title: '',
                                                                      emoji:
                                                                          '🐝')),
                                                      communityModel:
                                                          communitiesResponseValue,
                                                    ))).then((value) {
                                          updateCommunities(value);
                                        });
                                      },
                                      icon: Icon(Icons.add,
                                          color:
                                              theme.colorScheme.onBackground),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ValueListenableBuilder(
                    valueListenable: _isWelcomeScreenEnabled,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return !value
                          ? CustomButtonWidget(
                              text: 'Set up a Welcome Screen',
                              onPressed: () {
                                setUpWelcomeScreen();
                              })
                          : const SizedBox.shrink();
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void setUpWelcomeScreen() {
    late CommunityModel communityModel;
    _isWelcomeScreenEnabled.value = true;
    if (communitiesResponse.value?.welcomeScreen != null &&
        communitiesResponse.value?.welcomeScreen != '') {
      communityModel = communitiesResponse.value!
          .copyWith(enableWelcomeScreen: true, welcomeScreen: _welcomeText);
      communityAdminCubit.updateCommunityWelcomeScreen(
          updateWelcomeScreen:
              CommunityUpdateWelcomeScreen.fromJson(communityModel.toJson()));
    }
  }

  void moduleActions(BuildContext context, int index, ThemeData theme) {
    final ch = SafeArea(
      child: SizedBox(
          height: 150,
          child: Column(children: [
            const CustomBorderWidget(),
            ListTile(
              leading: const Icon(FeatherIcons.edit, size: 20),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              onTap: () {
                welcomeScreenResponse[index].id = index.toString();
                pop(context);
                context.push(
                    context.generateRoutePath(subLocation: editWelcomeScreen),
                    extra: {
                      'welcomeScreenIndex': index,
                      'communityModel': communitiesResponse.value,
                      welcomeScreenResponse: welcomeScreenResponse[index]
                    });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditWelcomeScreen(
                              welcomeScreenResponse:
                                  welcomeScreenResponse[index],
                              communityModel: communitiesResponse.value,
                            ))).then((value) {
                  updateCommunities(value);
                });
              },
              title: Text(
                'Edit Module',
                style: TextStyle(
                    color: theme.colorScheme.onBackground,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const CustomBorderWidget(),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                welcomeScreenResponse.removeAt(index);
                String welcomeScreenText =
                    welcomeScreenResponseToJson(welcomeScreenResponse);
                CommunityModel? communityModel =
                    communitiesResponse.value!.copyWith(
                  welcomeScreen: welcomeScreenText,
                );
                // communitiesResponse.value!.welcomeScreen = welcomeScreenText;
                communityAdminCubit.updateCommunityWelcomeScreen(
                    updateWelcomeScreen: CommunityUpdateWelcomeScreen.fromJson(
                        communityModel.toJson()));
                setState(() {});
              },
              leading: const Icon(FeatherIcons.trash2, size: 20),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              title: Text(
                'Delete Module',
                style: TextStyle(
                    color: theme.colorScheme.onBackground,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const CustomBorderWidget(),
          ])),
    );
    showCustomBottomSheet(context, child: ch, showDragHandle: true);
  }

  void updateCommunities(value) {
    if (value != null) {
      setState(() {
        communitiesResponse.value = value;
        seedList(value);
      });
    }
  }

  String profileCoverImageUrl({required String imageKey}) {
    String mainImageUrl = '';
    List<String> stringSplit = imageKey.split('?');
    if (stringSplit.length == 1) {
      mainImageUrl = getProfileImage(stringSplit[0]);
    } else {
      mainImageUrl = stringSplit[1].substring(2);
      mainImageUrl = getProfileImage(mainImageUrl);
      List<String> imageParams = mainImageUrl.split('&');
      mainImageUrl = imageParams[0];
    }
    return mainImageUrl;
  }
}
