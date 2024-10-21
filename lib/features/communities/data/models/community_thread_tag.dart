
import 'package:equatable/equatable.dart';

class CommunityThreadTagsModel extends Equatable {
  final int? id;
  final String? color;
  final String? name;

const CommunityThreadTagsModel({
    this.id,
    this.color,
    this.name,
  });

  factory CommunityThreadTagsModel.fromJson(Map<String, dynamic> json) => CommunityThreadTagsModel(
    id: json["id"],
    color: json["color"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
  if(id != null)"id": id,
    "color": color,
    "name": name,
  };

  @override
  List<Object?> get props => [id, color, name];
}