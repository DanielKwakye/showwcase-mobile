import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

// import 'package:showwcase_v3/features/dashboard/data/models/dashboard_thread_model.dart';
// import 'package:showwcase_v3/features/dashboard/data/models/network_model.dart';
// import 'package:showwcase_v3/features/dashboard/data/models/projects_model.dart';

part 'dashboard_model.g.dart';

@CopyWith()
@JsonSerializable(explicitToJson: true)
class DashboardModel extends Equatable{
const   DashboardModel({
    this.network,
    this.threads,
    this.projects,
    this.lastUpdate,
  });

  final NetworkModel? network;
  final DashboardThreadsModel? threads;
  final ProjectsModel? projects;
  final int? lastUpdate;


  factory DashboardModel.fromJson(Map<String, dynamic> json) => _$DashboardModelFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardModelToJson(this);



  @override
  List<Object?> get props => [network, threads, projects, lastUpdate];
}



class NetworkModel {
  NetworkModel({
    this.profileViews,
    this.inviteCodeUsed,
    this.newWorkedwiths,
    this.newFollowers,
  });

  int? profileViews;
  int? inviteCodeUsed;
  int? newWorkedwiths;
  int? newFollowers;

  factory NetworkModel.fromJson(Map<String, dynamic> json) => NetworkModel(
    profileViews: json["profile_views"],
    inviteCodeUsed: json["invite_code_used"],
    newWorkedwiths: json["new_workedwiths"],
    newFollowers: json["new_followers"],
  );

  Map<String, dynamic> toJson() => {
    "profile_views": profileViews,
    "invite_code_used": inviteCodeUsed,
    "new_workedwiths": newWorkedwiths,
    "new_followers": newFollowers,
  };
}

class ProjectsModel {
  ProjectsModel({
    this.newProjects,
    this.projectsViews,
    this.projectsInteractions,
    this.projectsStreak,
  });

  int? newProjects;
  int? projectsViews;
  int? projectsInteractions;
  int? projectsStreak;

  factory ProjectsModel.fromJson(Map<String, dynamic> json) => ProjectsModel(
    newProjects: json["new_projects"],
    projectsViews: json["projects_views"],
    projectsInteractions: json["projects_interactions"],
    projectsStreak: json["projects_streak"],
  );

  Map<String, dynamic> toJson() => {
    "new_projects": newProjects,
    "projects_views": projectsViews,
    "projects_interactions": projectsInteractions,
    "projects_streak": projectsStreak,
  };
}

class DashboardThreadsModel {
  DashboardThreadsModel({
    this.newThreads,
    this.threadsViews,
    this.threadsInteractions,
    this.threadsMentions,
  });

  int? newThreads;
  int? threadsViews;
  int? threadsInteractions;
  int? threadsMentions;

  factory DashboardThreadsModel.fromJson(Map<String, dynamic> json) => DashboardThreadsModel(
    newThreads: json["new_threads"],
    threadsViews: json["threads_views"],
    threadsInteractions: json["threads_interactions"],
    threadsMentions: json["threads_mentions"],
  );

  Map<String, dynamic> toJson() => {
    "new_threads": newThreads,
    "threads_views": threadsViews,
    "threads_interactions": threadsInteractions,
    "threads_mentions": threadsMentions,
  };
}
