import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uber_clone/common/constants/constants.dart';
import 'package:uber_clone/common/network/dio_client.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';
import 'package:uber_clone/presentation/search/models/predicted_places_model.dart';
import 'package:uber_clone/presentation/search/widgets/place_prediction_tile.dart';
import 'package:uber_clone/presentation/search/widgets/search_text_field.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({super.key});

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  List<PredictedPlace> predictedPlacesList = [];
  Timer? _debounce;

  void findPlaceAutoCompleteSearch(String inputText) {
    if (inputText.length <= 1) return;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      String urlAutocompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=${Constants.mapKey}&components=country:EG";

      try {
        var responseAutoCompleteSearch = await DioClient().get(urlAutocompleteSearch);

        if (responseAutoCompleteSearch.data["status"] == "OK") {
          var placePredictions = responseAutoCompleteSearch.data["predictions"];
          var placePredictionsList =
              (placePredictions as List).map((jsonData) => PredictedPlace.fromJson(jsonData)).toList();

          setState(() => predictedPlacesList = placePredictionsList);
        } else {
          setState(() => predictedPlacesList = []);
        }
      } catch (e) {
        setState(() => predictedPlacesList = []);
        debugPrint("(findPlaceAutoCompleteSearch) => Error fetching places: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: darkTheme ? DarkColors.background : LightColors.background,
            appBar: AppBar(
              backgroundColor: LightColors.primary,
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: darkTheme ? DarkColors.accent : LightColors.accent,
                  )),
              title: Text("Set dropoff location", style: AppStyles.styleReverseSemiBold16(darkTheme)),
            ),
            body: Column(
              children: [
                Container(
                  color: DarkColors.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SearchTextField(
                      darkTheme: darkTheme,
                      hint: "Where to?",
                      icon: Icons.edit_location_alt_outlined,
                      onChanged: (value) {
                        findPlaceAutoCompleteSearch(value);
                      },
                    ),
                  ),
                ),
                predictedPlacesList.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(
                            itemCount: predictedPlacesList.length,
                            itemBuilder: (context, index) => PlacePredictionTile(
                                predictedPlace: predictedPlacesList[index], darkTheme: darkTheme),
                            separatorBuilder: (context, index) => Divider(
                                color: darkTheme ? DarkColors.textSecondary : LightColors.textSecondary)),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ));
  }
}
