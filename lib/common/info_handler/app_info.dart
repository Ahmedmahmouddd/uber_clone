import 'package:flutter/cupertino.dart';
import 'package:uber_clone/presentation/rider_home/models/location_model.dart';

class AppInfo extends ChangeNotifier {
  LocationModel? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  // List<String> historyTripsKeyList = [];
  // List<TripsHistoryModel> allTripsHistoryInformationList = [];
}
