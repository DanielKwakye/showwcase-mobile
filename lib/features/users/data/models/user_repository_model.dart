import 'package:json_annotation/json_annotation.dart';

part 'user_repository_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserRepositoryModel {

  final dynamic license;
  final Languages? languages;
  final Permissions? permissions;
  final int? id;
  final int? githubRepoId;
  final String? name;
  final bool? private;
  final String? htmlUrl;
  final String? description;
  final dynamic fork;
  final DateTime? repoCreatedAt;
  final DateTime? repoUpdatedAt;
  final int? size;
  final int? stargazerCount;
  final int? watchersCount;
  final String? language;
  final bool? archived;
  final bool? disabled;
  final String? homepage;
  final String? apiUrl;
  final int? forks;
  final int? userId;
  final bool? pinned;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserRepositoryModel({
      this.license,
      this.languages,
      this.permissions,
      this.id,
      this.githubRepoId,
      this.name,
      this.private,
      this.htmlUrl,
      this.description,
      this.fork,
      this.repoCreatedAt,
      this.repoUpdatedAt,
      this.size,
      this.stargazerCount,
      this.watchersCount,
      this.language,
      this.archived,
      this.disabled,
      this.homepage,
      this.apiUrl,
      this.forks,
      this.userId,
      this.pinned,
      this.createdAt,
      this.updatedAt,
  });


  /// Connect the generated [_$UserRepositoryModelFromJson] function to the `fromJson`
  /// factory.
  factory UserRepositoryModel.fromJson(Map<String, dynamic> json) => _$UserRepositoryModelFromJson(json);

  /// Connect the generated [_$UserRepositoryModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserRepositoryModelToJson(this);

}




@JsonSerializable(explicitToJson: true)
class Languages {

  const Languages({
    this.javaScript,
    this.c,
    this.cPlusPlus,
    this.cSharp,
    this.java,
    this.python,
    this.go,
    this.ruby,
    this.rust,
    this.typeScript,
    this.bash,
    this.sQL,
    this.react,
    this.html,
    this.dart,
    this.css,
    this.json,
    this.solidity,
    this.php,
    this.dockerfile
  });

  @JsonKey(name: 'JavaScript')
  final int? javaScript;

  @JsonKey(name: 'C')
  final int? c;

  @JsonKey(name: 'C++')
  final int? cPlusPlus;

  @JsonKey(name: 'C#')
  final int? cSharp;

  @JsonKey(name: 'Java')
  final int? java;

  @JsonKey(name: 'Python')
  final int? python;

  @JsonKey(name: 'Go')
  final int? go;

  @JsonKey(name: 'Ruby')
  final int? ruby;

  @JsonKey(name: 'Rust')
  final int? rust;

  @JsonKey(name: 'TypeScript')
  final int? typeScript;

  @JsonKey(name: 'Bash')
  final int? bash;

  @JsonKey(name: 'SQL')
  final int? sQL;

  @JsonKey(name: 'React')
  final int? react;

  @JsonKey(name: 'HTML')
  final int? html;

  @JsonKey(name: 'Dart')
  final int? dart;

  @JsonKey(name: 'CSS')
  final int? css;

  @JsonKey(name: 'JSON')
  final int? json;

  @JsonKey(name: 'Solidity')
  final int? solidity;

  @JsonKey(name: 'PHP')
  final int? php;

  //Dockerfile
  @JsonKey(name: 'Dockerfile')
  final int? dockerfile;

  /// Connect the generated [_$LanguagesFromJson] function to the `fromJson`
  /// factory.
  factory Languages.fromJson(Map<String, dynamic> json) => _$LanguagesFromJson(json);

  /// Connect the generated [_$LanguagesToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$LanguagesToJson(this);

}

@JsonSerializable(explicitToJson: true)
class Permissions {
  const Permissions({
    this.admin,
    this.maintain,
    this.push,
    this.triage,
    this.pull,
  });

  final bool? admin;
  final bool? maintain;
  final bool? push;
  final bool? triage;
  final bool? pull;

  /// Connect the generated [_$PermissionsFromJson] function to the `fromJson`
  /// factory.
  factory Permissions.fromJson(Map<String, dynamic> json) => _$PermissionsFromJson(json);

  /// Connect the generated [_$PermissionsToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PermissionsToJson(this);

}
