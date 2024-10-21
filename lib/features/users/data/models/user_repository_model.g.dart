// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_repository_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRepositoryModel _$UserRepositoryModelFromJson(Map<String, dynamic> json) =>
    UserRepositoryModel(
      license: json['license'],
      languages: json['languages'] == null
          ? null
          : Languages.fromJson(json['languages'] as Map<String, dynamic>),
      permissions: json['permissions'] == null
          ? null
          : Permissions.fromJson(json['permissions'] as Map<String, dynamic>),
      id: json['id'] as int?,
      githubRepoId: json['githubRepoId'] as int?,
      name: json['name'] as String?,
      private: json['private'] as bool?,
      htmlUrl: json['htmlUrl'] as String?,
      description: json['description'] as String?,
      fork: json['fork'],
      repoCreatedAt: json['repoCreatedAt'] == null
          ? null
          : DateTime.parse(json['repoCreatedAt'] as String),
      repoUpdatedAt: json['repoUpdatedAt'] == null
          ? null
          : DateTime.parse(json['repoUpdatedAt'] as String),
      size: json['size'] as int?,
      stargazerCount: json['stargazerCount'] as int?,
      watchersCount: json['watchersCount'] as int?,
      language: json['language'] as String?,
      archived: json['archived'] as bool?,
      disabled: json['disabled'] as bool?,
      homepage: json['homepage'] as String?,
      apiUrl: json['apiUrl'] as String?,
      forks: json['forks'] as int?,
      userId: json['userId'] as int?,
      pinned: json['pinned'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserRepositoryModelToJson(
        UserRepositoryModel instance) =>
    <String, dynamic>{
      'license': instance.license,
      'languages': instance.languages?.toJson(),
      'permissions': instance.permissions?.toJson(),
      'id': instance.id,
      'githubRepoId': instance.githubRepoId,
      'name': instance.name,
      'private': instance.private,
      'htmlUrl': instance.htmlUrl,
      'description': instance.description,
      'fork': instance.fork,
      'repoCreatedAt': instance.repoCreatedAt?.toIso8601String(),
      'repoUpdatedAt': instance.repoUpdatedAt?.toIso8601String(),
      'size': instance.size,
      'stargazerCount': instance.stargazerCount,
      'watchersCount': instance.watchersCount,
      'language': instance.language,
      'archived': instance.archived,
      'disabled': instance.disabled,
      'homepage': instance.homepage,
      'apiUrl': instance.apiUrl,
      'forks': instance.forks,
      'userId': instance.userId,
      'pinned': instance.pinned,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

Languages _$LanguagesFromJson(Map<String, dynamic> json) => Languages(
      javaScript: json['JavaScript'] as int?,
      c: json['C'] as int?,
      cPlusPlus: json['C++'] as int?,
      cSharp: json['C#'] as int?,
      java: json['Java'] as int?,
      python: json['Python'] as int?,
      go: json['Go'] as int?,
      ruby: json['Ruby'] as int?,
      rust: json['Rust'] as int?,
      typeScript: json['TypeScript'] as int?,
      bash: json['Bash'] as int?,
      sQL: json['SQL'] as int?,
      react: json['React'] as int?,
      html: json['HTML'] as int?,
      dart: json['Dart'] as int?,
      css: json['CSS'] as int?,
      json: json['JSON'] as int?,
      solidity: json['Solidity'] as int?,
      php: json['PHP'] as int?,
      dockerfile: json['Dockerfile'] as int?,
    );

Map<String, dynamic> _$LanguagesToJson(Languages instance) => <String, dynamic>{
      'JavaScript': instance.javaScript,
      'C': instance.c,
      'C++': instance.cPlusPlus,
      'C#': instance.cSharp,
      'Java': instance.java,
      'Python': instance.python,
      'Go': instance.go,
      'Ruby': instance.ruby,
      'Rust': instance.rust,
      'TypeScript': instance.typeScript,
      'Bash': instance.bash,
      'SQL': instance.sQL,
      'React': instance.react,
      'HTML': instance.html,
      'Dart': instance.dart,
      'CSS': instance.css,
      'JSON': instance.json,
      'Solidity': instance.solidity,
      'PHP': instance.php,
      'Dockerfile': instance.dockerfile,
    };

Permissions _$PermissionsFromJson(Map<String, dynamic> json) => Permissions(
      admin: json['admin'] as bool?,
      maintain: json['maintain'] as bool?,
      push: json['push'] as bool?,
      triage: json['triage'] as bool?,
      pull: json['pull'] as bool?,
    );

Map<String, dynamic> _$PermissionsToJson(Permissions instance) =>
    <String, dynamic>{
      'admin': instance.admin,
      'maintain': instance.maintain,
      'push': instance.push,
      'triage': instance.triage,
      'pull': instance.pull,
    };
