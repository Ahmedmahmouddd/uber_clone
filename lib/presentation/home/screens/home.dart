// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';

import 'package:uber_clone/common/constants/constants.dart';
import 'package:uber_clone/common/info_handler/app_info.dart';
import 'package:uber_clone/dio/dio.dart';
import 'package:uber_clone/presentation/home/models/directions_model.dart';
import 'package:uber_clone/presentation/search/screens/search_places_screen.dart';
import 'package:uber_clone/presentation/search/widgets/progress_dialog.dart';
import 'package:uber_clone/presentation/splash/screens/splash.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    // bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
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
              //  UI for searching location
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
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on_outlined, color: Colors.blue),
                                  SizedBox(width: 4),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("From",
                                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                                      Text(
                                        Provider.of<AppInfo>(context).userPickUpLocation?.locationName != null
                                            ? "${(Provider.of<AppInfo>(context).userPickUpLocation?.locationName)!.substring(0, (Provider.of<AppInfo>(context).userPickUpLocation?.locationName)!.length > 36 ? 36 : Provider.of<AppInfo>(context).userPickUpLocation?.locationName!.length)}..."
                                            : "Choose Location",
                                        style:
                                            TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            // Divider(color: Colors.grey[100], thickness: 1.5, endIndent: 25, indent: 25),
                            SizedBox(height: 6),
                            GestureDetector(
                              onTap: () async {
                                var responseFromSearchScreen = await Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => SearchPlacesScreen()));
                                if (responseFromSearchScreen == "obtainedDropOff") {
                                  setState(() {
                                    openNavigationDrawer = false;
                                  });
                                }

                                await drawPolyLineFromOriginToDestination();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on_outlined, color: Colors.blue),
                                    SizedBox(width: 4),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("To",
                                            style:
                                                TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                                        Text(
                                          Provider.of<AppInfo>(context).userDropOffLocation?.locationName !=
                                                  null
                                              ? "${(Provider.of<AppInfo>(context).userDropOffLocation?.locationName)!.substring(0, (Provider.of<AppInfo>(context).userDropOffLocation?.locationName)!.length > 36 ? 36 : Provider.of<AppInfo>(context).userDropOffLocation?.locationName!.length)}..."
                                              : "Choose Location",
                                          style:
                                              TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )

              // UI for showing address
              // Positioned(
              //     top: 20,
              //     right: 20,
              //     left: 20,
              //     child: Container(
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(5),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.black54,
              //               blurRadius: 16,
              //               spreadRadius: 0.5,
              //               offset: Offset(0.7, 0.7),
              //             ),
              //           ],
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.all(10.0),
              //           child: Text(
              //             Provider.of<AppInfo>(context).userPickUpLocation?.locationName ??
              //                 "Not getting address",
              //             style: TextStyle(fontSize: 16),
              //           ),
              //         )))
            ],
          ),
        ),
      ),
    );
  }

/* 
Widget build(BuildContext context) {
  bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

  // Define dark and light map styles
  final String darkMapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#212121"
        }
      ]
    },
    {
      "elementType": "labels.icon",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#212121"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#212121"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#000000"
        }
      ]
    }
  ]
  ''';

  final String lightMapStyle = '''
  // Add your light map style here
  ''';

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
                setState(() {
                  // Apply dark or light theme
                  controller.setMapStyle(darkTheme ? darkMapStyle : lightMapStyle);
                });
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
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

*/

  DirectionDetailsInfo? tripDirectionDetailsInfo;
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

    final humanReadableAddress = await searchAddressForGeographicCoordinates(position);
    log("Address: $humanReadableAddress");

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    // initializeGeoFireListener();
    // readTripsKeyForOnlineUser(context);
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
  Future<String> searchAddressForGeographicCoordinates(
    Position position,
  ) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Constants.mapKey}";
    final response = await receiveRequest(url);
    String humanReadableAddress = "";

    if (response != null && response["results"]?.isNotEmpty == true) {
      DirectionsModel userPickupAddress = DirectionsModel();
      userPickupAddress.locationLatitude = position.latitude;
      userPickupAddress.locationLongitude = position.longitude;
      userPickupAddress.locationName = humanReadableAddress;

      // Provider.of<AppInfo>(context, listen: false).updatePickUPLocationAddress(userPickupAddress);
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

      setState(() {
        DirectionsModel userPickupAddress = DirectionsModel();
        userPickupAddress.locationLatitude = pickLocation!.latitude;
        userPickupAddress.locationLongitude = pickLocation!.longitude;
        userPickupAddress.locationName = data.address;

        Provider.of<AppInfo>(context, listen: false).updatePickUPLocationAddress(userPickupAddress);
        // address = data.address;
      });
      log("Address: ${data.address}");
    } catch (e) {
      log("Error: $e");
    }
  }

  Future<void> drawPolyLineFromOriginToDestination() async {
    var originPosition = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatlng = LatLng(originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatlng =
        LatLng(destinationPosition!.locationLatitude!, destinationPosition.locationLongitude!);

    showDialog(
        context: context,
        builder: (context) => ProgressDialog(
              message: "Please wait...",
            ));
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
      decodePolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoordinatedList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
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
    Marker originMarker = Marker(
      markerId: MarkerId("OriginID"), infoWindow: InfoWindow(title: originPosition.locationName, snippet: "Origin"),
      position: originLatlng,icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );Marker destinationMarker = Marker(
      markerId: MarkerId("DestinationID"), infoWindow: InfoWindow(title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatlng,icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    setState(() {
      markerSet.add(originMarker);
      markerSet.add(destinationMarker);
    });
  }
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

class DirectionDetailsInfo {
  int? distanceValue;
  int? durationValue;
  String? distanceText;
  String? durationText;
  String? ePoints;
  DirectionDetailsInfo({
    this.distanceValue,
    this.durationValue,
    this.distanceText,
    this.durationText,
    this.ePoints,
  });
}
