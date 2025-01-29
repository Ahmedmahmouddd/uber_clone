import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:uber_clone/presentation/home/models/directions_model.dart';

part 'pickup&dropoff_location_state.dart';

class PickUpAndDropOffLocationCubit extends Cubit<PickUpAndDropOffLocationState> {
  PickUpAndDropOffLocationCubit() : super(PickUpLocationInitial());

  DirectionsModel? userPickUpLocation;
  DirectionsModel? userDropOffLocation;

    void updatePickUpLocation(DirectionsModel pickUpLocation) {
    userPickUpLocation = pickUpLocation;
    emit(PickUpLocationUpdated(pickUpLocation));
  }

  void updateDropOffLocationAddress(DirectionsModel dropOffAddress) {
    userDropOffLocation = dropOffAddress;
    emit(DropOffLocationUpdated(dropOffAddress));
  }
}
