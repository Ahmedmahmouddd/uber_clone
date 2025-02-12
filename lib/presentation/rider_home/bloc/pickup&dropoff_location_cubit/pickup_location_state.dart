part of 'pickup_location_cubit.dart';

@immutable
sealed class PickUpAndDropOffLocationState {}

final class LocationInitial extends PickUpAndDropOffLocationState {}

final class PickUpLocationUpdated extends PickUpAndDropOffLocationState {
  final LocationModel userPickUpLocation;

  PickUpLocationUpdated(this.userPickUpLocation);
}

final class DropOffLocationInitial extends PickUpAndDropOffLocationState {}


