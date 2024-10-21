import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/circles/data/bloc/circles_enums.dart';
import 'package:showwcase_v3/features/circles/data/models/circle_reason_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'circles_state.g.dart';

@CopyWith()
class CirclesState extends Equatable {

  final CircleStatus status;
  final String message;
  final dynamic data; // Keeps temporal data when status changes
  final List<CircleReasonModel> reasons;

  const CirclesState( {
    this.status = CircleStatus.initial,
    this.message = '',
    this.reasons = const [],
    this.data
  });

  @override
  List<Object?> get props => [status, reasons];



}

