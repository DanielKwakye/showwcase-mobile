import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'roadmap_readers_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RoadmapReadersModel extends Equatable{

  final int? numberOfReaders;
  final List<UserModel>? readers;

  const RoadmapReadersModel({
    this.numberOfReaders,
    this.readers
 });


  /// Connect the generated [_$RoadmapReadersModelFromJson] function to the `fromJson`
  /// factory.
  factory RoadmapReadersModel.fromJson(Map<String, dynamic> json) => _$RoadmapReadersModelFromJson(json);

  /// Connect the generated [_$RoadmapReadersModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$RoadmapReadersModelToJson(this);

  @override
  List<Object?> get props => [numberOfReaders, readers];

}