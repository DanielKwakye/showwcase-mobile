import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
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
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_network_image_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_activity_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/presentation/pages/personal/personal_status_page.dart';

class EditProfilePage extends StatefulWidget {

  const EditProfilePage({Key? key}) : super(key: key);

  @override
  EditProfilePageController createState() => EditProfilePageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _EditProfilePageView extends WidgetView<EditProfilePage, EditProfilePageController> {

  const _EditProfilePageView(EditProfilePageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        top: false,bottom: true,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              width: double.infinity,
              height: 260,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ValueListenableBuilder<String?>(
                    valueListenable: state.coverImage,
                    builder: (BuildContext context, coverImage, Widget? child) {
                      return SizedBox(
                        height: 200,
                        child: GestureDetector(
                          onTap: () {
                            state.setCoverImage();
                          },
                          behavior: HitTestBehavior.deferToChild,
                          child: Stack(
                            children: [

                              /// Default image
                              SizedBox(
                                width: double.infinity, height: double.infinity,
                                child: Image.asset('assets/img/settings_background.png', fit: BoxFit.cover,),
                              ),

                              /// Actual cover image
                              if(!coverImage.isNullOrEmpty()) ... {
                                SizedBox(
                                  width: double.infinity, height: double.infinity,
                                  child: CustomNetworkImageWidget(imageUrl: coverImage!, fit: BoxFit.cover,),
                                ),
                              },


                              const Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              /// upload background image progress
                              BlocSelector<FileManagerCubit, FileManagerState, FileItem?>(
                                selector: (fileManagerState) {
                                  return fileManagerState.fileItems.firstWhereOrNull(
                                        (element) => element.groupId == state.fileUploadGroupId && element.fileTag == 0,
                                  );
                                },
                                builder: (context, fileItem) {
                                  if(fileItem?.status == FileItemStatus.inProgress) {
                                    return  const Align(
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(color: kAppWhite, strokeWidth: 2,),
                                    );
                                  }

                                  return const SizedBox.shrink();
                                },
                              )

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    left: 15,
                    child: GestureDetector(
                      onTap: () {
                        state.setProfilePicture();
                      },
                      child: ValueListenableBuilder<String?>(
                        valueListenable: state.profileImage,
                        builder: (BuildContext context, String? profileImage, Widget? child) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(left: 0.0,),
                                child: CustomUserAvatarWidget(
                                  username: AppStorage.currentUserSession!.username ?? '',
                                  networkImage: profileImage,
                                  borderColor: AppStorage.currentUserSession!.role == "community_lead" ? kAppGold
                                      : theme.colorScheme.primary,
                                  size: 120,
                                ),
                              ),

                              /// upload profile pic progress
                              BlocSelector<FileManagerCubit, FileManagerState, FileItem?>(
                                selector: (fileManagerState) {
                                  return fileManagerState.fileItems.firstWhereOrNull(
                                        (element) => element.groupId == state.fileUploadGroupId && element.fileTag == 1,
                                  );
                                },
                                builder: (context, fileItem) {
                                  if(fileItem?.status == FileItemStatus.inProgress) {
                                    return const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(color: kAppWhite, strokeWidth: 2,),
                                    );
                                  }
                                  return const Padding(
                                    padding: EdgeInsets.only(left: 0.0),
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),


                            ],
                          );
                        },
                      ),
                    ),
                  ),

                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                child: Column(
                   children: [
                     CustomTextFieldWidget(
                       label: 'Display name *',
                       controller: state._displayNameTextEditingController,
                       placeHolder: 'eg. Jones',
                       validator: state.isRequired,
                     ),
                     const SizedBox(
                       height: 15,
                     ),
                     CustomTextFieldWidget(
                       label: 'Location',
                       controller: state._locationTextEditingController,
                       placeHolder: '',
                       readOnly: true,
                       onTap: state.setLocation,
                     ),
                     const SizedBox(
                       height: 15,
                     ),
                    ValueListenableBuilder<String?>(valueListenable: state.statusEmoji, builder: (_, emoji, __) {
                      return  CustomTextFieldWidget(
                        label: 'Set a status *',
                        controller: state._statusTextEditingController,
                        placeHolder: '',
                        readOnly: true,
                        prefixIcon: Padding(padding: const EdgeInsets.all(15), child: Text(emoji ?? '')),
                        onTap: state.setStatus,
                        validator: state.isRequired,
                      );
                    }),
                     const SizedBox(
                       height: 15,
                     ),
                     CustomTextFieldWidget(
                       label: 'One liner',
                       controller: state._oneLinerTextEditingController,
                       placeHolder: '',
                     ),
                     const SizedBox(
                       height: 15,
                     ),
                     BlocBuilder<AuthCubit, AuthState>(
                       builder: (ctx, authState) {
                         return CustomButtonWidget(
                           text: 'Save changes',
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

                   ],
                ),
              ),
            )

          ],
        ),
      ),
    );
    
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class EditProfilePageController extends State<EditProfilePage> with FormMixin {

  final ValueNotifier<String?> coverImage = ValueNotifier(null);
  final ValueNotifier<String?> profileImage = ValueNotifier(null);
  late FileManagerCubit fileManagerCubit;
  late AuthCubit authCubit;
  late StreamSubscription<AuthState> authStateStreamSubscription;
  final TextEditingController _displayNameTextEditingController = TextEditingController();
  final TextEditingController _locationTextEditingController = TextEditingController();
  final TextEditingController _statusTextEditingController = TextEditingController(); // we're using the TextEditingController because of the text part of the status
  final ValueNotifier<String?> statusEmoji = ValueNotifier(null); // we're using the valueNotifier because of the emoji part of the status
  final TextEditingController _oneLinerTextEditingController = TextEditingController();
  final String fileUploadGroupId = "personal_edit_profile_page";

  @override
  Widget build(BuildContext context) => _EditProfilePageView(this);

  @override
  void initState() {
    super.initState();
    fileManagerCubit = context.read<FileManagerCubit>();
    authCubit = context.read<AuthCubit>();
    authStateStreamSubscription = authCubit.stream.listen((event) {
        if(event.status == AuthStatus.updateAuthUserDataFailed) {
          context.showSnackBar(event.message);
        }
        if(event.status == AuthStatus.updateAuthUserDataSuccessful) {
          // done
          // context.pop();
          context.showSnackBar("Profile updated!");
        }
    });

    initialize();
  }

  initialize() {
    final user = AppStorage.currentUserSession!;
    coverImage.value = profileCoverImageUrl(profileCoverImageKey: user.profileCoverImageKey);
    profileImage.value = user.profilePictureKey;
    _displayNameTextEditingController.text = user.displayName ?? '';
    _locationTextEditingController.text = user.location ?? '';
    statusEmoji.value = user.activity?.emoji;
    _statusTextEditingController.text = user.activity?.message ?? '';
    _oneLinerTextEditingController.text = user.headline ?? '';
  }

  void setProfilePicture() async {

    final imageUrl = await _getImage(tag: 1);

    if(imageUrl == null){
      return;
    }
    profileImage.value = imageUrl;
    // save on the server ----
    authCubit.updateAuthUserData(AppStorage.currentUserSession!.copyWith(
      profilePictureKey: profileImage.value,
    ));
  }

  void setCoverImage() async {

    final imageUrl = await _getImage(tag: 0);

    if(imageUrl == null){
      return;
    }
    coverImage.value = imageUrl;

    // save on the server ----
    authCubit.updateAuthUserData(AppStorage.currentUserSession!.copyWith(
        profileCoverImageKey: coverImage.value,
    ));
  }

  Future<String?> _getImage({required int tag}) async {

    final files = await pickFilesFromGallery(context);
    if(files == null || files.isEmpty) {
      return null;
    }

    final croppedImage = await cropImage(files[0].path, cropStyle: tag == 0 ?  CropStyle.rectangle :  CropStyle.circle);
    if(croppedImage == null){
      return null;
    }

    // upload cover image
    final either = await fileManagerCubit.uploadImage(file: croppedImage, bucketName: profilePictureBucket, fileTag: tag, groupId: fileUploadGroupId);
    if(!mounted){
      return null;
    }
    if(either.isLeft()){
      context.showSnackBar("Upload failed");
      return null;
    }

    // successful
    final fileItem = either.asRight();
    // set the profileImage to the current user session
    if(fileItem.preSignedUrl?.url == null){
      context.showSnackBar("Upload failed");
      return null;
    }

    final pImageKey = fileItem.preSignedUrl?.preSignedUrlFields?.key;
    if(pImageKey == null){
      context.showSnackBar("Upload failed");
      return null;
    }

    final pImage = getProfileImage(pImageKey);
    return pImage;

  }

  void setLocation() async {

   final location =  await pushScreen(context, const LocationsPage()) as String?;
   if(location == null){
     return;
   }
   _locationTextEditingController.text = location;

  }

  void setStatus() async {

    final activity = UserActivityModel(
      emoji: statusEmoji.value,
      message: _statusTextEditingController.text
    );

   final activityReturned = await pushScreen(context, PersonalStatusPage(activity: activity,)) as UserActivityModel?;
   if(activityReturned == null){
     return;
   }

   statusEmoji.value = activityReturned.emoji;
   _statusTextEditingController.text = activityReturned.message ?? '';

  }

  void _handleSubmit(BuildContext ctx) {
    if(!validateAndSaveOnSubmit(ctx)) {
      return;
    }
    authCubit.updateAuthUserData(AppStorage.currentUserSession!.copyWith(
        profileCoverImageKey: coverImage.value,
        profilePictureKey: profileImage.value,
        displayName: _displayNameTextEditingController.text,
        location: _locationTextEditingController.text,
        activity: UserActivityModel(
          emoji: statusEmoji.value,
          message: _statusTextEditingController.text
        ),
        headline: _oneLinerTextEditingController.text
    ));
  }


  @override
  void dispose() {
    super.dispose();
    _displayNameTextEditingController.dispose();
    _locationTextEditingController.dispose();
    _statusTextEditingController.dispose();
    _oneLinerTextEditingController.dispose();
    authStateStreamSubscription.cancel();
  }

}