// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:uber_clone/common/constants/constants.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/dio/dio.dart';
import 'package:uber_clone/presentation/home/bloc/pickup&dropoff_location_cubit/pickup_location_cubit.dart';
import 'package:uber_clone/presentation/home/models/direction_details_indo.dart';
import 'package:uber_clone/presentation/home/models/directions_model.dart';
import 'package:uber_clone/presentation/home/widgets/from_address_container.dart';
import 'package:uber_clone/presentation/home/widgets/to_address_container.dart';
import 'package:uber_clone/presentation/search/screens/search_places_screen.dart';
import 'package:uber_clone/presentation/splash/bloc/auth_gate_cubit/auth_gate_cubit.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? address;
  GoogleMapController? newgoogleMapController;
  final Completer<GoogleMapController> googleMapController = Completer<GoogleMapController>();
  static const CameraPosition kGooglePlex = CameraPosition(target: LatLng(30.0444, 31.2357), zoom: 14.4746);
  Position? userCurrentPosition;
  bool openNavigationDrawer = true;
  List<LatLng> pLineCoordinatedList = [];
  Set<Polyline> polylineSet = {};
  var geolocation = Geolocator();
  final Set<Marker> markerSet = {};
  final Set<Circle> circleSet = {};
  BitmapDescriptor? activeNearbyIcon;
  String userName = "";
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLocationPermission());
  }

  //1
  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) {
      log("Location permissions are permanently denied.");
      return;
    }

    if (!await Geolocator.isLocationServiceEnabled()) {
      bool isOpened = await Geolocator.openLocationSettings();
      if (!isOpened) return;
    }
    locateUserPosition();
  }

  //2
  void locateUserPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10),
      );
      setState(() => userCurrentPosition = position);

      final latLngPosition = LatLng(position.latitude, position.longitude);

      newgoogleMapController!
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLngPosition, zoom: 15)));

      // final humanReadableAddress = await getAddressNameFromCoordinates(position);
      // log("Address: $humanReadableAddress");

      final userModelCurrentInfo = context.read<AuthGateCubit>().userModelCurrentInfo;
      userName = userModelCurrentInfo!.name!;
      userEmail = userModelCurrentInfo.email!;
    } catch (e) {
      log("Error getting user's current location: $e");
    }
    // initializeGeoFireListener();
    // readTripsKeyForOnlineUser(context);
  }

  //3
  void getAddressFromLatLng() async {
    if (pickLocation == null) return;

    try {
      final data = await Geocoder2.getDataFromCoordinates(
        latitude: pickLocation!.latitude,
        longitude: pickLocation!.longitude,
        googleMapApiKey: Constants.mapKey,
      );

      LocationModel userPickupAddress = LocationModel();
      userPickupAddress.locationLatitude = pickLocation!.latitude;
      userPickupAddress.locationLongitude = pickLocation!.longitude;
      userPickupAddress.locationName = data.address;
      context.read<PickUpAndDropOffLocationCubit>().updatePickUpLocation(userPickupAddress);

      log("(getAddressFromLatLng) => Address: ${data.address}");
    } catch (e) {
      log("(getAddressFromLatLng) => Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return userCurrentPosition == null
        ? Container(
            color: darkTheme ? DarkColors.background : LightColors.background,
            child: Center(
                child: CircularProgressIndicator(
              color: darkTheme ? DarkColors.textSecondary : LightColors.textSecondary,
            )))
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Scaffold(
                body: Stack(
                  children: [
                    GoogleMap(
                      compassEnabled: true,
                      onTap: (LatLng location) {
                        setState(() {
                          pickLocation = location;
                          getAddressFromLatLng();
                        });
                        markerSet.add(Marker(markerId: MarkerId("pickUpId"), position: pickLocation!));
                      },
                      mapType: MapType.hybrid,
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
                      // onCameraMove: (CameraPosition? position) {
                      //   setState(() => pickLocation = position!.target);
                      // },
                      onCameraIdle: () {
                        getAddressFromLatLng();
                      },
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.location_on, size: 32, color: LightColors.primary)),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: darkTheme ? DarkColors.background : LightColors.white),
                              child: Column(
                                children: [
                                  FromAddressContainer(darkTheme: darkTheme),
                                  SizedBox(height: 6),
                                  GestureDetector(
                                    onTap: () async {
                                      var responseFromSearchScreen = await Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => SearchPlacesScreen()));
                                      if (responseFromSearchScreen == "obtainedDropOff") {
                                        setState(() => openNavigationDrawer = false);
                                      }
                                      await drawPolyLineFromOriginToDestination();
                                    },
                                    child: ToAddressContainer(darkTheme: darkTheme),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  DirectionDetailsInfo? tripDirectionDetailsInfo;
  Future<void> drawPolyLineFromOriginToDestination() async {
    var originPosition = context.read<PickUpAndDropOffLocationCubit>().userPickUpLocation;
    var destinationPosition = context.read<PickUpAndDropOffLocationCubit>().userDropOffLocation;
    markerSet.add(Marker(
        markerId: MarkerId("dropOffId"),
        position: LatLng(destinationPosition!.locationLatitude!, destinationPosition.locationLongitude!)));

    var originLatlng = LatLng(originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatlng =
        LatLng(destinationPosition.locationLatitude!, destinationPosition.locationLongitude!);

    // showDialog(
    //     context: context,
    //     builder: (context) => ProgressDialog(
    //           message: "Please wait...",
    //           darkTheme: sss,
    //         ));
    var directionDetailsInfo =
        await obtainOriginalToDistinationDirectionDetails(originLatlng, destinationLatlng);
    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    Navigator.pop(context);
    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResultList = pPoints.decodePolyline(directionDetailsInfo.ePoints!);

    pLineCoordinatedList.clear();
    if (decodePolyLinePointsResultList.isNotEmpty) {
      for (var pointLatLng in decodePolyLinePointsResultList) {
        pLineCoordinatedList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }
    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.purple,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinatedList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
        width: 5,
      );
      polylineSet.add(polyline);
    });
    LatLngBounds boundslatlng;
    if (originLatlng.latitude > destinationLatlng.latitude &&
        originLatlng.longitude > destinationLatlng.longitude) {
      boundslatlng = LatLngBounds(
        southwest: destinationLatlng,
        northeast: originLatlng,
      );
    } else if (originLatlng.longitude > destinationLatlng.longitude) {
      boundslatlng = LatLngBounds(
          southwest: LatLng(originLatlng.latitude, destinationLatlng.longitude),
          northeast: LatLng(destinationLatlng.latitude, originLatlng.longitude));
    } else if (originLatlng.latitude > destinationLatlng.latitude) {
      boundslatlng = LatLngBounds(
          southwest: LatLng(destinationLatlng.latitude, originLatlng.longitude),
          northeast: LatLng(originLatlng.latitude, destinationLatlng.longitude));
    } else {
      boundslatlng = LatLngBounds(
        southwest: originLatlng,
        northeast: destinationLatlng,
      );
    }

    newgoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundslatlng, 65));
    // Marker originMarker = Marker(
    //   markerId: MarkerId("OriginID"),
    //   infoWindow: InfoWindow(title: originPosition.locationName, snippet: "Origin"),
    //   position: originLatlng,
    //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    // );
    Marker destinationMarker = Marker(
      markerId: MarkerId("DestinationID"),
      infoWindow: InfoWindow(title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatlng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    setState(() {
      // markerSet.add(originMarker);
      markerSet.add(destinationMarker);
    });
  }

  Future<DirectionDetailsInfo> obtainOriginalToDistinationDirectionDetails(
      LatLng originPosition, LatLng destinationPosition) async {
    String urlOriginToDistinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=${Constants.mapKey}";
    var responseDirectionAPI = await receiveRequest(urlOriginToDistinationDirectionDetails);
    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.ePoints = responseDirectionAPI["routes"][0]["overview_polyline"]["points"];
    directionDetailsInfo.distanceText = responseDirectionAPI["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distanceValue = responseDirectionAPI["routes"][0]["legs"][0]["distance"]["value"];
    directionDetailsInfo.durationText = responseDirectionAPI["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.durationValue = responseDirectionAPI["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }
}
