import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_admin_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_enums.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_state.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_update_request.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/commmunity_settings/community_social_links.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/edit_community_item.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_cubit.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_enums.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_state.dart';
import 'package:showwcase_v3/features/shared/data/bloc/shared_enum.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';

class CommunityOverview extends StatefulWidget {
  final CommunityModel? communityModel;

  const CommunityOverview({super.key, required this.communityModel});

  @override
  State<CommunityOverview> createState() => _CommunityOverviewState();
}

class _CommunityOverviewState extends State<CommunityOverview> {
  ValueNotifier<File?> profileImageChanged = ValueNotifier(null);
  ValueNotifier<File?> coverImageChanged = ValueNotifier(null);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  ValueNotifier<bool> activateDeleteAccountButton = ValueNotifier(false);
  ValueNotifier<bool> isDeletingCommunity = ValueNotifier(false);
  late FileManagerCubit _sharedCubit;
  String? coverImageUrl, profileImageUrl;
  String? uploadType;
  late CommunityModel? communityModel;
  late CommunityAdminCubit communityAdminCubit;
  late CommunityCubit communityCubit;
  ValueNotifier<bool> isDeletingAccount = ValueNotifier(false);
  late FileManagerCubit fileManagerCubit;
  final String fileUploadGroupId = "community_overview_page";

