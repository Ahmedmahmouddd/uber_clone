// ignore_for_file: public_member_api_docs, sort_constructors_first
class PredictedPlace {
  String? placeId;
  String? mainText;
  String? secondaryText;
  PredictedPlace({this.placeId, this.mainText, this.secondaryText});

  PredictedPlace.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    mainText = json['structured_formatting']['main_text'];
    secondaryText = json["structured_formatting"]["secondary_text"];
  }
}
