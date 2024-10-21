import 'package:json_annotation/json_annotation.dart';

part 'shared_repository_collaborator_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SharedRepositoryCollaboratorModel {
  const SharedRepositoryCollaboratorModel({
    this.login,
    this.id,
    this.nodeId,
    this.avatarUrl,
    this.gravatarId,
    this.url,
    this.htmlUrl,
    this.followersUrl,
    this.followingUrl,
    this.gistsUrl,
    this.starredUrl,
    this.subscriptionsUrl,
    this.organizationsUrl,
    this.reposUrl,
    this.eventsUrl,
    this.receivedEventsUrl,
    this.type,
    this.siteAdmin,
    this.contributions,
  });

  final String? login;
  final int? id;
  final String? nodeId;
  final String? avatarUrl;
  final String? gravatarId;
  final String? url;
  final String? htmlUrl;
  final String? followersUrl;
  final String? followingUrl;
  final String? gistsUrl;
  final String? starredUrl;
  final String? subscriptionsUrl;
  final String? organizationsUrl;
  final String? reposUrl;
  final String? eventsUrl;
  final String? receivedEventsUrl;
  final String? type;
  final bool? siteAdmin;
  final int? contributions;

  factory SharedRepositoryCollaboratorModel.fromJson(Map<String, dynamic> json) => _$SharedRepositoryCollaboratorModelFromJson(json);
  Map<String, dynamic> toJson() => _$SharedRepositoryCollaboratorModelToJson(this);
  
}