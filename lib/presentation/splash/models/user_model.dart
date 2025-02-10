import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? phoneNumber;
  String? name;
  String? id;
  String? address;
  String? email;
  String? role;
  String? vehicleModel;
  String? vehicleColor;
  String? vehicleNumber;
  String? vehicleTyp;

  UserModel(
      {this.phoneNumber,
      this.name,
      this.id,
      this.address,
      this.email,
      this.role,
      this.vehicleModel,
      this.vehicleColor,
      this.vehicleNumber,
      this.vehicleTyp});

  UserModel.fromsnapshot(DataSnapshot snapshot) {
    phoneNumber = (snapshot.value as dynamic)["phone"];
    name = (snapshot.value as dynamic)["name"];
    id = snapshot.key;
    email = (snapshot.value as dynamic)["email"];
    address = (snapshot.value as dynamic)["address"];
    role = (snapshot.value as dynamic)["role"];
    vehicleModel = (snapshot.value as dynamic)["vehicleModel"];
    vehicleColor = (snapshot.value as dynamic)["vehicleColor"];
    vehicleNumber = (snapshot.value as dynamic)["vehicleNumber"];
    vehicleTyp = (snapshot.value as dynamic)["vehicleType"];
  }
}
