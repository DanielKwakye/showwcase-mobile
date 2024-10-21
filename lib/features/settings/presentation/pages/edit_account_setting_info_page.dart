import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/mix/form_mixin.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/locations/presentation/pages/locations_page.dart';
import 'package:showwcase_v3/features/settings/data/bloc/settings_enums.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_activity_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/presentation/pages/personal/personal_status_page.dart';

class EditAccountSettingInfo extends StatefulWidget {


  final Set<AccountEditInfoType> infoTypesToEdit;
  const EditAccountSettingInfo({Key? key, this.infoTypesToEdit = const {}}) : super(key: key);

  @override
  EditAccountSettingInfoController createState() => EditAccountSettingInfoController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _EditAccountSettingInfoView extends WidgetView<EditAccountSettingInfo, EditAccountSettingInfoController> {

  const _EditAccountSettingInfoView(EditAccountSettingInfoController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Form(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
          actions: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (ctx, authState) {
                return UnconstrainedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: CustomButtonWidget(
                      text: 'Save',
                      loading: authState.status == AuthStatus.updateAuthUserDataInProgress,
                      expand: false,
                      appearance: Appearance.clean,
                      textColor: kAppBlue,
                      onPressed: () => state._handleSubmit(ctx),
                    ),
                  ),
                );
              },
            ),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: CustomBorderWidget(),
          ),
        ),
        body: SafeArea(
          top: false,
          bottom: true,
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SeparatedColumn(
                separatorBuilder: (BuildContext context, int index) {
                  return const  SizedBox(height: 15,);
                },
                children: [

                  if(widget.infoTypesToEdit.contains(AccountEditInfoType.userName)) ... {
                    ValueListenableBuilder<bool?>(valueListenable: state.usernameAvailable, builder: (_, usernameAvailable, __) {
                      return BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, authState) {
                          return CustomTextFieldWidget(
                            label: 'Username *',
                            placeHolder: '',
                            textCapitalization: TextCapitalization.none,
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
                  },

                  if(widget.infoTypesToEdit.contains(AccountEditInfoType.displayName)) ... {
                    CustomTextFieldWidget(
                      label: 'Display name *',
                      controller: state._displayNameTextEditingController,
                      placeHolder: 'eg. Jones',
                      validator: state.isRequired,
                    ),
                  },


                  if(widget.infoTypesToEdit.contains(AccountEditInfoType.location)) ... {
                    CustomTextFieldWidget(
                      label: 'Location',
                      controller: state._locationTextEditingController,
                      placeHolder: '',
                      readOnly: true,
                      onTap: state.setLocation,
                    ),
                  },


                  if(widget.infoTypesToEdit.contains(AccountEditInfoType.status)) ... {
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

                  },

                  if(widget.infoTypesToEdit.contains(AccountEditInfoType.oneliner)) ... {
                    CustomTextFieldWidget(
                      label: 'One liner',
                      controller: state._oneLinerTextEditingController,
                      placeHolder: '',
                    ),
                  },


                ],
              ),
            ),
          ),
        ),
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class EditAccountSettingInfoController extends State<EditAccountSettingInfo>  with FormMixin {


  late AuthCubit authCubit;
  late StreamSubscription<AuthState> authStateStreamSubscription;
  final TextEditingController _displayNameTextEditingController = TextEditingController();
  final TextEditingController _locationTextEditingController = TextEditingController();
  final TextEditingController _statusTextEditingController = TextEditingController(); // we're using the TextEditingController because of the text part of the status
  final ValueNotifier<String?> statusEmoji = ValueNotifier(null); // we're using the valueNotifier because of the emoji part of the status
  final TextEditingController _oneLinerTextEditingController = TextEditingController();
  final ValueNotifier<bool?> usernameAvailable = ValueNotifier(true); // if available, then the username can be submitted
  final TextEditingController _userNameTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) => _EditAccountSettingInfoView(this);

  @override
  void initState() {
    initialize();
    authCubit = context.read<AuthCubit>();
    authStateStreamSubscription = authCubit.stream.listen((event) {
      if(event.status == AuthStatus.updateAuthUserDataFailed) {
        context.showSnackBar(event.message);
      }
      if(event.status == AuthStatus.updateAuthUserDataSuccessful) {
        context.showSnackBar("Profile updated!");
        pop(context);
      }
    });
    super.initState();
  }

  initialize() {
    final user = AppStorage.currentUserSession!;
    _userNameTextEditingController.text = user.username ?? '';
    _displayNameTextEditingController.text = user.displayName ?? '';
    _locationTextEditingController.text = user.location ?? '';
    statusEmoji.value = user.activity?.emoji;
    _statusTextEditingController.text = user.activity?.message ?? '';
    _oneLinerTextEditingController.text = user.headline ?? '';
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

    UserModel currentUser = AppStorage.currentUserSession!;
    if(widget.infoTypesToEdit.contains(AccountEditInfoType.userName)){
      if(usernameAvailable.value == false){
        if(_userNameTextEditingController.text == currentUser.username){
          context.showSnackBar("Username already belongs to you");
          return;
        }
        context.showSnackBar("Username is already exist");
        return;
      }else {
        currentUser = currentUser.copyWith(
          username: _userNameTextEditingController.text
        );
      }
    }
    authCubit.updateAuthUserData(currentUser.copyWith(
        displayName: _displayNameTextEditingController.text,
        location: _locationTextEditingController.text,
        activity: UserActivityModel(
            emoji: statusEmoji.value,
            message: _statusTextEditingController.text
        ),
        headline: _oneLinerTextEditingController.text
    ));
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

  void setLocation() async {

    final location =  await pushScreen(context, const LocationsPage()) as String?;
    if(location == null){
      return;
    }
    _locationTextEditingController.text = location;

  }


  @override
  void dispose() {
    _displayNameTextEditingController.dispose();
    _locationTextEditingController.dispose();
    _statusTextEditingController.dispose();
    _oneLinerTextEditingController.dispose();
    authStateStreamSubscription.cancel();
    super.dispose();
  }

}