import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_item_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class PublicFeaturedProjectsWidget extends StatelessWidget {

  final UserModel userModel;
  const PublicFeaturedProjectsWidget({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    return BlocSelector<UserProfileCubit, UserProfileState, List<ShowModel>?>(
      selector: (userState) {
        final userProfiles = userState.userProfiles;
        final index = userProfiles.indexWhere((element) => element.username == userModel.username);
        if(index < 0){
          return null;
        }
        return userProfiles[index].featuredProjects;
      },
      builder: (context, featuredProjects) {

        if((featuredProjects ?? []).isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            const Row(
              children: [
                Text(
                  'Featured Shows',
                  style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            if((featuredProjects ?? []).isEmpty) ...{
              const SizedBox.shrink()
            }else ... {
              const SizedBox(height: 15,),
              ListView.separated(
                separatorBuilder: (_, index){
                  return Container(
                    height: 7,
                    color: theme.brightness == Brightness.light ? theme.colorScheme.surface : theme.colorScheme.background,
                  );
                },
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: featuredProjects!.length,
                itemBuilder: (context, index) {

                  final show = featuredProjects[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    color: theme.brightness == Brightness.dark ? kAppBlack : kAppWhite,
                    child: ShowItemWidget(showModel: show, showActionBar: false,pageName: 'profile_featured_shows',)
                  );

                },
              )

            }
          ],
        );
      },
    );
  }
}
