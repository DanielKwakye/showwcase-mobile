import 'dart:convert';

import 'package:emoji_selector/emoji_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_emoji_picker/keyboard_emoji_picker.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_admin_cubit.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_update_welcome_screen.dart';
import 'package:showwcase_v3/features/communities/data/models/welcome_screen_response.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';

class EditWelcomeScreen extends StatefulWidget {
  final WelcomeScreenResponse? welcomeScreenResponse;
  final CommunityModel? communityModel;
  final int? welcomeScreenIndex;

  const EditWelcomeScreen(
      {super.key, this.welcomeScreenResponse, this.communityModel,this.welcomeScreenIndex});

  @override
  State<EditWelcomeScreen> createState() => _EditWelcomeScreenState();
}

class _EditWelcomeScreenState extends State<EditWelcomeScreen> {
  late final TextEditingController sectionName, describeSection;
  EmojiData? emojiData;
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  late CommunityAdminCubit communityAdminCubit;

  late CommunityModel? communitiesResponse;
  List<WelcomeScreenResponse> welcomeScreenList = [];
  late WelcomeScreenResponse? welcomeScreenResponse;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    communitiesResponse = widget.communityModel;
    welcomeScreenResponse = widget.welcomeScreenResponse;
    if (communitiesResponse?.welcomeScreen != null) {
      welcomeScreenList = List<WelcomeScreenResponse>.from(
          jsonDecode(widget.communityModel!.welcomeScreen!)
              .map((x) => WelcomeScreenResponse.fromJson(x)));
    }
    communityAdminCubit = context.read<CommunityAdminCubit>();
    emojiData = EmojiData(
        id: '',
        name: '',
        unified: '',
        char: widget.welcomeScreenResponse?.sectionName?.emoji ?? '🐝',
        category: '',
        skin: 0);
    sectionName =
        TextEditingController(text: welcomeScreenResponse?.sectionName?.title);
    describeSection =
        TextEditingController(text: welcomeScreenResponse?.description);
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
                        FocusScope.of(context).unfocus();
                        updateWelcomeScreen();
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
        title: Text(
          'Edit Community Section',
          style: TextStyle(
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.w700,
              fontSize: defaultFontSize),
        ),
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(2), child: CustomBorderWidget()),
      ),
      body: BlocListener<CommunityAdminCubit, CommunityAdminState>(
        bloc: communityAdminCubit,
        listener: (context, state) {
          if (state is UpdateCommunityLoading) {
            _isLoading.value = true;
          }
          if (state is UpdateCommunitySuccess) {
            _isLoading.value = false;
            Navigator.of(context).pop(state.communityModel);
          }
          if (state is UpdateCommunityError) {
            _isLoading.value = false;
            context.showSnackBar(state.apiError.errorDescription,
                appearance: Appearance.error);
          }
        },
        child: Form(
          key: _formKey,
          child: KeyboardEmojiPickerWrapper(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                CustomTextFieldWidget(
                  label: 'Give this section a name and an icon',
                  controller: sectionName,
                  prefix: GestureDetector(
                    onTap: () async {
                      final hasEmojiKeyboard = await KeyboardEmojiPicker().checkHasEmojiKeyboard();

                      if (hasEmojiKeyboard) {
                        // Open the keyboard.
                        final emoji = await KeyboardEmojiPicker().pickEmoji();
                        setState(() {
                          emojiData = EmojiData(
                              id: '',
                              name: '',
                              unified: '',
                              char: emoji ?? '🐝',
                              category: '',
                              skin: 0);
                        });
                      } else {
                        // Use another way to pick an emoji or show a dialog asking the user to
                        // enable the emoji keyboard.
                        showFallbackDialog();
                      }
                    },
                    child: Text(
                      emojiData?.id == null ? '🐝' : '${emojiData?.char} ',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  placeHolder: 'About this community',
                  validator: (String? value) {
                    if (value == null || value == '') {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFieldWidget(
                  label: 'Describe this section',
                  controller: describeSection,
                  maxLines: 6,
                  placeHolder: '',
                  validator: (String? value) {
                    if (value == null || value == '') {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateWelcomeScreen() {
    var isValidated = _formKey.currentState!.validate();
    if (isValidated) {
      welcomeScreenResponse = WelcomeScreenResponse(
          sectionName: SectionName(
              emoji: emojiData?.char ?? '🐝',
              title: sectionName.text),
          description: describeSection.text);
      if (widget.welcomeScreenIndex! < 0) {
        welcomeScreenList.add(welcomeScreenResponse!);
      } else {
        welcomeScreenList[widget.welcomeScreenIndex!] = welcomeScreenResponse!;
      }
      String welcomeScreenText = welcomeScreenResponseToJson(welcomeScreenList);
      CommunityModel communityModel = communitiesResponse!.copyWith(enableWelcomeScreen: true, welcomeScreen: welcomeScreenText);
      communityAdminCubit.updateCommunityWelcomeScreen(
          updateWelcomeScreen:
              CommunityUpdateWelcomeScreen.fromJson(
                  communityModel.toJson()));
    }
  }

  void showFallbackDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 350,
          child: EmojiSelector(
            onSelected: (emoji) {
              setState(() {
                emojiData = emoji;
              });
              Navigator.of(context).pop(emoji);
            },
          ),
        );
      },
    );
  }
}
