// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DashboardModelCWProxy {
  DashboardModel network(NetworkModel? network);

  DashboardModel threads(DashboardThreadsModel? threads);

  DashboardModel projects(ProjectsModel? projects);

  DashboardModel lastUpdate(int? lastUpdate);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DashboardModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DashboardModel(...).copyWith(id: 12, name: "My name")
  /// ````
  DashboardModel call({
    NetworkModel? network,
    DashboardThreadsModel? threads,
    ProjectsModel? projects,
    int? lastUpdate,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDashboardModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDashboardModel.copyWith.fieldName(...)`
class _$DashboardModelCWProxyImpl implements _$DashboardModelCWProxy {
  const _$DashboardModelCWProxyImpl(this._value);

  final DashboardModel _value;

  @override
  DashboardModel network(NetworkModel? network) => this(network: network);

  @override
  DashboardModel threads(DashboardThreadsModel? threads) =>
      this(threads: threads);

  @override
  DashboardModel projects(ProjectsModel? projects) => this(projects: projects);

  @override
  DashboardModel lastUpdate(int? lastUpdate) => this(lastUpdate: lastUpdate);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DashboardModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DashboardModel(...).copyWith(id: 12, name: "My name")
  /// ````
  DashboardModel call({
    Object? network = const $CopyWithPlaceholder(),
    Object? threads = const $CopyWithPlaceholder(),
    Object? projects = const $CopyWithPlaceholder(),
    Object? lastUpdate = const $CopyWithPlaceholder(),
  }) {
    return DashboardModel(
      network: network == const $CopyWithPlaceholder()
          ? _value.network
          // ignore: cast_nullable_to_non_nullable
          : network as NetworkModel?,
      threads: threads == const $CopyWithPlaceholder()
          ? _value.threads
          // ignore: cast_nullable_to_non_nullable
          : threads as DashboardThreadsModel?,
      projects: projects == const $CopyWithPlaceholder()
          ? _value.projects
          // ignore: cast_nullable_to_non_nullable
          : projects as ProjectsModel?,
      lastUpdate: lastUpdate == const $CopyWithPlaceholder()
          ? _value.lastUpdate
          // ignore: cast_nullable_to_non_nullable
          : lastUpdate as int?,
    );
  }
}

extension $DashboardModelCopyWith on DashboardModel {
  /// Returns a callable class that can be used as follows: `instanceOfDashboardModel.copyWith(...)` or like so:`instanceOfDashboardModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DashboardModelCWProxy get copyWith => _$DashboardModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardModel _$DashboardModelFromJson(Map<String, dynamic> json) =>
    DashboardModel(
      network: json['network'] == null
          ? null
          : NetworkModel.fromJson(json['network'] as Map<String, dynamic>),
      threads: json['threads'] == null
          ? null
          : DashboardThreadsModel.fromJson(
              json['threads'] as Map<String, dynamic>),
      projects: json['projects'] == null
          ? null
          : ProjectsModel.fromJson(json['projects'] as Map<String, dynamic>),
      lastUpdate: json['lastUpdate'] as int?,
    );

Map<String, dynamic> _$DashboardModelToJson(DashboardModel instance) =>
    <String, dynamic>{
      'network': instance.network?.toJson(),
      'threads': instance.threads?.toJson(),
      'projects': instance.projects?.toJson(),
      'lastUpdate': instance.lastUpdate,
    };
