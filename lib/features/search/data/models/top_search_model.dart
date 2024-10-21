import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'top_search_model.g.dart';

@JsonSerializable()
class TopSearchModel extends Equatable {

  final List<UserModel> users;
  final List<ShowModel> projects;
  final List<ThreadModel> threads;
  final List<CommunityModel> communities;

  const TopSearchModel({
    this.users = const [],
    this.projects = const [],
    this.threads = const [],
    this.communities = const []
  });

  @override
  List<Object?> get props => [];

  /// Connect the generated [_$TopSearchModelFromJson] function to the `fromJson`
  /// factory.
  factory TopSearchModel.fromJson(Map<String, dynamic> json) => _$TopSearchModelFromJson(json);

  /// Connect the generated [_$TopSearchModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TopSearchModelToJson(this);

}