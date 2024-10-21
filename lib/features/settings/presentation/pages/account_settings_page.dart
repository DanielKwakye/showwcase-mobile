import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
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
import 'package:showwcase_v3/features/settings/data/bloc/settings_enums.dart';
import 'package:showwcase_v3/features/settings/presentation/pages/edit_account_setting_info_page.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_network_image_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class AccountSettingsPage extends StatefulWidget {

  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  AccountPageController createState() => AccountPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _AccountPageView extends WidgetView<AccountSettingsPage, AccountPageController> {

  const _AccountPageView(AccountPageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (_, next) {
        return
          next.status == AuthStatus.updateAuthUserSettingSuccessful ||
              next.status == AuthStatus.updateAuthUserSettingFailed ||
              next.status == AuthStatus.updateAuthUserDataSuccessful ||
              next.status == AuthStatus.updateAuthUserDataFailed ||
              next.status == AuthStatus.optimisticUpdateAuthUserDataSuccessful ||
              next.status == AuthStatus.optimisticUpdateAuthUserDataFailed;
      },
        builder: (_, __) {
          final currentUser = AppStorage.currentUserSession;
          return Scaffold(
              body: SafeArea(
                top: false,
                bottom: true,
                child: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    const CustomInnerPageSliverAppBar(pageTitle: "Account",)
                  ];
                }, body:
                ListView(
                  padding: const EdgeInsets.only(bottom: kToolbarHeight),
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
                                          username: AppStorage.currentUserSession?.username ?? '',
                                          networkImage: profileImage,
                                          borderColor: AppStorage.currentUserSession?.role == "community_lead" ? kAppGold
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
                    const SizedBox(height: 15,),
                    /// content
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Account',
                        style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    EditAccountListItem(title: 'Email', subtitle: currentUser?.email ?? '',
                      isReadOnly: true, accountEditInfoType: AccountEditInfoType.email,),
                    EditAccountListItem(
                      title: 'Display Name', subtitle: '${currentUser?.displayName}',
                      isReadOnly: false, accountEditInfoType: AccountEditInfoType.displayName,),
                    EditAccountListItem(
                      title: 'Username',
                      subtitle: '${currentUser?.username}',
                      isReadOnly: false, accountEditInfoType: AccountEditInfoType.userName,),
                    EditAccountListItem(
                      title: 'Set a Status',
                      subtitle: '${AppStorage.currentUserSession?.activity?.emoji} ${currentUser?.activity?.message}',
                      isReadOnly: false, accountEditInfoType: AccountEditInfoType.status,
                    ),
                    EditAccountListItem(
                      title: 'Location', subtitle: '${currentUser?.location}',
                      isReadOnly: false, accountEditInfoType: AccountEditInfoType.location,),
                    EditAccountListItem(
                      title: 'One-liner', subtitle: '${currentUser?.headline}',
                      isReadOnly: false, accountEditInfoType: AccountEditInfoType.headline,),

                    /// Account destruction section
                    const SizedBox(
                      height: 15,
                    ),
                    const CustomBorderWidget(),
                    const SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          _onLogoutTapped(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Logout',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: defaultFontSize,
                                    fontWeight: FontWeight.w500)),
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
                    const SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          _deleteAccountUI(context, );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Delete Account',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: defaultFontSize,
                                    fontWeight: FontWeight.w500)),
                            Icon(Icons.arrow_forward_ios,
                                size: 10, color: theme.colorScheme.onPrimary),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
                ),
              )
          );
        },
      );

  }

  void _deleteAccountUI(BuildContext context) async {

    await showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: theme(context).colorScheme.primary,
        context: context,

        builder: (ctx) {
          return SafeArea(
            bottom: true,
            top: false,
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
                      style: theme(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Are you sure you want to delete your account? This will immediately log you out and you will not be able to log in again.',
                      style: theme(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFieldWidget(
                      label: "Please type “DELETE ACCOUNT” below",
                      placeHolder: "",
                      onChange: (value) {
                        state.activateDeleteAccountButton.value = value?.toUpperCase().trim() == "DELETE ACCOUNT";
                      }
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: state.activateDeleteAccountButton,
                      builder: (ctx, bool activate, _) {
                        return BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, authState) {
                            return CustomButtonWidget(
                                text: "Delete account",
                                loading: authState.status == AuthStatus.deleteAccountLoading,
                                appearance: activate ? Appearance.error : Appearance.secondary,
                                onPressed: activate ?  state.deleteAccount : null);
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: kToolbarHeight,
                    ),
                  ],
                ),
              ),
            ),
          );
        });

      state.activateDeleteAccountButton.value = false;
  }

  void _onLogoutTapped(BuildContext context){


    showConfirmDialog(context, title: "Do you want to logout?",
      subtitle: "You'd have to login again next time you open the app",
      onConfirmTapped: () {

            context.go(walkthroughPage);
            context.read<AuthCubit>().logout();

      },
    );

  }


}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class AccountPageController extends State<AccountSettingsPage> {

  final ValueNotifier<String?> coverImage = ValueNotifier(null);
  final ValueNotifier<String?> profileImage = ValueNotifier(null);
  late FileManagerCubit fileManagerCubit;
  late AuthCubit authCubit;
  late StreamSubscription<AuthState> authStateStreamSubscription;
  final String fileUploadGroupId = "account_settings_page";
  ValueNotifier<bool> activateDeleteAccountButton = ValueNotifier(false);

  @override
  Widget build(BuildContext context) => _AccountPageView(this);

  @override
  void initState() {
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

    final user = AppStorage.currentUserSession;
    coverImage.value = profileCoverImageUrl(profileCoverImageKey: user?.profileCoverImageKey);
    profileImage.value = user?.profilePictureKey;

    super.initState();
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


  void deleteAccount() async {
    final failed = await authCubit.deleteProfile();
    if(mounted) {
      if(failed != null){
        context.showSnackBar(failed);
        return;
      }

      context.go(walkthroughPage);
      context.read<AuthCubit>().logout();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }


}


class EditAccountListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isReadOnly;
  final AccountEditInfoType accountEditInfoType;
  const EditAccountListItem({Key? key, required this.title, required this.subtitle,  this.isReadOnly = false, required this.accountEditInfoType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!isReadOnly) {
          pushScreen(context, EditAccountSettingInfo(infoTypesToEdit: {accountEditInfoType},));
        }
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
                  flex:2,
                  child: Text(title,
                      style: TextStyle(
                          color: theme(context).colorScheme.onBackground,
                          fontSize: defaultFontSize,
                          fontWeight: FontWeight.w500)),
                ),

                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          subtitle,
                          style: TextStyle(
                              color: isReadOnly ? theme(context).colorScheme.onPrimary : theme(context).colorScheme.onBackground,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(width: 15,),
                      if(!isReadOnly) Icon(Icons.arrow_forward_ios,size: 10,color: theme(context).colorScheme.onPrimary),
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
    );
  }
}