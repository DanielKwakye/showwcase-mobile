import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/spaces/data/bloc/spaces_enums.dart';
import 'package:showwcase_v3/features/spaces/data/models/space_model.dart';
part 'spaces_state.g.dart';

@CopyWith()
class SpacesState extends Equatable {

  final String message;
  final SpacesStatus status;
  final List<SpaceModel> ongoingSpaces;

  const SpacesState({
    this.message = '',
    this.status = SpacesStatus.initial,
    this.ongoingSpaces = const []
  });

  @override
  List<Object?> get props => [status];
}