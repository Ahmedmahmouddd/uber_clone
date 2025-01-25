import 'package:flutter/cupertino.dart';
import 'package:uber_clone/presentation/home/models/directions_model.dart';

class AppInfo extends ChangeNotifier {
  DirectionsModel? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  // List<String> historyTripsKeyList = [];
  // List<TripsHistoryModel> allTripsHistoryInformationList = [];

  void updatePickUPLocationAddress(DirectionsModel pickUpAddress) {
    userPickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(DirectionsModel dropOffAddress) {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }
}
