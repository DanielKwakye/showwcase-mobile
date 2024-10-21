import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/dashboard/data/bloc/dashboard_status.dart';
import 'package:showwcase_v3/features/dashboard/data/models/dashboard_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';

part "dashboard_state.g.dart";

@CopyWith(copyWithNull: true)
class DashboardState extends Equatable {

  final DashboardModel? dashboardModel;
  final List<ThreadModel> threads;
  final List<ShowModel> shows;
  final DashboardStatus status;
  final String message;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.dashboardModel,
    this.threads = const [],
    this.shows = const [],
    this.message = '',
  });



  @override
  List<Object?> get props => [dashboardModel, threads, shows];

}
