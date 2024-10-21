import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showwcase_v3/core/mix/form_mixin.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_cubit.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_enums.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_state.dart';
import 'package:showwcase_v3/features/file_manager/data/models/file_item.dart';
import 'package:showwcase_v3/features/locations/presentation/pages/locations_page.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class ProfileSetupPage extends StatefulWidget {

  final Function()? onCompleted;
  const ProfileSetupPage({Key? key, this.onCompleted}) : super(key: key);

  @override
  ProfileSetupPageController createState() => ProfileSetupPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ProfileSetupPageView extends WidgetView<ProfileSetupPage, ProfileSetupPageController> {

  const _ProfileSetupPageView(ProfileSetupPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: AnimationConfiguration.synchronized(
          child: SlideAnimation(
              duration: const Duration(milliseconds: 800),
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(
                        'Create your account',
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800,fontSize: 20),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: state._handleSetProfilePic,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: CircleAvatar(
                                  backgroundColor:
                                  theme.colorScheme.outline,
                                  child: Stack(
                                    children: [

                                      /// Set the image once its available ---
                                      ValueListenableBuilder<String?>(valueListenable: state.profileImage, builder: (_, profileImage, __) {
                                        return CustomUserAvatarWidget(
                                          networkImage: profileImage,
                                          borderSize: 0,
                                          username: AppStorage.currentUserSession?.email ?? AppStorage.currentUserSession?.username,
                                          size: double.infinity,
                                        );
                                      }),

                                       /// Just show the loader ------
                                       BlocSelector<FileManagerCubit, FileManagerState, FileItem?>(
                                         selector: (fileManagerState) {
                                           return fileManagerState.fileItems.firstWhereOrNull(
                                                 (element) => element.groupId == state.fileUploadGroupId && element.fileTag == 0,
                                           );
                                         },
                                         builder: (context, fileItem) {
                                           if(fileItem?.status == FileItemStatus.inProgress){
                                             return const Positioned.fill(child: CircularProgressIndicator(color: kAppBlue, strokeWidth: 5,));
                                           }
                                           return const SizedBox.shrink();
                                         },
                                       )

                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Set profile picture',
                                  style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w600,),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Upload a photo',
                                  style: TextStyle(color: theme.colorScheme.onPrimary),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ValueListenableBuilder<bool?>(valueListenable: state.emailAvailable, builder: (_, emailAvailable, __) {
                        return BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, authState) {
                              return CustomTextFieldWidget(
                                  label: 'Email *',
                                  placeHolder: 'yourname@example.com',
                                  disabled: !AppStorage.currentUserSession!.email.isNullOrEmpty(),
                                  controller: state._emailTextEditingController,
                                  validator: state.isRequired,
                                  errorText: emailAvailable == false ? 'Already taken' : null,
                                  // errorText: snapshot.error as String?,
                                  onChange: (value) {
                                    if(value == null) return;
                                    state.onEmailChange(value);
                                  },
                                  suffix:authState.status == AuthStatus.checkIfEmailExistsInProgress ?
                                  const UnconstrainedBox(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 1, color: kAppBlue,),))
                                      : emailAvailable == true ? const Icon(
                                    Icons.check_circle_outline,
                                    color: kAppGreen,
                                    size: 20,
                                  ) : null,
                                );
                            },
                          );
                      }),
                      const SizedBox(
                        height: 15,
                      ),

                      CustomTextFieldWidget(
                        label: 'Display name *',
                        controller: state._displayNameTextEditingController,
                        placeHolder: 'eg. Jones',
                        validator: state.isRequired,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ValueListenableBuilder<bool?>(valueListenable: state.usernameAvailable, builder: (_, usernameAvailable, __) {
                        return BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, authState) {
                            return CustomTextFieldWidget(
                                label: 'Username *',
                                placeHolder: '',
                                textCapitalization: TextCapitalization.none,
                                disabled: !AppStorage.currentUserSession!.username.isNullOrEmpty(),
                                controller: state._userNameTextEditingController,
                                errorText: usernameAvailable == false ? 'Already taken' : null,
                                validator: state.isRequired,
                                onChange: (value) {
                                  if(value == null) return;
                                  state.onUsernameChange(value);
                                },
                                suffix:
                                authState.status == AuthStatus.checkIfUsernameExistsInProgress ?
                                const UnconstrainedBox(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 1, color: kAppBlue,),))
                                : usernameAvailable == true ? const Icon(
                                  Icons.check_circle_outline,
                                  color: kAppGreen,
                                  size: 20,
                                ) : null,
                              );
                          },
                        );
                      }),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextFieldWidget(
                        label: 'Location',
                        placeHolder: '',
                        controller: state._locationTextEditingController,
                        readOnly: true,
                        onTap: state._onLocationTextFieldTapped,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15),
                          child: SvgPicture.asset(
                            kLocationIconSvg,
                            colorFilter: ColorFilter.mode(theme.colorScheme.onPrimary, BlendMode.srcIn),
                          ),
                        ),
                        suffix: ValueListenableBuilder<bool>(valueListenable: state.showClearLocationBtn, builder: (_, showClearLocationBtn, __){
                          if(!showClearLocationBtn) {
                            return const SizedBox.shrink();
                          }
                          return GestureDetector(
                            onTap: () {
                              state._locationTextEditingController.clear();
                              state.showClearLocationBtn.value = false;
                            },
                            behavior: HitTestBehavior.opaque,
                            child:  Padding(
                              padding: const EdgeInsets.all(15),
                              child: Icon(
                                Icons.delete,
                                size: 20,
                                color: theme.colorScheme.onBackground,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextFieldWidget(
                        label: 'One liner', placeHolder: '',
                        controller: state._oneLinerTextEditingController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (ctx, authState) {
                          return CustomButtonWidget(
                            text: 'Get Started',
                            loading: authState.status == AuthStatus.updateAuthUserDataInProgress,
                            expand: true,
                            appearance: Appearance.primary,
                            onPressed: () => state._handleSubmit(ctx),
                          );
                        },
                      ),

                      const SizedBox(
                        height: kToolbarHeight,
                      )
                    ]),
                  ),
                ),
              ))),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ProfileSetupPageController extends State<ProfileSetupPage> with FormMixin {

  late FileManagerCubit fileManagerCubit;
  late AuthCubit authCubit;
  late StreamSubscription<AuthState> authStateStreamSubscription;
  final ValueNotifier<String?> profileImage = ValueNotifier(null);
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _displayNameTextEditingController = TextEditingController();
  final TextEditingController _userNameTextEditingController = TextEditingController();
  final TextEditingController _locationTextEditingController = TextEditingController();
  final ValueNotifier<bool> showClearLocationBtn = ValueNotifier(false);
  final TextEditingController _oneLinerTextEditingController = TextEditingController();
  final ValueNotifier<bool?> emailAvailable = ValueNotifier(null); // if available, then the email can be submitted
  final ValueNotifier<bool?> usernameAvailable = ValueNotifier(null); // if available, then the username can be submitted
  final String fileUploadGroupId = "01_profile_setup_page";


  @override
  Widget build(BuildContext context) => _ProfileSetupPageView(this);

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
    fileManagerCubit = context.read<FileManagerCubit>();
    authStateStreamSubscription = authCubit.stream.listen((event) {
      if(event.status == AuthStatus.updateAuthUserDataSuccessful) {
        // context.showSnackBar("Profile updated!");
        // move user to next screen
        widget.onCompleted?.call();
      }

    });
    initializeFields();
  }

  void initializeFields() {
    _emailTextEditingController.text = AppStorage.currentUserSession?.email ?? '';
    final pImage = AppStorage.currentUserSession?.profilePictureKey;
    if(pImage != null) {
      profileImage.value = getProfileImage(pImage);
    }
    _displayNameTextEditingController.text = AppStorage.currentUserSession?.displayName ?? '';
    _userNameTextEditingController.text = AppStorage.currentUserSession?.username ?? '';
    _locationTextEditingController.text = AppStorage.currentUserSession?.location ?? '';
    _oneLinerTextEditingController.text = AppStorage.currentUserSession?.headline ?? '';

    // if available, then the email can be submitted
    if(_emailTextEditingController.text.isNotEmpty) {
        emailAvailable.value = true;
    }
    // if available, then the username can be submitted
    if(_userNameTextEditingController.text.isNotEmpty) {
        usernameAvailable.value = true;
    }

    if(_locationTextEditingController.text.isNotEmpty){
      showClearLocationBtn.value = true;
    }

  }

  void onEmailChange(String email) {
    EasyDebounce.debounce(
        'email-check-debouncer',                 // <-- An ID for this particular debouncer
        const Duration(milliseconds: 500),    // <-- The debounce duration
            () async {                             // <-- The target method

              if(email.isEmpty){
                emailAvailable.value = null;
                return;
              }

              emailAvailable.value = null;
              final available = await authCubit.checkIfEmailExists(email: email);
              if(available == null) {
                // there was an error fetching from the server
                return;
              }
              emailAvailable.value = available;

        }
    );
  }

  void onUsernameChange(String username) {
    EasyDebounce.debounce(
        'username-check-debouncer',                 // <-- An ID for this particular debouncer
        const Duration(milliseconds: 500),    // <-- The debounce duration
            () async {                             // <-- The target method

          if(username.isEmpty){
            usernameAvailable.value = null;
            return;
          }

          usernameAvailable.value = null;
          final available = await authCubit.checkIfUsernameExists(username: username);
          if(available == null) {
            // there was an error fetching from the server
            return;
          }
          usernameAvailable.value = available;

        }
    );
  }


  /// this action is called when user wants to set up profile pic
  void _handleSetProfilePic() async {
    final files = await pickFilesFromGallery(context);
    if(files != null && files.isNotEmpty) {
      final croppedFile = await cropImage(files[0].path);
      if(croppedFile != null) {
        _uploadImageToServer(croppedFile);
      }
    }

  }


  _uploadImageToServer(File file) async {
    final either = await fileManagerCubit.uploadImage(file: file, bucketName: profilePictureBucket, groupId: fileUploadGroupId, fileTag: 0);
    if(!mounted){
      return;
    }
    if(either.isLeft()){
      context.showSnackBar("Upload failed");
      return;
    }

    // successful
    final fileItem = either.asRight();
    // set the profileImage to the current user session
    if(fileItem.preSignedUrl?.url == null){
      context.showSnackBar("Upload failed");
      return;
    }

    final pImageKey = fileItem.preSignedUrl?.preSignedUrlFields?.key;
    if(pImageKey == null){
      context.showSnackBar("Upload failed");
      return;
    }

    final pImage = getProfileImage(pImageKey);

    // updates the session, shared pref and any related data
    authCubit.updateAuthUserData(AppStorage.currentUserSession!.copyWith(
      profilePictureKey: pImage
    ), localOnly: true);

    profileImage.value = pImage;
    if(mounted) {
      context.showSnackBar("Uploaded");
    }

  }



  void _handleSubmit(BuildContext ctx) {
    FocusScope.of(context).unfocus();
    if(!validateAndSaveOnSubmit(ctx)){
      return;
    }

    if(usernameAvailable.value == false){
      context.showSnackBar("Username is already taken");
      return;
    }

    authCubit.updateAuthUserData(AppStorage.currentUserSession!.copyWith(
      email: _emailTextEditingController.text,
      displayName: _displayNameTextEditingController.text,
      username: _userNameTextEditingController.text,
      location: _locationTextEditingController.text,
      headline: _oneLinerTextEditingController.text,
      profilePictureKey: profileImage.value
    ));



  }

  /// when user taps on location, the keypad does not show so navigate to location helper page
  _onLocationTextFieldTapped() async {
    // final city = await context.router.push(SelectLocationPageRoute(pageTitle: '')) as String?;

    final location = await pushScreen(context, LocationsPage(initialLocation: _locationTextEditingController.text,));

    if (location == null) {
      return;
    }

    _locationTextEditingController.text = location as String;
    if(_locationTextEditingController.text.isNotEmpty){
      showClearLocationBtn.value = true;
    }

  }

  @override
  void dispose() {
    super.dispose();
    _emailTextEditingController.dispose();
    _displayNameTextEditingController.dispose();
    _userNameTextEditingController.dispose();
    _locationTextEditingController.dispose();
    _oneLinerTextEditingController.dispose();
    authStateStreamSubscription.cancel();
  }

}