import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_enums.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';

part 'series_state.g.dart';

@CopyWith()
class SeriesState extends Equatable {
  final String message;
  final SeriesStatus status;
  final dynamic data; // you can keep all temporal data here
  final List<SeriesModel>  series;

  const SeriesState({
    this.status = SeriesStatus.initial,
    this.message = '',
    this.series = const [],
    this.data
  });

  @override
  List<Object?> get props => [status];

}