  @override
  initState() {
    super.initState();
    _sharedCubit = context.read<FileManagerCubit>();
    communityAdminCubit = context.read<CommunityAdminCubit>();
    communityCubit = context.read<CommunityCubit>();
    fileManagerCubit = context.read<FileManagerCubit>();
    communityModel = widget.communityModel;
    coverImageUrl = communityModel?.coverImageUrl;
    profileImageUrl = communityModel?.pictureUrl;
    communityCubit.fetchCommunityDetails(
        communitySlug: communityModel?.slug ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<CommunityAdminCubit, CommunityAdminState>(
          bloc: communityAdminCubit,
          listener: (context, state) {
            if (state is UpdateFeedsTagsLoading) {
              _isLoading.value = true;
            }
            if (state is UpdateFeedsTagsSuccess) {
              _isLoading.value = false;
              context.showSnackBar('Community Info updated');
              //Navigator.pop(context);
            }
            if (state is UpdateFeedsTagsError) {
              _isLoading.value = false;
              context.showSnackBar(state.apiError.errorDescription,
                  appearance: Appearance.error);
            }
            if (state is DeleteCommunityLoading) {
              isDeletingCommunity.value = true;
            }
            if (state is DeleteCommunitySuccess) {
              isDeletingCommunity.value = false;
              context.showSnackBar('Community deleted successfully');
             pop(context);
             pop(context);
             pop(context);
             pop(context);
            }
            if (state is DeleteCommunityError) {
              isDeletingCommunity.value = false;
              context.showSnackBar(state.apiError.errorDescription,
                  appearance: Appearance.error);
            }
            if (state is UpdateCommunityLoading) {
              _isLoading.value = true;
            }
            if (state is UpdateCommunitySuccess) {
              _isLoading.value = false;
              if (uploadType == 'profile') {
                context.showSnackBar(
                    'Profile image has been successfully updated');
              }
              if (uploadType == 'cover') {
                context
                    .showSnackBar('Cover image has been successfully updated');
              }
            }
            if (state is UpdateCommunityError) {
              _isLoading.value = false;
              context.showSnackBar(state.apiError.errorDescription,
                  appearance: Appearance.error);
            }
          },
          child: const SizedBox.shrink(),
        ),
        BlocListener<FileManagerCubit, FileManagerState>(
          bloc: _sharedCubit,
          listener: (context, fileManagerState) {
            if (fileManagerState.status ==
                FileManagerStatus.uploadImageFailed) {
              _isLoading.value = true;
            }
            if (fileManagerState.status ==
                FileManagerStatus.uploadImageSuccessful) {
              _isLoading.value = false;
              updateCommunityProfile();
            }
            if (fileManagerState.status ==
                FileManagerStatus.uploadImageFailed) {
              _isLoading.value = false;
            }
          },
          child: const SizedBox.shrink(),
        ),
      ],
      child: SafeArea(
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
              'Overview',
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
                            updateCommunityProfile();
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
          body: BlocConsumer<CommunityCubit, CommunityState>(
            bloc: communityCubit,
            listener: (context, state) {
              if (state.status ==
                  CommunityStatus.fetchCommunityDetailsInProgress) {
                _isLoading.value = true;
              }
              if (state.status == CommunityStatus.fetchCommunityDetailsFailed) {
                _isLoading.value = false;
              }
              if (state.status == CommunityStatus.fetchCommunityDetailsSuccessful) {
                _isLoading.value = false;
                 communityModel = state.communityDetails;
              }
            },
            builder: (context, state) {
              if (state.status ==
                  CommunityStatus.fetchCommunityDetailsSuccessful) {
                return buildOverView(theme, context);
              }
              return buildOverView(theme, context);
            },
          ),
        ),
      ),
    );
  }

  void updateCommunityProfile() {
    UpdateCommunitiesModel updateCommunitiesRequest =
        UpdateCommunitiesModel.fromJson(communityModel!.toJson());
    updateCommunitiesRequest.coverImageKey = coverImageUrl;
    updateCommunitiesRequest.pictureKey = profileImageUrl;
    communityAdminCubit.updateCommunityDetails(
        updateCommunitiesRequest: updateCommunitiesRequest,
        communityId: communityModel?.id ?? 0);
  }

  void _deleteCommunityUI(BuildContext context) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: theme(context).colorScheme.primary,
        context: context,
        useSafeArea: true,
        builder: (ctx) {
          return SafeArea(
            bottom: true,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: CloseButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const CustomBorderWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Delete account',
                      style: theme(context).textTheme.bodyText2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Are you sure, you want to delete this community? The community and its posts will be deleted completely.',
                      style: theme(context).textTheme.bodyText2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFieldWidget(
                      label:
                          "Please type “DELETE ${communityModel?.name?.toUpperCase()}” below",
                      placeHolder: "",
                      onChange: (value) {
                        if (value!.toUpperCase() ==
                            "DELETE ${communityModel?.name?.toUpperCase()}") {
                          activateDeleteAccountButton.value = true;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return ValueListenableBuilder(
                          valueListenable: isDeletingAccount,
                          builder: (ctx, bool value, _) {
                            return value
                                ? const Center(
                                    child: Row(
                                    children: [
                                      SizedBox(
                                          height: 20,
                                          width: 20,
                                          child:
                                              CircularProgressIndicator.adaptive(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    kAppBlue),
                                            strokeWidth: 1,
                                          )),
                                      SizedBox(
                                        width: 20,
                                      )
                                    ],
                                  ))
                                : ValueListenableBuilder<bool>(
                                    valueListenable: activateDeleteAccountButton,
                                    builder: (ctx, bool activate, _) {
                                      return CustomButtonWidget(
                                          text: "Delete account",
                                          appearance: activate
                                              ? Appearance.error
                                              : Appearance.secondary,
                                          onPressed: activate
                                              ? () {
                                                  communityAdminCubit
                                                      .deleteCommunity(
                                                          communityId:
                                                              communityModel
                                                                      ?.id ??
                                                                  0);
                                                  // _profileCubit.deleteProfile();
                                                }
                                              : null);
                                    },
                                  );
                          });
                    }),
                    const SizedBox(
                      height: kToolbarHeight,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  ListView buildOverView(ThemeData theme, BuildContext context) {
    final picture = communityModel?.pictureUrl ?? '';
    final coverImage = communityModel?.coverImageUrl ?? '';
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          clipBehavior: Clip.none,
          fit: StackFit.loose,
          children: [
            ValueListenableBuilder(
              valueListenable: coverImageChanged,
              builder: (BuildContext context, File? value, Widget? child) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _getFromGallery(true);
                  },
                  child: coverImage.isNotEmpty && value == null
                      ? Stack(
                          alignment: Alignment.topRight,
                          children: [
                            GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  _getFromGallery(true);
                                },
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    coverImage.endsWith('.svg')
                                        ? SvgPicture.network(
                                            coverImage,
                                            height: 200,
                                            width: width(context),
                                            fit: BoxFit.cover,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: coverImage,
                                            errorWidget: (context, url,
                                                    error) =>
                                                CoverPlaceHolder(value: value),
                                            placeholder: (ctx, url) =>
                                                CoverPlaceHolder(value: value),
                                            cacheKey:
                                                communityModel?.coverImageKey,
                                            fit: BoxFit.cover,
                                            height: 200,
                                            width: width(context),
                                            // width: width(context),
                                            // height: 200,
                                          ),
                                    Positioned.fill(
                                      bottom: 30,
                                      left: width(context) / 1.2,
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        )
                      : Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: value == null
                                  ? const AssetImage(
                                          'assets/img/settings_background.png')
                                      as ImageProvider
                                  : FileImage(value),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: profileImageChanged,
              builder: (BuildContext context, File? value, Widget? child) {
                return Positioned(
                  bottom: -40,
                  left: 120,
                  right: 120,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _getFromGallery(false);
                    },
                    child: picture.isNotEmpty && value == null
                        ? SizedBox(
                            height: 110,
                            width: 110,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: picture.endsWith('.svg')
                                  ? SvgPicture.network(picture)
                                  : CachedNetworkImage(
                                      imageUrl: picture,
                                      errorWidget: (context, url, error) =>
                                          ProfilePlaceHolder(value: value),
                                      placeholder: (ctx, url) =>
                                          ProfilePlaceHolder(value: value),
                                      cacheKey: communityModel?.pictureKey,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          )
                        : Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: value == null
                                    ? const AssetImage(
                                            'assets/img/showwcase_banner_placeholder.png')
                                        as ImageProvider
                                    : FileImage(value),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        const SizedBox(
          height: 30,
        ),
        EditCommunityItem(
            title: 'Category',
            infoType: CommunityUpdateType.category,
            communityModel: communityModel,
            subtitle: '${communityModel?.category?.name ?? ''} ',
            onUpdated: () {
              communityCubit.fetchCommunityDetails(communitySlug: communityModel?.slug ?? '');
            },
            shouldOpenNewPage: true),
        EditCommunityItem(
            title: 'Community Name',
            infoType: CommunityUpdateType.communityName,
            communityModel: communityModel,
            subtitle: communityModel?.name ?? '',
            onUpdated: () {
              communityCubit.fetchCommunityDetails(
                  communitySlug: communityModel?.slug ?? '');
            },
            shouldOpenNewPage: true),
        EditCommunityItem(
            title: 'Description',
            infoType: CommunityUpdateType.description,
            communityModel: communityModel,
            subtitle: communityModel?.description ?? '',
            onUpdated: () {
              communityCubit.fetchCommunityDetails(
                  communitySlug: communityModel?.slug ?? '');
            },
            shouldOpenNewPage: true),
        EditCommunityItem(
            title: 'Date Created',
            infoType: CommunityUpdateType.dateCreated,
            communityModel: communityModel,
            subtitle: getFormattedDateWithIntl(communityModel!.createdAt!),
            onUpdated: () {},
            shouldOpenNewPage: false),
        EditCommunityItem(
            title: 'About',
            infoType: CommunityUpdateType.about,
            communityModel: communityModel,
            subtitle: communityModel?.about ?? '',
            onUpdated: () {
              communityCubit.fetchCommunityDetails(
                  communitySlug: communityModel?.slug ?? '');
            },
            shouldOpenNewPage: true),
        EditCommunityItem(
          title: 'Community Tags',
          infoType: CommunityUpdateType.communityTags,
          communityModel: communityModel,
          onUpdated: () {
            communityCubit.fetchCommunityDetails(
                communitySlug: communityModel?.slug ?? '');
          },
          shouldOpenNewPage: true,
          subtitle: '',
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CommunitySocialLinks(
                          communityModel: communityModel,
                        ))).then((value) => {
                  communityCubit.fetchCommunityDetails(
                      communitySlug: communityModel?.slug ?? '')
                });
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
                      flex: 2,
                      child: Text('Social Link',
                          style: TextStyle(
                              color: theme.colorScheme.onBackground,
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
                          Icon(Icons.arrow_forward_ios,
                              size: 10, color: theme.colorScheme.onPrimary),
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
        ),
        const CustomBorderWidget(),
        const SizedBox(
          height: 50,
        ),
        const CustomBorderWidget(),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _deleteCommunityUI(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Delete Community',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: defaultFontSize,
                        fontWeight: FontWeight.w700)),
                Icon(Icons.arrow_forward_ios,
                    size: 10, color: theme.colorScheme.onPrimary),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const CustomBorderWidget(),
        const SizedBox(
          height: 50,
        ),
        const CustomBorderWidget(),
        const SizedBox(
          height: 15,
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
        //   child: GestureDetector(
        //     behavior: HitTestBehavior.opaque,
        //     onTap: () {
        //       _transferCommunityUI(
        //         context,
        //       );
        //     },
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         const Text('Transfer Community',
        //             style: TextStyle(
        //                 color: Colors.red,
        //                 fontSize: defaultFontSize,
        //                 fontWeight: FontWeight.w700)),
        //         Icon(Icons.arrow_forward_ios,
        //             size: 10, color: theme.colorScheme.onPrimary),
        //       ],
        //     ),
        //   ),
        // ),
        // const SizedBox(
        //   height: 15,
        // ),
        //const CustomBorderWidget(),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }

  /// Get from gallery
  _getFromGallery(bool isCoverImage) async {
    final files = await pickFilesFromGallery(context);
    if (files != null && files.isNotEmpty) {
      final croppedFile = await cropImage(files[0].path);
      if (croppedFile != null) {
        _uploadImageToServer(croppedFile, isCoverImage);
      }
    }
  }

  _uploadImageToServer(File file, bool isCoverImage) async {
    uploadType = isCoverImage ? 'cover' : 'profile';
    if (isCoverImage) {
      coverImageChanged.value = file;
    } else {
      profileImageChanged.value = file;
    }
    final either = await fileManagerCubit.uploadImage(
        file: file,
        bucketName: profilePictureBucket,
        groupId: fileUploadGroupId,
        fileTag: 0);
    if (!mounted) {
      return;
    }
    if (either.isLeft()) {
      context.showSnackBar("Upload failed");
      return;
    }

    // successful
    final fileItem = either.asRight();
    // set the profileImage to the current user session
    if (fileItem.preSignedUrl?.url == null) {
      context.showSnackBar("Upload failed");
      return;
    }

    final pImageKey = fileItem.preSignedUrl?.preSignedUrlFields?.key;
    if (pImageKey == null) {
      context.showSnackBar("Upload failed");
      return;
    }

    final pImage = getProfileImage(pImageKey);
    if (!isCoverImage) {
      profileImageUrl = pImage;
      return;
    }
    if (isCoverImage) {
      coverImageUrl = pImage;
      return;
    }
  }

  void _transferCommunityUI(BuildContext context) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: theme(context).colorScheme.primary,
        context: context,
        builder: (ctx) {
          return Padding(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: CloseButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const CustomBorderWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Delete account',
                    style: theme(context).textTheme.bodyText2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Are you sure you want to delete your account? This will immediately log you out and you will not be able to log in again.',
                    style: theme(context).textTheme.bodyText2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFieldWidget(
                    label: "Please type “DELETE ACCOUNT” below",
                    placeHolder: "",
                    onChange: (value) {
                      if (value!.toUpperCase() == "DELETE ACCOUNT") {
                        activateDeleteAccountButton.value = true;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return ValueListenableBuilder(
                        valueListenable: isDeletingCommunity,
                        builder: (ctx, bool value, _) {
                          return value
                              ? const Center(
                                  child: Row(
                                  children: [
                                    SizedBox(
                                        height: 20,
                                        width: 20,
                                        child:
                                            CircularProgressIndicator.adaptive(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  kAppBlue),
                                          strokeWidth: 1,
                                        )),
                                    SizedBox(
                                      width: 20,
                                    )
                                  ],
                                ))
                              : ValueListenableBuilder<bool>(
                                  valueListenable: activateDeleteAccountButton,
                                  builder: (ctx, bool activate, _) {
                                    return CustomButtonWidget(
                                        text: "Delete account",
                                        appearance: activate
                                            ? Appearance.error
                                            : Appearance.secondary,
                                        onPressed: activate ? () {} : null);
                                  },
                                );
                        });
                  }),
                  const SizedBox(
                    height: kToolbarHeight,
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _onTransferCommunity() {
    _showDeleteDialog(
        dialogAction: DialogAction.logout,
        title: "Do you want to logout?",
        subTitle: "You'd have to login again next time you open the app");
  }

  void _showDeleteDialog(
      {required DialogAction dialogAction,
      String? title,
      String? subTitle,
      String confirmActionText = "Confirm",
      String cancelActionText = "Cancel",
      Map<String, dynamic>? data}) {
    data ??= {};

    data.putIfAbsent("title", () => title ?? "Are you sure?");
    data.putIfAbsent("subTitle", () => subTitle);
    data.putIfAbsent("cancelActionText", () => cancelActionText);
    data.putIfAbsent("confirmActionText", () => confirmActionText);

    showConfirmDialog(
      context,
      title: data['title'] ?? '',
      subtitle: data['subTitle'],
      data: data,
      cancelAction: data['cancelActionText'],
      confirmAction: data['confirmActionText'],
      onConfirmTapped: () {
        // _authCubit.logOut();
        // changeScreenWithConstructor(context, const WalkThroughPage(),
        //     replaceAll: true, rootNavigator: true);
      },
    );
  }
}

class CoverPlaceHolder extends StatelessWidget {
  final File? value;

  const CoverPlaceHolder({
    super.key,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: value == null
              ? const AssetImage('assets/img/settings_background.png')
                  as ImageProvider
              : FileImage(value!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ProfilePlaceHolder extends StatelessWidget {
  final File? value;

  const ProfilePlaceHolder({
    super.key,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
      ),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(
        left: 16.0,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: value == null
                ? const AssetImage(
                        'assets/img/showwcase_banner_placeholder.png')
                    as ImageProvider
                : FileImage(value!),
          ),
          const Icon(
            Icons.camera_alt_outlined,
            size: 20,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
