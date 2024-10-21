import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/circles/data/bloc/circles_cubit.dart';
import 'package:showwcase_v3/features/circles/data/bloc/circles_enums.dart';
import 'package:showwcase_v3/features/circles/data/bloc/circles_state.dart';
import 'package:showwcase_v3/features/circles/data/models/circle_reason_model.dart';
import 'package:showwcase_v3/features/circles/data/models/send_circle_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_dropdown.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class CollaborationRequestPage extends StatefulWidget {
  final UserModel userModel;

  const CollaborationRequestPage({Key? key, required this.userModel})
      : super(key: key);

  @override
  CollaborationRequestPageController createState() =>
      CollaborationRequestPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class CollaborationRequestPageView extends WidgetView<CollaborationRequestPage,
    CollaborationRequestPageController> {
  const CollaborationRequestPageView(CollaborationRequestPageController state,
      {super.key})
      : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Collaboration Request',
          style: TextStyle(
              color: theme(context).colorScheme.onBackground, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme(context).colorScheme.onBackground,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: state._isLoading,
            builder: (BuildContext context, bool value, Widget? child) {
              return value
                  ?  const Center(
                  child: Row(
                    children: [
                      SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator.adaptive(
                            valueColor: AlwaysStoppedAnimation<Color>(kAppBlue),
                            strokeWidth: 1,
                          )),
                      SizedBox(
                        width: 20,
                      )
                    ],
                  ))
                  : TextButton(
                  onPressed: () {
                    sendCircleRequest(context);

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
      body: BlocListener<CirclesCubit, CirclesState>(
        bloc: state._circlesCubit,
        listener: (context, circlesState) {
          if (circlesState.status == CircleStatus.sendCircleInviteFailed) {
           state._isLoading.value = false ;
            context.showSnackBar(circlesState.message,appearance: Appearance.error);
          }
          if (circlesState.status == CircleStatus.sendCircleInviteInProgress) {
            state._isLoading.value = true ;
          }

          if(circlesState.status == CircleStatus.sendCircleInviteCompleted){
            state._isLoading.value = false ;
            context.showSnackBar('Circle Request Sent Successfully');
            UserModel updatedUserModel = widget.userModel.copyWith(isColleague: 'requesting');
            context.read<UserProfileCubit>().setUserInfo(userInfo: updatedUserModel);
            Navigator.pop(context);
          }
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          // mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send Collaboration Request',
              style: TextStyle(
                  color: theme(context).colorScheme.onBackground, fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Build a quality network by connecting only with people you know.',
              style: TextStyle(
                  color: theme(context).colorScheme.onPrimary, fontSize: 13),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'How do you know, ${widget.userModel.displayName}?',
              style: TextStyle(
                  color: theme(context).colorScheme.onBackground,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocSelector<CirclesCubit, CirclesState, List<CircleReasonModel>>(
              selector: (state) {
                return state.reasons;
              },
              builder: (context, reactiveList) {
                List<String> _reasonsList = reactiveList
                    .map((e) => e.name!.replaceFirst(
                        RegExp('%s'), widget.userModel.displayName!))
                    .toList();
                // _reasonsList.add(element.name!.replaceFirst(RegExp('%s'), widget.displayName));
                return ValueListenableBuilder(
                  valueListenable: state.reason,
                  builder: (BuildContext context, String value, Widget? child) {
                    return CustomDropdownWidget(
                        items: _reasonsList,
                        hintText: 'Select',
                        onChanged: (String? value) {
                          state.reason.value = value!;
                        },
                        value: value) ;
                  },

                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFieldWidget(
              controller: state._personalNote,
              label: 'Include a personal note',
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }

  void sendCircleRequest(BuildContext context) {
     FocusScope.of(context).unfocus();
    state._circlesCubit.sendCircleInvite(
        sendCircleRequest: SendCircleModel(
            note: state._personalNote.text,
            reason: state.reason.value,
            userId: widget.userModel.id!));

  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class CollaborationRequestPageController
    extends State<CollaborationRequestPage> {
  late CirclesCubit _circlesCubit;
  final TextEditingController _personalNote = TextEditingController();
  final ValueNotifier<bool> _isLoading = ValueNotifier(false) ;
  final ValueNotifier<String> reason = ValueNotifier('') ;

  @override
  void initState() {
    _circlesCubit = context.read<CirclesCubit>();
    _circlesCubit.fetchReasons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => CollaborationRequestPageView(this);
}
