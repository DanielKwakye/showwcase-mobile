import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_tab_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/public/public_about_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/public/public_credentials_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/public/public_experiences_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/public/public_featured_projects_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/public/public_professionalism_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/public/public_profile_communities_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/public/public_profile_repositories_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/public/public_tech_stack_widget.dart';

class PublicProfileModulesTabview extends StatefulWidget {

  final UserTabModel tabModel;
  final UserModel userModel;
  const PublicProfileModulesTabview({Key? key, required this.tabModel, required this.userModel}) : super(key: key);

  @override
  PublicProfileModulesTabviewController createState() => PublicProfileModulesTabviewController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _PublicProfileModulesTabviewView extends WidgetView<PublicProfileModulesTabview, PublicProfileModulesTabviewController> {

  const _PublicProfileModulesTabviewView(PublicProfileModulesTabviewController state) : super(state);

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 0, bottom:  kToolbarHeight),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          // separatorBuilder: (BuildContext context, int index) {
          //   return const CustomBorderWidget(top: 0, bottom: 0,);
          // },
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.tabModel.modules.where(
            //! we add this filter so that the UI doesn't create spaces for unhandled module types
                  (element) => ["about", "professionalism", "experiences", "credentials", "stacks", "github_repo", "communities", "pinned_shows"].contains(element.type)
          ).map((module) {

            if(module.type == "about"){

              return Padding(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: PublicAboutWidget(userModel: widget.userModel));

            }
            else if(module.type == "professionalism") {
              return  Padding(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: PublicProfessionalismWidget(userModel: widget.userModel,));
            }
            else if(module.type == "experiences") {
              return  Padding(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: PublicExperiencesWidget(userModel: widget.userModel,));
            }
            else if(module.type == "communities") {
              return  Padding(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: PublicProfileCommunitiesWidget(userModel: widget.userModel,));
            }else if(module.type == "github_repo") {
              return  Padding(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: PublicProfileRepositoriesWidget(userModel: widget.userModel,));
            }
            else if(module.type == "stacks") {
              return  Padding(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: PublicTechStackWidget(userModel: widget.userModel,));
            }
            else if(module.type == "pinned_shows") {
              return  Padding(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: PublicFeaturedProjectsWidget(userModel: widget.userModel,));
            }
            else if(module.type == "credentials") {
              return  Padding(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child:  PublicCredentialsWidget(userModel: widget.userModel,));
            }

            return const SizedBox.shrink();
          }).toList(),
        ),
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class PublicProfileModulesTabviewController extends State<PublicProfileModulesTabview> {


  late UserProfileCubit userCubit;

  @override
  Widget build(BuildContext context) => _PublicProfileModulesTabviewView(this);

  @override
  void initState() {
    super.initState();
    userCubit = context.read<UserProfileCubit>();
    fetchModuleSections();
  }

  void fetchModuleSections() {
    // fetch experiences
    userCubit.fetchExperiences(widget.userModel);
    userCubit.fetchTechStacks(userModel: widget.userModel);
    userCubit.fetchCertifications(widget.userModel);
    userCubit.fetchSocials( userName: widget.userModel.username!);
    userCubit.fetchFeaturedCommunities( userModel: widget.userModel);
    userCubit.fetchGithubRepositories( userModel: widget.userModel);
    userCubit.fetchFeaturedProjects( userModel: widget.userModel);
    userCubit.fetchUserCollaborators(pageKey: 0, user: widget.userModel);

  }


  @override
  void dispose() {
    super.dispose();
  }

}