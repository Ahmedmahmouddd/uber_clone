part of 'drop_off_cubit.dart';

@immutable
sealed class DropOffLocationState {}

final class DropOffLocationInitial extends DropOffLocationState {}

class DropOffLocationUpdated extends DropOffLocationState {
  final LocationModel userDropOffLocation;

  DropOffLocationUpdated(this.userDropOffLocation);
}
