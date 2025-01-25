// ignore_for_file: public_member_api_docs, sort_constructors_first
class PredictedPlace {
  String? placeID;
  String? mainText;
  String? secondaryText;
  PredictedPlace({this.placeID, this.mainText, this.secondaryText});

  PredictedPlace.fromJson(Map<String, dynamic> json) {
    placeID = json['place_id'];
    mainText = json['structured_formatting']['main_text'];
    secondaryText = json["structured_formatting"]["secondary_text"];
  }
}
