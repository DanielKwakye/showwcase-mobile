import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'projects_model.g.dart';


@CopyWith()
@JsonSerializable(explicitToJson: true)
class ProjectsModel  extends Equatable{
 const ProjectsModel({
    this.newProjects,
    this.projectsViews,
    this.projectsInteractions,
    this.projectsStreak,
  });

 final int? newProjects;
 final int? projectsViews;
 final int? projectsInteractions;
 final  int? projectsStreak;

  factory ProjectsModel.fromJson(Map<String, dynamic> json) => _$ProjectsModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectsModelToJson(this);

  @override
  List<Object?> get props => [newProjects, projectsViews, projectsInteractions, projectsStreak];

}