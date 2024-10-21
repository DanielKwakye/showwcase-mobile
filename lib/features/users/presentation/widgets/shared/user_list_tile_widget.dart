import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_enums.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';


class UserListTileWidget extends StatelessWidget {

  final UserModel userModel;
  final bool showFollowButton;
  final bool disableOnTap ;
  final bool showHeadLine;
  final String? subTitleText;
  final Widget? subTitleWidget;
  final bool showUsername;
  const UserListTileWidget({Key? key, required this.userModel,
    this.showFollowButton = true,
    this.showHeadLine = true,
    this.showUsername = true,
    this.subTitleText,
    this.subTitleWidget,
    this.disableOnTap = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// /// This will cause a rebuild anytime user is properties are updated
    return BlocSelector<UserProfileCubit, UserProfileState, UserModel?>(
      selector: (state) {
        //! this user may or may not be part of users interest
        return state.userProfiles.firstWhereOrNull((element) => element.username == userModel.username)?.userInfo;
      },
      builder: (context, UserModel? updatedUser) {
        final user = updatedUser ?? userModel;
        return Theme(
          data: theme.copyWith(
            // remove splash effect
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: GestureDetector(
            onTap: !disableOnTap ? () => handleProfileTap(context, user) : null,
            behavior: HitTestBehavior.opaque,
            child: Row(
               children: [

                 /// leading
                 CustomUserAvatarWidget(
                   size: 45,
                   username: user.username,
                   networkImage: user.profilePictureKey ?? '',),

                 const SizedBox(width: 5,),

                 Expanded(child: SeparatedColumn(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   separatorBuilder: (BuildContext context, int index) {
                     return const SizedBox(height: 2,);
                   },
                   children: [

                     /// Title
                     Text('${user.displayName}', style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w600, fontSize: 14)),

                     /// subTitle 1
                     if(showUsername) ... {
                       Text(
                         '@${user.username}', style: TextStyle(
                           color: theme.colorScheme.onPrimary,
                           fontWeight: FontWeight.w400,
                           fontSize: 12),
                         overflow: TextOverflow.ellipsis,
                       ),
                     },

                     // subTitle 2
                     if(showHeadLine) ... {
                       if(user.headline != null && user.headline!.isNotEmpty) ... {
                         Text(
                           '${user.headline}',
                           style: TextStyle(
                               color: theme.colorScheme.onPrimary,
                               fontWeight: FontWeight.w400,
                               fontSize: 12),
                           overflow: TextOverflow.ellipsis,
                         )
                       },
                     },

                     if(!subTitleText.isNullOrEmpty()) ... {
                        Text(
                        '$subTitleText',
                        style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w400,
                        fontSize: 12),
                        )
                     },

                     if (subTitleWidget != null) ... {
                       subTitleWidget!
                     }

                   ],
                 )),

                   if( ((user.username != AppStorage.currentUserSession?.username) && showFollowButton )) ... {
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: CustomButtonWidget(
                          text: (user.isFollowed != null && user.isFollowed != false) ? 'Following' : 'Follow',
                          appearance: (user.isFollowed != null && user.isFollowed != false) ? Appearance.secondary : Appearance.primary,
                          backgroundColor: (user.isFollowed != null && user.isFollowed != false) ? kAppBlue.withOpacity(0.1) : null,
                          textColor: (user.isFollowed != null && user.isFollowed != false) ? kAppBlue : null,
                          onPressed: () => handleFollowButtonTap(context, user),
                        ),
                      )
                  }



               ],
            ),
          )

        );
      },
    );
  }


  // when this button is tapped, user is added to the usersCubit (user of interest) and page rebuids
  void handleFollowButtonTap(BuildContext context, UserModel user) {
    var isFollowedStatus = false;
    if(user.isFollowed != null && user.isFollowed != false) {
      isFollowedStatus = true;
    }
    context.read<UserProfileCubit>().followAndUnfollowUser(userInfo: userModel, action: isFollowedStatus ? FollowerAction.unfollow : FollowerAction.follow);
  }

  // this navigates user to profile page
  void handleProfileTap(BuildContext context, UserModel user) {
    pushToProfile(context, user: user);
  }
}


