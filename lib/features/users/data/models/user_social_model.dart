import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/users/data/models/user_link_model.dart';

part 'user_social_model.g.dart';

@CopyWith()
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class UserSocialModel extends Equatable {
  final List<UserLinkModel>? links;
  final int? userId;

  const UserSocialModel({
    this.links,
    this.userId,
  });
  /// Connect the generated [_$UserSettingsModelFromJson] function to the `fromJson`
  /// factory.
  factory UserSocialModel.fromJson(Map<String, dynamic> json) => _$UserSocialModelFromJson(json);

  /// Connect the generated [_$UserSettingsModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserSocialModelToJson(this);


  
  @override
  List<Object?> get props => [links, userId];
}

