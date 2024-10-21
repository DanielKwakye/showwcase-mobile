import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class UsersHorizontalOverlappingListWidget extends StatelessWidget {

  final List<UserModel> users;
  final double size;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final double iconBorder;
  const UsersHorizontalOverlappingListWidget({required this.users,
    this.size = 30,
    Key? key,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.iconBorder = 0.0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(users.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding:  EdgeInsets.only(top: paddingTop, bottom: paddingBottom, left: paddingLeft, right: paddingRight),
      child: SizedBox(
        width: (size * 3) - (size * 3) + (size * 2.5), // the 3 is the number of CustomUserAvatarWidgets and the 15 is the padding right
        child: Stack(
          clipBehavior: Clip.none,
          children: [

            ...users.take(3).map((user) {
              final index = users.indexOf(user);
              // final left = 8.w/2 ;
              // return SizedBox.shrink();
              if(index == 0){
                return CustomUserAvatarWidget(username: user.username ?? "Showwcase", size: size, borderSize: iconBorder, networkImage: user.profilePictureKey != null ? getProfileImage(user.profilePictureKey!) : null,);
              }
              return Positioned(
                left: ((size / 2) * index),
                child: CustomUserAvatarWidget(username: user.username ?? "Showwcase", size: size,borderSize: iconBorder, networkImage: user.profilePictureKey != null ?  getProfileImage(user.profilePictureKey!) : null),
              );

            })

          ],
        ),
      ),
    );
  }
}
