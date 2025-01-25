import 'package:flutter/material.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';
import 'package:uber_clone/presentation/search/models/predicted_places_model.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({super.key});

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  List<PredictedPlace> predictedPlacesList = [];
  findPlaceAutoCompleteSearch(String inputText) async {}

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: darkTheme ? DarkColors.secondaryBackground : LightColors.background,
            appBar: AppBar(
              backgroundColor: darkTheme ? DarkColors.background : LightColors.secondaryBackground,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon:
                    Icon(Icons.arrow_back_ios_new, color: darkTheme ? DarkColors.accent : LightColors.accent),
              ),
              title: Text(
                "Set dropoff location",
                style: AppStyles.styleSemiBold16(darkTheme),
              ),
            ),
            body: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: darkTheme ? DarkColors.background : LightColors.secondaryBackground,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit_location_alt_outlined,
                                  color: darkTheme ? DarkColors.accent : LightColors.accent,
                                ),
                                Expanded(
                                    child: TextField(
                                  onChanged: (value) {
                                    findPlaceAutoCompleteSearch(value);
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Where to?",
                                    hintStyle: AppStyles.styleSemiBold16(darkTheme),
                                  ),
                                ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                predictedPlacesList.isNotEmpty
                    ? ListView.separated(
                        itemBuilder: (context, index) => Text("data"),
                        itemCount: predictedPlacesList.length,
                        separatorBuilder: (context, index) => Divider())
                    : Text(
                      "???????",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    )
              ],
            ),
          ),
        ));
  }
}

