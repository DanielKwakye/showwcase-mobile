import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/circles/data/bloc/circles_cubit.dart';
import 'package:showwcase_v3/features/circles/data/bloc/circles_enums.dart';
import 'package:showwcase_v3/features/circles/data/bloc/circles_state.dart';
import 'package:showwcase_v3/features/notifications/data/models/notification_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class NotificationNewWorkedWithInvite extends StatefulWidget {
  final NotificationModel notificationResponse;

  const NotificationNewWorkedWithInvite(
      {required this.notificationResponse, Key? key})
      : super(key: key);

  @override
  State<NotificationNewWorkedWithInvite> createState() =>
      _NotificationNewWorkedWithInviteState();
}

class _NotificationNewWorkedWithInviteState
    extends State<NotificationNewWorkedWithInvite> {
  late CirclesCubit _circlesCubit ;

  @override
  void initState() {
    _circlesCubit = context.read<CirclesCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<UserModel> users = widget.notificationResponse.initiators ?? [];
    users = removeDuplicates(users);
    return BlocListener<CirclesCubit, CirclesState>(
      bloc: _circlesCubit,
      listener: (context, state) {
        // if(state is HandleCircleInviteLoading){
        //   _isLoading.value = true ;
        // }
        // if(state is HandleCircleInviteSuccessful){
        //   _isLoading.value = false ;
        //   setState(() {
        //
        //   });
        // }
        // if(state is HandleCircleInviteError){
        //   _isLoading.value = false ;
        //   context.showSnackBar(state.error,);
        //   setState(() {
        //
        //   });
        //
        // }
      },
      child: GestureDetector(
        onTap: (){
          // changeScreenWithConstructor(
          //     context,
          //     NetWorkPage(
          //       userId: AppStorage.currentUserSession!.id!,
          //       tabIndex: 0,
          //       userName: AppStorage.currentUserSession!.username ?? '',
          //       networkCount: [
          //         AppStorage.currentUserSession!.totalWorkedWiths ?? 0,
          //         AppStorage.currentUserSession!.totalFollowers ?? 0,
          //         AppStorage.currentUserSession!.totalFollowing ?? 0,
          //       ],
          //     ));
          context.push(context.generateRoutePath(subLocation: circlesPage), extra: {
            "user": AppStorage.currentUserSession!,
            "initialTabIndex": 0
          });
        },
        child: BlocSelector<UserProfileCubit, UserProfileState, UserModel?>(
          selector: (userProfileState) {
            return userProfileState.userProfiles.where((element) => element.username == widget.notificationResponse.initiators?.first.username).firstOrNull?.userInfo;
          },
          builder: (context, UserModel? selectedUser) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: SvgPicture.asset('assets/svg/circle.svg',height: 32)),
                const SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        spacing: 5,
                        children: [
                          ...users.map((user) => CustomUserAvatarWidget(
                            username: user.username,
                            size: 32,
                            networkImage: user.profilePictureKey,
                            borderSize: 0,
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      /// new follower
                      RichText(
                        text: TextSpan(
                          text: '',
                          style: TextStyle(
                              color: theme(context).colorScheme.onBackground,
                              fontSize: (defaultFontSize - 1)),
                          children: <TextSpan>[
                            ...widget.notificationResponse.initiators!.map((user) {
                              final index =
                              widget.notificationResponse.initiators!.indexOf(user);
                              String concatenation = '';

                              if (index == 1) {
                                if (widget.notificationResponse.initiators!.length ==
                                    2) {
                                  concatenation = ' and ';
                                } else {
                                  concatenation = ', ';
                                }
                              } else if (index > 1) {
                                if (index ==
                                    widget.notificationResponse.initiators!.length -
                                        1) {
                                  concatenation = ' and ';
                                } else {
                                  concatenation = ', ';
                                }
                              }
                              return TextSpan(
                                  text: "$concatenation${user.displayName}",
                                  style: const TextStyle(fontWeight: FontWeight.w700));
                            }),

                            if((selectedUser ?? widget.notificationResponse.initiators![0]).isColleague == 'declined') ...{

                              const TextSpan(
                                  text: ' was NOT added to your Circle ',
                                  style: TextStyle()),

                            }else if ((selectedUser ?? widget.notificationResponse.initiators![0]).isColleague == 'active') ... {

                              const TextSpan(
                                  text: ' has been added to your Circle ',
                                  style: TextStyle()),

                            }else ... {

                              const TextSpan(
                                  text: ' would like to add you to their Circle ',
                                  style: TextStyle()),

                            },

                            TextSpan(
                                text:
                                '"${widget.notificationResponse.data?.reason ?? ''}"',
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if(!((selectedUser ?? widget.notificationResponse.initiators![0]).isColleague == 'declined' || (selectedUser ?? widget.notificationResponse.initiators![0]).isColleague == 'active')) ... {
                        BlocConsumer<CirclesCubit, CirclesState>(
                          builder: (context, circleState) {
                            if(circleState.status == CircleStatus.handleCircleInviteInProgress) {
                              return const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator.adaptive(
                                    valueColor: AlwaysStoppedAnimation<Color>(kAppBlue),
                                    strokeWidth: 2,
                                  )
                              );
                            }
                            return Row(
                              children: [
                                CustomButtonWidget(
                                  text: 'Accept',
                                  onPressed: () {
                                    _circlesCubit.handleCircleInvite(selectedUser ?? widget.notificationResponse.initiators!.first, userId: widget.notificationResponse.initiators![0].id!, circleAction: CirclesBroadcastAction.circleRequestAccepted);
                                  },
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                CustomButtonWidget(
                                  appearance: Appearance.clean,
                                  backgroundColor:
                                  theme(context).brightness == Brightness.dark
                                      ? const Color(0xff202021)
                                      : const Color(0xffF7F7F7),
                                  text: 'Ignore',
                                  onPressed: () {
                                    _circlesCubit.handleCircleInvite(selectedUser ?? widget.notificationResponse.initiators!.first, userId: widget.notificationResponse.initiators![0].id!, circleAction: CirclesBroadcastAction.circleRequestRejected);

                                  },
                                ),
                              ],
                            ) ;
                          }, listener: circlesStateListener,
                        )
                      },
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        )
        ,
      ),
    );
  }

  void circlesStateListener (BuildContext context, CirclesState state) {

    if(state.status == CircleStatus.handleCircleInviteFailed) {
      context.showSnackBar(state.message);
    }
    if(state.status == CircleStatus.handleCircleInviteCompleted) {
      if(state.data == "accept") {
        context.showSnackBar("Circle request accepted");
      }
      else if (state.data == "decline") {
        context.showSnackBar("Circle request declined");


      }


    }
  }
}
