// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/common/constants/constants.dart';
import 'package:uber_clone/common/network/dio_client.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';
import 'package:uber_clone/presentation/home/bloc/pickup&dropoff_location_cubit/pickup_location_cubit.dart';
import 'package:uber_clone/presentation/home/models/directions_model.dart';
import 'package:uber_clone/presentation/search/models/predicted_places_model.dart';
import 'package:uber_clone/presentation/search/widgets/progress_dialog.dart';

class PlacePredictionTile extends StatelessWidget {
  const PlacePredictionTile({super.key, required this.predictedPlace, required this.darkTheme});

  final bool darkTheme;
  final PredictedPlace predictedPlace;

  getPlaceDirectionDetails(String placeId, BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          Center(child: ProgressDialog(message: "Selecting dropoff, Please wait...", darkTheme: darkTheme)),
    );

    String placeDirectionDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${Constants.mapKey}";

    var responseApi = await DioClient().get(placeDirectionDetailsUrl);
    Navigator.pop(context);
    if (responseApi.data["status"] == "OK") {
      LocationModel userDropOffAddress = LocationModel();
      userDropOffAddress.locationName = responseApi.data["result"]["name"];
      userDropOffAddress.locationID = placeId;
      userDropOffAddress.locationLatitude = responseApi.data["result"]["geometry"]["location"]["lat"];
      userDropOffAddress.locationLongitude = responseApi.data["result"]["geometry"]["location"]["lng"];

      context.read<PickUpAndDropOffLocationCubit>().updateDropOffLocation(userDropOffAddress);
      Navigator.pop(context, "obtainedDropOff");
    } else {
      return "place prediction tile error god damn it";
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
        onTap: () => getPlaceDirectionDetails(predictedPlace.placeId!, context),
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 12, right: 16, top: 0, bottom: 0),
          leading: Icon(
            Icons.add_location_alt_outlined,
            color: darkTheme ? DarkColors.textPrimary : LightColors.textPrimary,
          ),
          title: Text(predictedPlace.mainText ?? "No name",
              overflow: TextOverflow.ellipsis, style: AppStyles.styleSemiBold16(darkTheme)),
          subtitle: Text(predictedPlace.secondaryText ?? "No address",
              overflow: TextOverflow.ellipsis, style: AppStyles.styleSemiBold16(darkTheme)),
        ));
  }
}
