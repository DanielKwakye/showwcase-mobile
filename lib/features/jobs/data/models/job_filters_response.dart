import 'dart:convert';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'job_filters_response.g.dart';

JobFiltersResponse jobFilterResponseFromJson(String str) => JobFiltersResponse.fromJson(json.decode(str));

// String jobFilterResponseToJson(JobFiltersResponse data) => json.encode(data.toJson());

@CopyWith()
class JobFiltersResponse extends Equatable {
  const JobFiltersResponse({
    this.locations,
    this.types,
    this.positions,
    this.stacks,
    this.teamSizes,
    this.industries,
  });

  final List<Map<String, dynamic>>? locations;
  final List<Map<String, dynamic>>? types;
  final List<Map<String, dynamic>>? positions;
  final List<Map<String, dynamic>>? stacks;
  final List<Map<String, dynamic>>? teamSizes;
  final List<Map<String, dynamic>>? industries;

  factory JobFiltersResponse.fromJson(Map<String, dynamic> json) => JobFiltersResponse(
    locations: json["locations"] == null ? null : [ for (var v in json['locations'] as List )     { "filter": v, "selected" : false } ],
    types: json["types"] == null ? null : [ for (var v in json['types'] as List)                  { "filter": Type.fromJson(v), "selected" : false } ],
    positions: json["positions"] == null ? null : [ for (var v in json['positions'] as List )     {"filter": v, "selected" : false} ],
    stacks: json["stacks"] == null ? null : [ for (var v in json['stacks'] as List)               { "filter": Stack.fromJson(v), "selected" : false } ], //List<Stack>.from(json["stacks"].map((x) => Stack.fromJson(x))),
    teamSizes: json["teamSizes"] == null ? null : [ for (var v in json['teamSizes'] as List)      { "filter": TeamSize.fromJson(v), "selected" : false } ], //List<TeamSize>.from(json["teamSizes"].map((x) => TeamSize.fromJson(x))),
    industries: json["industries"] == null ? null : [ for (var v in json['industries'] as List)   { "filter": Industry.fromJson(v), "selected" : false } ] //List<Industry>.from(json["industries"].map((x) => Industry.fromJson(x))),
  );

  @override
  List<Object?> get props => [locations, types, positions, stacks, teamSizes, industries];

  // Map<String, dynamic> toJson() => {
  //   "locations": locations == null ? null : List<dynamic>.from(locations!.map((x) => x)),
  //   "types": types == null ? null : List<dynamic>.from(types!.map((x) => x.toJson())),
  //   "positions": positions == null ? null : List<Map<String, bool>>.from(positions!.map((item) => MapEntry(key, value))),
  //   "stacks": stacks == null ? null : List<dynamic>.from(stacks!.map((x) => x.toJson())),
  //   "teamSizes": teamSizes == null ? null : List<dynamic>.from(teamSizes!.map((x) => x.toJson())),
  //   "industries": industries == null ? null : List<dynamic>.from(industries!.map((x) => x.toJson())),
  // };
}

@CopyWith()
class Industry extends Equatable {
  const Industry({
    this.id,
    this.name,
  });

  final int? id;
  final String? name;

  factory Industry.fromJson(Map<String, dynamic> json) => Industry(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };

  @override
  List<Object?> get props => [id, name];
}

@CopyWith()
class Stack extends Equatable {
  const Stack({
    this.id,
    this.name,
    this.icon,
  });

  final int? id;
  final String? name;
  final String? icon;

  factory Stack.fromJson(Map<String, dynamic> json) => Stack(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
  };

  @override
  List<Object?> get props => [id, name, icon];
}

@CopyWith()
class TeamSize extends Equatable {
  const TeamSize({
    this.id,
    this.value,
  });

  final int? id;
  final String? value;

  factory TeamSize.fromJson(Map<String, dynamic> json) => TeamSize(
    id: json["id"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": value,
  };

  @override
  List<Object?> get props => [id, value];
}

@CopyWith()
class Type extends Equatable {
  const Type({
    this.value,
    this.label,
  });

  final String? value;
  final String? label;

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    value: json["value"],
    label:  json["label"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
  };

  @override
  List<Object?> get props => [value, label];
}
