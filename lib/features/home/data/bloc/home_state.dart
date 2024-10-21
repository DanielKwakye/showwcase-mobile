import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_enums.dart';

part 'home_state.g.dart';

@CopyWith()
class HomeState extends Equatable {

  final HomeStatus status;
  final String message;
  final dynamic data;

  const HomeState({this.status = HomeStatus.initial, this.message = '', this.data});

  @override
  List<Object?> get props => [status];


}