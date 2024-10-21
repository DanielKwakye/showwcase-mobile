import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_enums.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_profile_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_social_model.dart';

part "user_profile_state.g.dart";

@CopyWith()
class UserProfileState extends Equatable {

  final UserStatus status;
  final String message;
  final List<UserProfileModel> userProfiles; //  all users interacted with, after opening the app. including the loggedInUser
  final Map<String,UserSocialModel> social; // social links of the loggedInUser
  final  Map<String, List<UserModel>> collaborators;
  final  Map<String, List<UserModel>> followers;
  final  Map<String, List<UserModel>> following;
  final  Map<String, List<ShowModel>> customFeaturedShows;
  final  Map<String, List<SeriesModel>> customFeaturedSeries;



  const UserProfileState( {
    this.status = UserStatus.initial,
    this.message = '',
    this.userProfiles = const [],
    this.social = const {},
    this.collaborators = const {},
    this.followers = const {},
    this.following = const {},
    this.customFeaturedShows = const {},
    this.customFeaturedSeries = const  {}
  });

  @override
  List<Object?> get props => [status, userProfiles, collaborators];

}