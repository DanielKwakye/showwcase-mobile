import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/models/user_tab_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/personal/personal_about_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/personal/personal_credentials_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/personal/personal_experiences_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/personal/personal_featured_projects_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/personal/personal_professionalism_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/personal/personal_profile_communities_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/personal/personal_profile_repositories_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/personal/personal_tech_stack_widget.dart';

class PersonalProfileModulesTabview extends StatefulWidget {

  final UserTabModel tabModel;
  const PersonalProfileModulesTabview({Key? key, required this.tabModel}) : super(key: key);

  @override
  PersonalProfileModulesTabviewController createState() => PersonalProfileModulesTabviewController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _PersonalProfileModulesTabviewView extends WidgetView<PersonalProfileModulesTabview, PersonalProfileModulesTabviewController> {

  const _PersonalProfileModulesTabviewView(PersonalProfileModulesTabviewController state) : super(state);

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 0, bottom:  kToolbarHeight + (kToolbarHeight  / 2)),
      child: SeparatedColumn(
        separatorBuilder: (BuildContext context, int index) {
          return const CustomBorderWidget(top: 0, bottom: 0,);
        },
        children: widget.tabModel.modules.where(
                //! we add this filter so that the UI doesn't create spaces for unhandled module types
                (element) => ["about", "professionalism", "experiences", "credentials", "stacks", "github_repo", "communities", "pinned_shows"].contains(element.type)
        ).map((module) {

          if(module.type == "about"){

            return const Padding(padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: PersonalAboutWidget());

          }
          else if(module.type == "professionalism") {
            return const Padding(padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: PersonalProfessionalismWidget());
          }
          else if(module.type == "experiences") {
            return const Padding(padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: PersonalExperiencesWidget());
          }
          else if(module.type == "communities") {
            return const Padding(padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: PersonalProfileCommunitiesWidget());
          }else if(module.type == "github_repo") {
            return const Padding(padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: PersonalProfileRepositoriesWidget());
          }
          else if(module.type == "stacks") {
            return const Padding(padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: PersonalTechStackWidget());
          }
          else if(module.type == "pinned_shows") {
            return const Padding(padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: PersonalFeaturedProjectsWidget());
          }
          else if(module.type == "credentials") {
            return const Padding(padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: PersonalCredentialsWidget());
          }

          return const SizedBox.shrink();
        }).toList(),
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class PersonalProfileModulesTabviewController extends State<PersonalProfileModulesTabview> {


  late UserProfileCubit userCubit;

  @override
  Widget build(BuildContext context) => _PersonalProfileModulesTabviewView(this);

  @override
  void initState() {
    super.initState();
    userCubit = context.read<UserProfileCubit>();
    fetchModuleSections();
  }

  void fetchModuleSections() {
    final user = AppStorage.currentUserSession!;
    // fetch experiences
    userCubit.fetchExperiences(user);
    userCubit.fetchTechStacks(userModel: user);
    userCubit.fetchCertifications(user);
    userCubit.fetchSocials( userName: user.username!);
    userCubit.fetchUserCollaborators(pageKey: 0);
    userCubit.fetchFeaturedCommunities( userModel: user);
    userCubit.fetchGithubRepositories( userModel: user);
    userCubit.fetchFeaturedProjects( userModel: user);

  }


  @override
  void dispose() {
    super.dispose();
  }

}