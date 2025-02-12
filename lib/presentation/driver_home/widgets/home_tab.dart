// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';
import 'package:uber_clone/presentation/auth/widgets/custom_snackbar.dart';
import 'package:uber_clone/presentation/rider_home/bloc/save_current_user_info_cubit/save_current_user_info_cubit.dart';
import 'package:uber_clone/presentation/rider_home/widgets/positioned_icon.dart';
import 'package:uber_clone/presentation/splash/models/user_model.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GoogleMapController? newgoogleMapController;
  final Completer<GoogleMapController> googleMapController = Completer<GoogleMapController>();
  static const CameraPosition kGooglePlex = CameraPosition(target: LatLng(30.0444, 31.2357), zoom: 14.4746);
  var geoLocator = Geolocator();
  Position? driverCurrentPosition;
  String statusText = "online";
  bool isDriverActive = false;
  UserModel? currentUserInfo;
  StreamSubscription<Position>? streamSubscriptionPosition;
  StreamSubscription<Position>? streamSubscriptionDriverLivePosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLocationPermission());
    loadCurrentUserData();
  }

  loadCurrentUserData() async {
    await context.read<LoadCurrentUserInfoCubit>().loadUser();
    currentUserInfo = context.read<LoadCurrentUserInfoCubit>().userModelCurrentInfo;
  }

  // @override
  // void dispose() {
  //   streamSubscriptionPosition?.cancel();
  //   streamSubscriptionDriverLivePosition?.cancel();
  //   super.dispose();
  // }

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
    locateDriverPosition();
  }

  //2
  void locateDriverPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10),
      );
      setState(() => driverCurrentPosition = position);

      final latLngPosition = LatLng(position.latitude, position.longitude);

      if (newgoogleMapController != null) {
        newgoogleMapController!.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(target: latLngPosition, zoom: 15)),
        );
      }
    } catch (e) {
      log("Error getting user's current location: $e");
    }
    // initializeGeoFireListener();
    // readTripsKeyForOnlineUser(context);
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return driverCurrentPosition == null
        ? Container(
            color: darkTheme ? DarkColors.background : LightColors.background,
            child: Center(
                child: CircularProgressIndicator(
              color: DarkColors.primary,
            )))
        : Stack(
            children: [
              GoogleMap(
                padding: const EdgeInsets.only(bottom: 130),
                mapToolbarEnabled: false,
                // polylines: polylineSet,
                compassEnabled: true,
                mapType: MapType.hybrid,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: kGooglePlex,
                // markers: markerSet,
                // circles: circleSet,
                onMapCreated: (GoogleMapController controller) {
                  googleMapController.complete(controller);
                  newgoogleMapController = controller;
                  setState(() {});
                  locateDriverPosition();
                },
              ),
              //Zoom In Button
              PositionedIcon(
                iconData: Icons.add,
                darkTheme: darkTheme,
                bottom: 53,
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
                bottom: 8,
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
                  locateDriverPosition();
                },
              ),
              Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.location_on, size: 32, color: LightColors.primary)),
              statusText == "offline"
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: const Color.fromARGB(210, 0, 0, 0),
                    )
                  : SizedBox(),
              statusText == "offline"
                  ? Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                driverIsOnline();
                                updateDriverLocation();
                                setState(() {
                                  statusText = "online";
                                  isDriverActive = true;
                                });
                                showCustomSnackBar(context, "You are now back Online", darkTheme);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: darkTheme ? DarkColors.accent : LightColors.accent,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                              child: Text("Press to go online", style: AppStyles.styleSemiBold14(darkTheme))),
                          SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Center(
                              child: Text(
                                "When you are offline, users will not be able to book your rides or engage with you",
                                style: AppStyles.styleSemiBold12Light(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: FloatingActionButton.small(
                          heroTag: null,
                          backgroundColor: darkTheme
                              ? DarkColors.background.withAlpha(200)
                              : LightColors.background.withAlpha(200),
                          onPressed: () {
                            driverIsOffline();
                            // updateDriverLocation();
                            setState(() {
                              statusText = "offline";
                              isDriverActive = false;
                            });
                            showCustomSnackBar(context, "You are now Offline", darkTheme);
                          },
                          child: Icon(Icons.explore_off_outlined,
                              color: darkTheme ? DarkColors.textPrimary : LightColors.textPrimary),
                        ),
                      ),
                    ),
            ],
          );
  }

  void driverIsOnline() {
    Geofire.initialize("activeDrivers");
    Geofire.setLocation(
        currentUserInfo!.id!, driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    DatabaseReference ref =
        FirebaseDatabase.instance.ref("users").child(currentUserInfo!.id!).child("activeStatus");
    ref.set("idle");
    ref.onValue.listen((event) {});
  }

  void updateDriverLocation() {
    streamSubscriptionPosition = Geolocator.getPositionStream().listen((Position position) {
      if (isDriverActive) {
        setState(() => driverCurrentPosition = position);
        Geofire.setLocation(currentUserInfo!.id!, position.latitude, position.longitude);
        LatLng latLng = LatLng(position.latitude, position.longitude);
        if (newgoogleMapController != null) {
          newgoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
        }
      }
    });
  }

  void driverIsOffline() {
    Geofire.removeLocation(currentUserInfo!.id!);
    DatabaseReference? ref =
        FirebaseDatabase.instance.ref("users").child(currentUserInfo!.id!).child("activeStatus");
    ref.set("Offline");
    // ref.remove();
    streamSubscriptionPosition?.cancel();
    streamSubscriptionPosition = null;
  }
}
