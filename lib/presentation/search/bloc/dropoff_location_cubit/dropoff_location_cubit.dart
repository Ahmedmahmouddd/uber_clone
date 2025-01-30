// import 'package:bloc/bloc.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:uber_clone/common/constants/constants.dart';
// import 'package:uber_clone/common/network/dio_client.dart';
// import 'package:uber_clone/presentation/home/bloc/pickup&dropoff_location_cubit/pickup_location_cubit.dart';
// import 'package:uber_clone/presentation/home/models/directions_model.dart';

// part 'dropoff_location_state.dart';

// class DropoffLocationCubit extends Cubit<DropoffLocationState> {
//   DropoffLocationCubit() : super(DropoffLocationInitial());

//   getPlaceDirectionDetails(String placeId, BuildContext context) async {
//     emit(DropoffLocationLoading());
//     String placeDirectionDetailsUrl =
//         "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${Constants.mapKey}";

//     try {
//       var responseApi = await DioClient().get(placeDirectionDetailsUrl);
//       if (responseApi.data["status"] == "OK") {
//         DirectionsModel directionsModel = DirectionsModel();
//         directionsModel.locationName = responseApi.data["result"]["name"];
//         directionsModel.locationID = placeId;
//         directionsModel.locationLatitude = responseApi.data["result"]["geometry"]["location"]["lat"];
//         directionsModel.locationLongitude = responseApi.data["result"]["geometry"]["location"]["lng"];
//         context.read<PickUpAndDropOffLocationCubit>().updateDropOffLocation(directionsModel);

//         emit(DropoffLocationSuccess(directionsModel));
//       } else {
//         emit(DropoffLocationFailure("Failed to fetch place details"));
//       }
//     } on DioException catch (e) {
//       if (e.response != null) {
//         emit(DropoffLocationFailure(e.response!.statusMessage.toString()));
//       }
//     } catch (e) {
//       emit(DropoffLocationFailure(e.toString()));
//     }
//   }
// }
