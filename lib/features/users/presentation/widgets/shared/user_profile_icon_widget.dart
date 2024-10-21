import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/mix/launch_external_app_mixin.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';


class UserProfileIconWidget extends StatelessWidget with LaunchExternalAppMixin {
  
  final UserModel user;
  final double? size;
  final String? dimension;
  final String? networkImage;
  const UserProfileIconWidget({required this.user, this.dimension, this.size, this.networkImage, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushToProfile(context, user: user);
      },
      child: CustomUserAvatarWidget(username: user.displayName ?? '',
        networkImage: networkImage ?? user.profilePictureKey,
        borderSize: user.role == "community_lead" ? 2 : 0,
        borderColor: user.role == "community_lead" ?  kAppGold : null,
        size: size ?? 40,
        dimension: dimension,
      ),
    );
  }
}
