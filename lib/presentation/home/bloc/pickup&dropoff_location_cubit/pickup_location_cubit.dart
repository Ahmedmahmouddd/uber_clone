import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:uber_clone/presentation/home/models/directions_model.dart';

part 'pickup_location_state.dart';

class PickUpAndDropOffLocationCubit extends Cubit<PickUpAndDropOffLocationState> {
  PickUpAndDropOffLocationCubit() : super(LocationInitial());

  LocationModel? userPickUpLocation;
  LocationModel? userDropOffLocation;

  void updatePickUpLocation(LocationModel pickUpLocation) {
    userPickUpLocation = pickUpLocation;
    emit(PickUpLocationUpdated(pickUpLocation));
  }

  void updateDropOffLocation(LocationModel dropOffAddress) {
    userDropOffLocation = dropOffAddress;
    emit(DropOffLocationUpdated(dropOffAddress));
  }
}
