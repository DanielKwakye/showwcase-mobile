import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/locations/data/bloc/location_enum.dart';
import 'package:showwcase_v3/features/locations/data/bloc/location_state.dart';
import 'package:showwcase_v3/features/locations/data/repositories/location_repository.dart';

class LocationCubit extends Cubit<LocationState> {

  final LocationRepository locationRepository;
  LocationCubit({required this.locationRepository}): super(const LocationState());

  Future<List<String>?> searchLocations({required String keyword}) async {

    try{

      emit(state.copyWith(status: LocationStatus.searchLocationsInProgress));

      final either = await locationRepository.searchLocations(keyword: keyword);
      if(either.isLeft()) {
        final l = either.asLeft();
        emit(state.copyWith(
            status: LocationStatus.searchLocationsFailed,
            message: l.errorDescription
        ));
        return null;
      }

      final r = either.asRight();
      emit(state.copyWith(
        status: LocationStatus.searchLocationsSuccessful,
      ));
      return r;

    }catch(e) {
      emit(state.copyWith(
          status: LocationStatus.searchLocationsFailed,
          message: e.toString()
      ));
      return null;
    }

  }

}