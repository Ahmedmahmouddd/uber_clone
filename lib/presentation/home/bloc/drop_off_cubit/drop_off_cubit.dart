import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:uber_clone/presentation/home/models/directions_model.dart';

part 'drop_off_state.dart';

class DropOffLocationCubit extends Cubit<DropOffLocationState> {
  DropOffLocationCubit() : super(DropOffLocationInitial());

  LocationModel? userDropOffLocation;

  void updateDropOffLocation(LocationModel dropOffAddress) {
    userDropOffLocation = dropOffAddress;
    emit(DropOffLocationUpdated(dropOffAddress));
  }
}
