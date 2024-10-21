import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showwcase_v3/core/mix/launch_external_app_mixin.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_social_model.dart';

class PublicSocialWidget extends StatelessWidget with LaunchExternalAppMixin{
  final String username;
  const PublicSocialWidget({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocSelector<UserProfileCubit, UserProfileState, UserSocialModel?>(
      selector: (userState) {
        if(!userState.social.keys.contains(username)) {
          return null;
        }

        final userInfo = userState.social[username];
        return userInfo;
      },
      builder: (context, reactiveUserSocialModel) {
        if (reactiveUserSocialModel == null) {
          return const SizedBox.shrink();
        }
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
              reactiveUserSocialModel.links?.length ?? 0,
                  (index) => GestureDetector(
                onTap: () {
                  launchBrowser(reactiveUserSocialModel.links![index].value!,context);
                },
                child: FittedBox(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: theme.colorScheme.outline)),
                    child: Row(
                      children: [
                        SvgPicture.network(
                          'https://stack-icons.showwcase.com/elsewhere/${reactiveUserSocialModel.links![index].iconKey}',
                          width: 20,
                          height: 20,
                          color:
                          theme.colorScheme.onBackground.withOpacity(0.5),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${reactiveUserSocialModel.links![index].label}',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }
}
