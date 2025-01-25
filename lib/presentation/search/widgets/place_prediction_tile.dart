import 'package:flutter/material.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';
import 'package:uber_clone/presentation/search/models/predicted_places_model.dart';

class PlacePredictionTile extends StatelessWidget {
  const PlacePredictionTile({super.key, required this.predictedPlace});

  final PredictedPlace predictedPlace;
  getPlaceDirectionDetails() {}
  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return ElevatedButton(
        onPressed: () {},
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
                    Text(predictedPlace.mainText ?? "aaaaaaa",
                        overflow: TextOverflow.ellipsis, style: AppStyles.styleSemiBold16(darkTheme)),
                    Text(predictedPlace.secondaryText ?? "aaaaaaa",
                        overflow: TextOverflow.ellipsis, style: AppStyles.styleSemiBold16(darkTheme))
                  ],
                ))
              ],
            )));
  }
}
