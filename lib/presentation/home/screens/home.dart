import 'dart:async';
import 'dart:developer';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/common/constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:uber_clone/presentation/home/models/directions_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LatLng? pickLocation;
  String? address;
  GoogleMapController? newgoogleMapController;
  final Completer<GoogleMapController> googleMapController = Completer<GoogleMapController>();
  static const CameraPosition kGooglePlex = CameraPosition(target: LatLng(30.0444, 31.2357), zoom: 14.4746);
  Position? userCurrentPosition;
  final Set<Marker> markerSet = {};
  final Set<Circle> circleSet = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                initialCameraPosition: kGooglePlex,
                markers: markerSet,
                circles: circleSet,
                onMapCreated: (GoogleMapController controller) {
                  googleMapController.complete(controller);
                  newgoogleMapController = controller;
                  setState(() {});
                  locateUserPosition();
                },
                onCameraMove: (CameraPosition? position) {
                  if (pickLocation != position!.target) {
                    setState(() {
                      pickLocation = position.target;
                    });
                  }
                },
                onCameraIdle: () {
                  getAddressFromLatLng();
                },
              ),
              Align(
                alignment: Alignment.center,
                child: Image.asset("assets/images/mappointer.webp", height: 50, width: 50),
              ),
              Positioned(
                  top: 20,
                  right: 20,
                  left: 20,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 16,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          address ?? "set your pickup location",
                          style: TextStyle(fontSize: 16),
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }

  //1
  Future<void> _checkLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return;

    if (!await Geolocator.isLocationServiceEnabled()) {
      if (!await Geolocator.openLocationSettings()) return;
    }

    _getCurrentLocation();
  }

  //2
  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10),
      );

      setState(() => userCurrentPosition = position);

      final controller = await googleMapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14.5),
        ),
      );
    } catch (e) {
      log("Error fetching location: $e");
    }
  }

  //3
  void locateUserPosition() async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
    userCurrentPosition = position;

    final latLngPosition = LatLng(position.latitude, position.longitude);
    newgoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLngPosition, zoom: 15)));

    final address = await searchAddressForGeographicCoordinates(position);
    log("Address: $address");
  }

  //4
  Future<dynamic> receiveRequest(String url) async {
    try {
      final dio = Dio();
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final decodedResponse = response.data;
        log("API Response: $decodedResponse");
        return decodedResponse.isNotEmpty ? decodedResponse : throw Exception("Empty response.");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return ('Error 404: Source not found.');
      } else {
        return (e.response!.data['message']);
      }
    }
  }

  //5
  Future<String> searchAddressForGeographicCoordinates(Position position) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Constants.mapKey}";
    final response = await receiveRequest(url);
    String humanReadableAddress = "";

    if (response != null && response["results"]?.isNotEmpty == true) {
      DirectionsModel userPickupAddress = DirectionsModel();
      userPickupAddress.locationLatitude = position.latitude;
      userPickupAddress.locationLongitude = position.longitude;
      userPickupAddress.locationName = humanReadableAddress;

      return humanReadableAddress;
    } else {
      log("No results found.");
      return "";
    }
  }

  //6
  void getAddressFromLatLng() async {
    if (pickLocation == null) return;

    try {
      final data = await Geocoder2.getDataFromCoordinates(
        latitude: pickLocation!.latitude,
        longitude: pickLocation!.longitude,
        googleMapApiKey: "AIzaSyB376ByXGn6J52_bkDrC0GdIWxG2piZaUY",
      );

      setState(() => address = data.address);
      log("Address: $address");
    } catch (e) {
      log("Error: $e");
    }
  }
}
