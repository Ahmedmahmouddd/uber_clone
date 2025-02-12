import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:uber_clone/presentation/rider_home/models/location_model.dart';

part 'pickup_location_state.dart';

class PickUpLocationCubit extends Cubit<PickUpAndDropOffLocationState> {
  PickUpLocationCubit() : super(LocationInitial());

  LocationModel? userPickUpLocation;

  void updatePickUpLocation(LocationModel pickUpLocation) {
    userPickUpLocation = pickUpLocation;
    emit(PickUpLocationUpdated(pickUpLocation));
  }

  
}
