import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_admin_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_enums.dart';
import 'package:showwcase_v3/features/communities/data/models/community_category_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_update_request.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/list_chip_tags.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_dropdown.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';

class EditCommunityInfo extends StatefulWidget {
  final CommunityUpdateType infoType;
  final CommunityModel? communityModel;

  const EditCommunityInfo(
      {super.key,
      required this.infoType,
      required this.communityModel});

  @override
  State<EditCommunityInfo> createState() => _EditCommunityInfoState();
}

class _EditCommunityInfoState extends State<EditCommunityInfo> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  late CommunityAdminCubit communityAdminCubit;
  late final TextEditingController _communityName,
      communityDescription,
      communityAbout;
  late List<String> _communityCategories;

  late CommunityModel? communityModel;
  late ValueNotifier<String?> categoryValue;
  late CommunityCategoryModel? selectedCategory;
  late List<String> selectedTags, selectedInterests, interestLists;
  late List<String?> tagList;

  @override
  void initState() {
    communityAdminCubit = context.read<CommunityAdminCubit>();
    communityAdminCubit.fetchCommunityCategories();
    communityModel = widget.communityModel;
    _communityName = TextEditingController(text: communityModel?.name);
    communityDescription =
        TextEditingController(text: communityModel?.description);
    communityAbout =
        TextEditingController(text: communityModel?.about);
    _communityCategories = [];
    categoryValue =
        ValueNotifier(communityModel?.category?.name ?? 'General');
    selectedTags = communityModel?.tags
        ?.map((e) => e.tagDescription ?? '')
        .toList() ??
        [];
    selectedInterests = communityModel?.interests ?? [];
    selectedCategory = communityModel?.category;
    communityAdminCubit.fetchInterests();
    tagList = [];
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
          getStringForEnum(widget.infoType),
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
                    if (widget.infoType == CommunityUpdateType.interests) {
                      updateInterests();
                    } else if (widget.infoType == CommunityUpdateType
                        .communityTags) {
                      updateCommunityTag();
                    } else {
                      updateCommunityDetails();
                    }
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
      body: MultiBlocListener(
        listeners: [
          BlocListener<CommunityAdminCubit, CommunityAdminState>(
            bloc: communityAdminCubit,
            listener: (context, state) {
              if (state is UpdateCommunityLoading ||
                  state is UpdateInterestsLoading ||
                  state is UpdateCommunityTagsLoading) {
                _isLoading.value = true;
              }

              if (state is UpdateCommunitySuccess ||
                  state is UpdateInterestsSuccess ||
                  state is UpdateCommunityTagsSuccess) {
                _isLoading.value = false;
                context.showSnackBar(
                    '${getStringForEnum(
                        widget.infoType)} Updated Successfully');
              }
              if (state is UpdateCommunityError) {
                _isLoading.value = false;
                context.showSnackBar(state.apiError.errorDescription);
              }
              if (state is UpdateInterestsError) {
                context.showSnackBar(state.apiError.errorDescription);
              }
              if (state is UpdateCommunityTagsError) {
                context.showSnackBar(state.apiError.errorDescription);
              }
            },
          ),
        ],
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (widget.infoType == CommunityUpdateType.communityName) ...{
                CustomTextFieldWidget(
                  label: 'Community Name',
                  controller: _communityName,
                  placeHolder: 'eg. React',
                  validator: (String? value) {
                    if (value == null || value == '') {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
              },
              if (widget.infoType == CommunityUpdateType.description) ...{
                CustomTextFieldWidget(
                  label: 'Community Description',
                  controller: communityDescription,
                  maxLines: 6,
                  placeHolder: 'eg. React',
                  validator: (String? value) {
                    if (value == null || value == '') {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
              },
              if (widget.infoType == CommunityUpdateType.about) ...{
                CustomTextFieldWidget(
                  label: 'About',
                  controller: communityAbout,
                  maxLines: 6,
                  placeHolder: 'eg. React',
                  validator: (String? value) {
                    if (value == null || value == '') {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
              },
              if (widget.infoType == CommunityUpdateType.category) ...[
                Text(
                  'Category',
                  style: TextStyle(
                      color: theme.colorScheme.onBackground,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocConsumer<CommunityAdminCubit, CommunityAdminState>(
                  bloc: communityAdminCubit,
                  buildWhen: (previous, current) {
                    if (current is CommunityCategoriesLoading ||
                        current is CommunityCategoriesSuccess) {
                      return true;
                    }
                    return false;
                  },
                  listener: (context, state) {
                    if (state is CommunityCategoriesSuccess) {
                      _communityCategories =
                          state.categoriesResponse.map((e) => e.name ?? '')
                              .toList();
                    }
                  },
                  builder: (context, state) {
                    if (state is CommunityCategoriesLoading) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(kAppBlue),
                          strokeWidth: 1,
                        ),
                      );
                    }
                    if (state is CommunityCategoriesSuccess) {
                      return ValueListenableBuilder(
                        valueListenable: categoryValue,
                        builder: (BuildContext context, String? value,
                            Widget? child) {
                          return CustomDropdownWidget(
                            items: _communityCategories,
                            hintText: 'Select Month',
                            value: value!,
                            onChanged: (String? value) {
                              categoryValue.value = value!;
                              selectedCategory = state.categoriesResponse
                                  .firstWhere(
                                      (element) => element.name == value);
                            },
                          );
                        },
                      );
                    }
                    if (state is CommunityCategoriesError) {}
                    return const SizedBox.shrink();
                  },
                ),
              ],
              if (widget.infoType == CommunityUpdateType.communityTags) ...[
                Text(
                  'Add Tags',
                  style: TextStyle(
                      color: theme.colorScheme.onBackground,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Add tags for your community',
                  style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocConsumer<CommunityAdminCubit, CommunityAdminState>(
                  bloc: communityAdminCubit,
                  listener: (context, state) {
                    if (state is SearchTagsLoading) {}
                    if (state is SearchTagsSuccess) {
                      tagList = state.tagSuggestions;
                    }
                    if (state is SearchTagsError) {}
                  },
                  builder: (context, state) {
                    if (state is SearchTagsLoading) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(kAppBlue),
                          strokeWidth: 1,
                        ),
                      );
                    }
                    if (state is SearchTagsSuccess) {
                      return ListChipTags(
                        selectedTags: selectedTags,
                        chipColor: theme.colorScheme.surface,
                        iconColor: theme.colorScheme.onPrimary,
                        textColor: theme.colorScheme.onBackground,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.brightness == Brightness.dark
                              ? const Color(0xff202021)
                              : const Color(0xffF7F7F7),
                          hintText: 'Select Tags',
                          hintStyle: TextStyle(
                              color:
                              theme.colorScheme.onPrimary.withOpacity(0.5)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: theme.colorScheme.outline, width: 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: theme.colorScheme.outline, width: 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: theme.colorScheme.outline, width: 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        chipPosition: ChipPosition.below,
                        onChanged: (List<String> chips) {
                          selectedTags = chips;
                        },
                        suggestedTags: tagList,
                        onChangedText: (String value) {
                          communityAdminCubit.searchCommunityTag(text: value);
                        },
                      );
                    }
                    if (state is SearchTagsError) {}
                    return ListChipTags(
                      selectedTags: selectedTags,
                      chipColor: theme.colorScheme.surface,
                      iconColor: theme.colorScheme.onPrimary,
                      textColor: theme.colorScheme.onBackground,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: theme.brightness == Brightness.dark
                            ? const Color(0xff202021)
                            : const Color(0xffF7F7F7),
                        hintText: 'Select Tags',
                        hintStyle: TextStyle(
                            color:
                            theme.colorScheme.onPrimary.withOpacity(0.5)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: theme.colorScheme.outline, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: theme.colorScheme.outline, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: theme.colorScheme.outline, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      chipPosition: ChipPosition.below,
                      onChanged: (List<String> chips) {
                        selectedTags = chips;
                      },
                      suggestedTags: tagList,
                      onChangedText: (String value) {
                        communityAdminCubit.searchCommunityTag(text: value);
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
              if (widget.infoType == CommunityUpdateType.interests) ...[
                Text(
                  'Add Interests',
                  style: TextStyle(
                      color: theme.colorScheme.onBackground,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Add interests for your community',
                  style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocConsumer<CommunityAdminCubit, CommunityAdminState>(
                  bloc: communityAdminCubit,
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is FetchInterestsSuccess) {
                      interestLists = state.result;
                      return MultiSelectDialogField(
                        items: interestLists
                            .map((e) => MultiSelectItem(e, e))
                            .toList(),
                        initialValue: selectedInterests,
                        buttonText: Text(
                          "Select Interests",
                          style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w400),
                        ),
                        title: Center(
                          child: Text(
                            "Select Interests",
                            style: TextStyle(
                                color: theme.colorScheme.onBackground,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        backgroundColor: theme.colorScheme.background,
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark
                              ? const Color(0xff202021)
                              : const Color(0xffF7F7F7),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        cancelText: Text(
                          'Cancel',
                          style:
                          TextStyle(color: theme.colorScheme.onBackground),
                        ),
                        confirmText: Text(
                          'OK',
                          style:
                          TextStyle(color: theme.colorScheme.onBackground),
                        ),
                        dialogHeight: height(context) / 2,
                        selectedItemsTextStyle:
                        TextStyle(color: theme.colorScheme.onBackground),
                        listType: MultiSelectListType.CHIP,
                        chipDisplay: MultiSelectChipDisplay<String>(
                          onTap: (String value) {
                            selectedInterests.remove(value);
                            setState(() {});
                          },
                          scroll: true,
                          icon: Icon(
                            Icons.clear,
                            size: 12,
                            color: theme.colorScheme.onBackground,
                          ),
                          chipColor: theme.colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          textStyle: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w700),
                        ),
                        buttonIcon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: theme.colorScheme.onPrimary,
                        ),
                        onConfirm: (List<String> onselect) {
                          selectedInterests = onselect;
                        },
                      );
                    }
                    if (state is FetchInterestsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(kAppBlue),
                          strokeWidth: 1,
                        ),
                      );
                    }
                    if (state is FetchInterestsError) {
                      return CustomNoConnectionWidget(
                        title: state.error,
                        showRetryButton: true,
                        onRetry: () {
                          communityAdminCubit.fetchInterests();
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  void updateCommunityDetails() {
    var isValidated = _formKey.currentState!.validate();
    if (isValidated) {
      communityAdminCubit.updateCommunityDetails(
          updateCommunitiesRequest:
          UpdateCommunitiesModel(
            about: communityAbout.text,
            category: selectedCategory,
            categoryId: selectedCategory!.id,
            coverImageKey:
            communityModel!.coverImageKey,
            description: communityDescription.text,
            coverImageKeyRemote:
            communityModel!.coverImageKey,
            pictureKey:
            communityModel!.pictureKey,
            pictureKeyRemote:
            communityModel!.pictureKey,
            name: _communityName.text,
            socials: communityModel!.socials,
          ),
          communityId: communityModel!.id!);
    }
  }

  void updateCommunityTag() {
    communityAdminCubit.updateCommunityTag(
        communityId: communityModel!.id,
        tags: selectedTags);
  }

  void updateInterests() {
    communityAdminCubit.updateInterests(
        slug: communityModel!.slug!, interests: selectedInterests);
  }

}

