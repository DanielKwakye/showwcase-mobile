// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_tab_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTabModel _$UserTabModelFromJson(Map<String, dynamic> json) => UserTabModel(
      visible: json['visible'] as bool?,
      canEdit: json['canEdit'] as bool?,
      name: json['name'] as String?,
      id: json['id'] as String?,
      category: json['category'] as String?,
      canHide: json['canHide'] as bool?,
      modules: (json['modules'] as List<dynamic>?)
              ?.map((e) => UserModuleModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserTabModelToJson(UserTabModel instance) =>
    <String, dynamic>{
      'visible': instance.visible,
      'canEdit': instance.canEdit,
      'name': instance.name,
      'id': instance.id,
      'category': instance.category,
      'canHide': instance.canHide,
      'modules': instance.modules.map((e) => e.toJson()).toList(),
    };
