import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/common/constants/constants.dart';
import 'package:uber_clone/common/info_handler/app_info.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';
import 'package:uber_clone/dio/dio.dart';
import 'package:uber_clone/presentation/home/models/directions_model.dart';
import 'package:uber_clone/presentation/search/models/predicted_places_model.dart';
import 'package:uber_clone/presentation/search/widgets/progress_dialog.dart';

class PlacePredictionTile extends StatefulWidget {
  const PlacePredictionTile({super.key, required this.predictedPlace});

  final PredictedPlace predictedPlace;

  @override
  State<PlacePredictionTile> createState() => _PlacePredictionTileState();
}

String userDropOffLocation = "";

class _PlacePredictionTileState extends State<PlacePredictionTile> {
  getPlaceDirectionDetails(String placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            Center(child: ProgressDialog(message: "Setting up dropoff, Please wait...")));

    String placeDirectionDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${Constants.mapKey}";

    var responseApi = await receiveRequest(placeDirectionDetailsUrl);
    Navigator.pop(context);
    if (responseApi["status"] == "OK") {
      DirectionsModel directionsModel = DirectionsModel();
      directionsModel.locationName = responseApi["result"]["name"];
      directionsModel.locationID = placeId;

      directionsModel.locationLatitude = responseApi["result"]["geometry"]["location"]["lat"];
      directionsModel.locationLongitude = responseApi["result"]["geometry"]["location"]["lng"];

      Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directionsModel);
      setState(() {
        userDropOffLocation = directionsModel.locationName!;
      });

      Navigator.pop(context, "obtainedDropOff");
    } else {
      return "place prediction tile error god damn it";
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return ElevatedButton(
        onPressed: () {
          getPlaceDirectionDetails(widget.predictedPlace.placeId!, context);
        },
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.add_location_alt_outlined,
                  color: darkTheme ? DarkColors.accent : LightColors.accent,
                ),
                SizedBox(width: 6),
                Expanded(
                    child: Column(
                  children: [
                    Text(widget.predictedPlace.mainText ?? "aaaaaaa",
                        overflow: TextOverflow.ellipsis, style: AppStyles.styleSemiBold16(darkTheme)),
                    Text(widget.predictedPlace.secondaryText ?? "aaaaaaa",
                        overflow: TextOverflow.ellipsis, style: AppStyles.styleSemiBold16(darkTheme))
                  ],
                ))
              ],
            )));
  }
}
