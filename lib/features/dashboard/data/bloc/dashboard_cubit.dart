import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/features/dashboard/data/bloc/dashboard_state.dart';
import 'package:showwcase_v3/features/dashboard/data/bloc/dashboard_status.dart';
import 'package:showwcase_v3/features/dashboard/data/repositories/dashboard_repository.dart';



class DashboardCubit extends Cubit<DashboardState> {

  final DashboardRepository dashboardRepository ;


  DashboardCubit({required this.dashboardRepository}) : super(const DashboardState());



  void getDashboardStat({ int? startDate, int? endDate}) async {
    try {

      emit(state.copyWith(status: DashboardStatus.dashboardLoading,));

      var either = await dashboardRepository.getDashboardStat(startDate: startDate, endDate: endDate);
      either.fold(
              (l) {
                emit(state.copyWith(status: DashboardStatus.dashboardFailed,message: l.errorDescription));
              },
              (r) {
                emit(state.copyWith(status: DashboardStatus.dashboardLoaded,dashboardModel: r));
              });

    } catch (e) {
      emit(state.copyWith(status: DashboardStatus.dashboardFailed,message:  e.toString()));
    }
  }

}
