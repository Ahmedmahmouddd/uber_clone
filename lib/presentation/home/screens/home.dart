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
import 'package:uber_clone/common/network/dio_client.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/presentation/home/bloc/drop_off_cubit/drop_off_cubit.dart';
import 'package:uber_clone/presentation/home/bloc/pickup&dropoff_location_cubit/pickup_location_cubit.dart';
import 'package:uber_clone/presentation/home/models/direction_details_indo.dart';
import 'package:uber_clone/presentation/home/models/directions_model.dart';
import 'package:uber_clone/presentation/home/screens/drawer_screen.dart';
import 'package:uber_clone/presentation/home/widgets/from_address_container.dart';
import 'package:uber_clone/presentation/home/widgets/positioned_icon.dart';
import 'package:uber_clone/presentation/home/widgets/to_address_container.dart';
import 'package:uber_clone/presentation/search/screens/search_places_screen.dart';
import 'package:uber_clone/presentation/search/widgets/progress_dialog.dart';
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
  DirectionDetailsInfo? tripDirectionDetailsInfo;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
      context.read<PickUpLocationCubit>().updatePickUpLocation(userPickupAddress);

      log("(getAddressFromLatLng) => Address: ${data.address}");
    } catch (e) {
      log("(getAddressFromLatLng) => Error: $e");
    }
  }

  Future<void> drawPolyLineFromOriginToDestination(bool darkTheme) async {
    var originPosition = context.read<PickUpLocationCubit>().userPickUpLocation;
    var destinationPosition = context.read<DropOffLocationCubit>().userDropOffLocation;

    if (originPosition == null || destinationPosition == null) {
      debugPrint("Origin or Destination is null");
      return;
    }

    var originLatlng = LatLng(originPosition.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatlng =
        LatLng(destinationPosition.locationLatitude!, destinationPosition.locationLongitude!);

    setState(() {
      markerSet.add(Marker(
          markerId: MarkerId("dropOffId"),
          position: destinationLatlng,
          infoWindow: InfoWindow(title: "🎯 Drop-off Location"),
          alpha: 0.7));
    });

    showDialog(
        context: context,
        builder: (context) => ProgressDialog(
              message: "Please wait...",
              darkTheme: darkTheme,
            ));

    var directionDetailsInfo =
        await obtainOriginalToDistinationDirectionDetails(originLatlng, destinationLatlng);

    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResultList = pPoints.decodePolyline(directionDetailsInfo.ePoints!);

    if (decodePolyLinePointsResultList.isEmpty) {
      log("Decoded polyline is empty. Check API response.");
      return;
    }

    pLineCoordinatedList.clear();
    for (var pointLatLng in decodePolyLinePointsResultList) {
      pLineCoordinatedList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
    }

    log("Decoded Polyline Points: $pLineCoordinatedList");

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
          width: 5);
      polylineSet.add(polyline);
    });

    debugPrint("Polyline Set: $polylineSet");

    LatLngBounds boundslatlng;
    if (originLatlng.latitude > destinationLatlng.latitude &&
        originLatlng.longitude > destinationLatlng.longitude) {
      boundslatlng = LatLngBounds(southwest: destinationLatlng, northeast: originLatlng);
    } else if (originLatlng.longitude > destinationLatlng.longitude) {
      boundslatlng = LatLngBounds(
          southwest: LatLng(originLatlng.latitude, destinationLatlng.longitude),
          northeast: LatLng(destinationLatlng.latitude, originLatlng.longitude));
    } else if (originLatlng.latitude > destinationLatlng.latitude) {
      boundslatlng = LatLngBounds(
          southwest: LatLng(destinationLatlng.latitude, originLatlng.longitude),
          northeast: LatLng(originLatlng.latitude, destinationLatlng.longitude));
    } else {
      boundslatlng = LatLngBounds(southwest: originLatlng, northeast: destinationLatlng);
    }

    newgoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundslatlng, 65));
  }

  Future<DirectionDetailsInfo> obtainOriginalToDistinationDirectionDetails(
      LatLng originPosition, destinationPosition) async {
    String urlOriginToDistinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=${Constants.mapKey}";

    var responseDirectionAPI = await DioClient().get(urlOriginToDistinationDirectionDetails);

    if (responseDirectionAPI.data["routes"].isEmpty) {
      debugPrint("API response is empty or invalid");
      return DirectionDetailsInfo();
    }

    debugPrint("Directions API Response: $responseDirectionAPI");

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.ePoints = responseDirectionAPI.data["routes"][0]["overview_polyline"]["points"];
    directionDetailsInfo.distanceText = responseDirectionAPI.data["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distanceValue =
        responseDirectionAPI.data["routes"][0]["legs"][0]["distance"]["value"];
    directionDetailsInfo.durationText = responseDirectionAPI.data["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.durationValue =
        responseDirectionAPI.data["routes"][0]["legs"][0]["duration"]["value"];
    return directionDetailsInfo;
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return userCurrentPosition == null
        ? Container(
            color: darkTheme ? DarkColors.background : LightColors.background,
            child: Center(
                child: CircularProgressIndicator(
              color: DarkColors.primary,
            )))
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Scaffold(
                key: scaffoldKey,
                drawer: DrawerScreen(darkTheme: darkTheme),
                body: Stack(
                  children: [
                    GoogleMap(
                      padding: const EdgeInsets.only(bottom: 130),
                      mapToolbarEnabled: false,
                      polylines: polylineSet,
                      compassEnabled: true,
                      onTap: (LatLng location) {
                        setState(() {
                          pickLocation = location;
                          getAddressFromLatLng();
                        });
                        markerSet.add(Marker(
                          markerId: MarkerId("pickUpId"),
                          alpha: 0.7,
                          position: pickLocation!,
                          infoWindow: InfoWindow(title: "🚖 Pickup Location"),
                          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                        ));
                      },
                      mapType: MapType.hybrid,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
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

                    //Zoom In Button
                    PositionedIcon(
                      iconData: Icons.add,
                      darkTheme: darkTheme,
                      bottom: 180,
                      right: 8,
                      onPressed: () async {
                        final controller = await googleMapController.future;
                        controller.animateCamera(CameraUpdate.zoomIn());
                      },
                    ),

                    //Zoom Out Button
                    PositionedIcon(
                      iconData: Icons.remove,
                      darkTheme: darkTheme,
                      bottom: 135,
                      right: 8,
                      onPressed: () async {
                        final controller = await googleMapController.future;
                        controller.animateCamera(CameraUpdate.zoomOut());
                      },
                    ),

                    //Locate Myself Button
                    PositionedIcon(
                      iconData: Icons.my_location,
                      darkTheme: darkTheme,
                      top: 8,
                      right: 8,
                      onPressed: () async {
                        locateUserPosition();
                      },
                    ),
                    //Open Drawer Button
                    PositionedIcon(
                      iconData: Icons.menu,
                      top: 8,
                      left: 8,
                      darkTheme: darkTheme,
                      onPressed: () => scaffoldKey.currentState!.openDrawer(),
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
                                      // var responseFromSearchScreen =
                                      await Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => SearchPlacesScreen()));
                                      // if (responseFromSearchScreen == "obtainedDropOff") {
                                      //   setState(() => openNavigationDrawer = false);
                                      // }
                                      await drawPolyLineFromOriginToDestination(darkTheme);
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
}
