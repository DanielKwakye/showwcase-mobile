import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_certification_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_experience_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_repository_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_tab_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_tech_stack_model.dart';

part 'user_profile_model.g.dart';

@CopyWith()
class UserProfileModel extends Equatable {

  final String? username;
  final UserModel? userInfo;
  final List<UserTabModel> tabs;
  final List<UserRepositoryModel> userRepositories;
  final List<UserModel> workedWiths;
  final List<UserTechStackModel> techStacks;
  final List<UserExperienceModel> experiences;
  final List<UserCertificationModel> certifications;
  final List<CommunityModel> featuredCommunities;
  final List<UserRepositoryModel> featuredRepositories;
  final List<ShowModel> featuredProjects;

  const UserProfileModel({
    this.username,
    this.userInfo,
    this.tabs = const [],
    this.userRepositories = const [],
    this.workedWiths = const [],
    this.techStacks = const [],
    this.experiences = const [],
    this.certifications = const [],
    this.featuredCommunities = const [],
    this.featuredRepositories = const [],
    this.featuredProjects = const []
  });

  @override
  List<Object?> get props => [username, userInfo, tabs];


}