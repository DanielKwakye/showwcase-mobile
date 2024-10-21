// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProjectsModelCWProxy {
  ProjectsModel newProjects(int? newProjects);

  ProjectsModel projectsViews(int? projectsViews);

  ProjectsModel projectsInteractions(int? projectsInteractions);

  ProjectsModel projectsStreak(int? projectsStreak);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ProjectsModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ProjectsModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ProjectsModel call({
    int? newProjects,
    int? projectsViews,
    int? projectsInteractions,
    int? projectsStreak,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfProjectsModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfProjectsModel.copyWith.fieldName(...)`
class _$ProjectsModelCWProxyImpl implements _$ProjectsModelCWProxy {
  const _$ProjectsModelCWProxyImpl(this._value);

  final ProjectsModel _value;

  @override
  ProjectsModel newProjects(int? newProjects) => this(newProjects: newProjects);

  @override
  ProjectsModel projectsViews(int? projectsViews) =>
      this(projectsViews: projectsViews);

  @override
  ProjectsModel projectsInteractions(int? projectsInteractions) =>
      this(projectsInteractions: projectsInteractions);

  @override
  ProjectsModel projectsStreak(int? projectsStreak) =>
      this(projectsStreak: projectsStreak);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ProjectsModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ProjectsModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ProjectsModel call({
    Object? newProjects = const $CopyWithPlaceholder(),
    Object? projectsViews = const $CopyWithPlaceholder(),
    Object? projectsInteractions = const $CopyWithPlaceholder(),
    Object? projectsStreak = const $CopyWithPlaceholder(),
  }) {
    return ProjectsModel(
      newProjects: newProjects == const $CopyWithPlaceholder()
          ? _value.newProjects
          // ignore: cast_nullable_to_non_nullable
          : newProjects as int?,
      projectsViews: projectsViews == const $CopyWithPlaceholder()
          ? _value.projectsViews
          // ignore: cast_nullable_to_non_nullable
          : projectsViews as int?,
      projectsInteractions: projectsInteractions == const $CopyWithPlaceholder()
          ? _value.projectsInteractions
          // ignore: cast_nullable_to_non_nullable
          : projectsInteractions as int?,
      projectsStreak: projectsStreak == const $CopyWithPlaceholder()
          ? _value.projectsStreak
          // ignore: cast_nullable_to_non_nullable
          : projectsStreak as int?,
    );
  }
}

extension $ProjectsModelCopyWith on ProjectsModel {
  /// Returns a callable class that can be used as follows: `instanceOfProjectsModel.copyWith(...)` or like so:`instanceOfProjectsModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ProjectsModelCWProxy get copyWith => _$ProjectsModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectsModel _$ProjectsModelFromJson(Map<String, dynamic> json) =>
    ProjectsModel(
      newProjects: json['newProjects'] as int?,
      projectsViews: json['projectsViews'] as int?,
      projectsInteractions: json['projectsInteractions'] as int?,
      projectsStreak: json['projectsStreak'] as int?,
    );

Map<String, dynamic> _$ProjectsModelToJson(ProjectsModel instance) =>
    <String, dynamic>{
      'newProjects': instance.newProjects,
      'projectsViews': instance.projectsViews,
      'projectsInteractions': instance.projectsInteractions,
      'projectsStreak': instance.projectsStreak,
    };
