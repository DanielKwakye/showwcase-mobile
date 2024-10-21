import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/locations/data/bloc/location_enum.dart';

part 'location_state.g.dart';

@CopyWith()
class LocationState extends Equatable {

  final LocationStatus status;
  final String message;

  const LocationState({
    this.message = '',
    this.status = LocationStatus.initial
  });

  @override
  List<Object?> get props => [status];

}