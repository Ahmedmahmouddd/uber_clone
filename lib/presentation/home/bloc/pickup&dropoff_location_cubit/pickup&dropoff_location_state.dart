part of 'pickup&dropoff_location_cubit.dart';

@immutable
sealed class PickUpAndDropOffLocationState {}

final class PickUpLocationInitial extends PickUpAndDropOffLocationState {}

final class PickUpLocationUpdated extends PickUpAndDropOffLocationState {
  final DirectionsModel userPickUpLocation;

  PickUpLocationUpdated(this.userPickUpLocation);
}

final class DropOffLocationInitial extends PickUpAndDropOffLocationState {}

class DropOffLocationUpdated extends PickUpAndDropOffLocationState {
  final DirectionsModel userDropOffLocation;

  DropOffLocationUpdated(this.userDropOffLocation);
}
