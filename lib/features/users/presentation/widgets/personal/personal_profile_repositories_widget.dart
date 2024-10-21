import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:github_colour/github_colour.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_repository_model.dart';

class PersonalProfileRepositoriesWidget extends StatelessWidget {
  const PersonalProfileRepositoriesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocSelector<UserProfileCubit, UserProfileState, List<UserRepositoryModel>?>(
      selector: (userState) {
        final currentUser = AppStorage.currentUserSession!;
        final userProfiles = userState.userProfiles;
        final index = userProfiles.indexWhere((element) => element.username == currentUser.username);
        if(index < 0){
          return null;
        }
        return userProfiles[index].featuredRepositories;
      },
      builder: (context, allRepos) {


        if((allRepos ?? []).isEmpty) {
          return const SizedBox.shrink();
        }

        final repos = allRepos!.where((element) => !element.description.isNullOrEmpty()).toList();

        if(repos.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            const Row(
              children: [
                Text(
                  'Repositories',
                  style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                // const Spacer(),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(100),
                //   child:  Container(
                //     width: 35,
                //     height: 35,
                //     color: theme.colorScheme.outline,
                //     child: IconButton(
                //       icon: Icon(techStacks.isEmpty ? Icons.add : Icons.edit, size: techStacks.isEmpty ? 16 : 12, color: theme.colorScheme.onBackground,),
                //       onPressed: () {
                //         pushScreen(context, const PersonalTechStackEditorPage());
                //       },
                //     ),
                //   ),
                // ),

              ],
            ),
            if((repos ?? []).isEmpty) ...{
              const SizedBox.shrink()
            }else ... {
              const SizedBox(height: 0,),

              ListView.separated(
                separatorBuilder: (_, index){
                  return const SizedBox(height: 20,);
                },
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: repos!.length,
                itemBuilder: (context, index) {
                  final item = repos[index];
                  return Container(
                    padding: const EdgeInsets.only(bottom: 0),
                    // decoration: BoxDecoration(
                    //   border: index != (length - 1) ? Border(bottom: BorderSide(color: theme.colorScheme.outline)) : null
                    // ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                          visualDensity: const VisualDensity(vertical: VisualDensity.maximumDensity),
                          onTap: () {
                            if(item.htmlUrl != null){
                              context.push(browserPage, extra: item.htmlUrl!);
                            }
                          },
                          title: Row(
                            children: [
                              Icon(Icons.library_books_outlined, size: 14, color: theme.colorScheme.onBackground,),
                              const SizedBox(width: 10,),
                              Text(item.name ?? '', style: const TextStyle(color: Colors.blue, fontSize: defaultFontSize, fontWeight: FontWeight.w600))
                            ],
                          ),
                          subtitle: item.description != null  ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(item.description ?? '', style: TextStyle(color: theme.colorScheme.onPrimary),),
                          ) : null,
                        ),
                        // const SizedBox(height: 5,),
                        Row(
                          children: [
                            if(!item.language.isNullOrEmpty()) ...{
                              _repoLanguage(item.language!, theme),
                              const SizedBox(width: 20,),
                            },
                            if(item.stargazerCount != null) ... {
                              _repoStar(item.stargazerCount!.toString(), theme),
                              const SizedBox(width: 20,),
                            },
                            if(item.forks != null) ...{
                              _repoFork(item.forks!.toString(), theme),
                            }

                          ],
                        ),

                      ],
                    ),
                  );
                },
              )

            }
          ],
        );
      },
    );
  }


  Widget _repoLanguage(String language, ThemeData theme){
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:  BoxDecoration(
            color: GitHubColour.getExistedInstance().containsKey(language)
                ? GitHubColour.getExistedInstance()[language]
                : kAppBlue,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        const SizedBox(width: 10,),
        Text(language, style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: defaultFontSize - 2),)
      ],
    );
  }

  Widget _repoStar(String count, ThemeData theme){
    return Row(
      children: [
        SvgPicture.asset(kStarIconSvg, width: 15,),
        const SizedBox(width: 10,),
        Text(count, style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: defaultFontSize - 2),)
      ],
    );
  }

  Widget _repoFork(String count, ThemeData theme){
    return Row(
      children: [
        SvgPicture.asset(kForkIconSvg, width: 12,),
        const SizedBox(width: 10,),
        Text(count, style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: defaultFontSize - 2),)
      ],
    );
  }

}
