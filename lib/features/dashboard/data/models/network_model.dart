import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'network_model.g.dart';


@CopyWith()
@JsonSerializable(explicitToJson: true)
class NetworkModel  extends Equatable{
 const  NetworkModel({
    this.profileViews,
    this.inviteCodeUsed,
    this.newWorkedwiths,
    this.newFollowers,
  });

  final int? profileViews;
  final  int? inviteCodeUsed;
  final int? newWorkedwiths;
  final int? newFollowers;

  factory NetworkModel.fromJson(Map<String, dynamic> json) => _$NetworkModelFromJson(json);
  Map<String, dynamic> toJson() => _$NetworkModelToJson(this);

  @override
  List<Object?> get props => [profileViews, inviteCodeUsed, newWorkedwiths, newFollowers];
}