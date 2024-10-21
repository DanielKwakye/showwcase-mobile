import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class SpaceModel {

  final String id;
  final UserModel creator;
  final String title;

  const SpaceModel({
    required this.id,
    required this.title,
    required this.creator
  });

}