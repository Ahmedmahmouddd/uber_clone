import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'package:uber_clone/presentation/splash/models/user_model.dart';

part 'save_current_user_info_state.dart';

class LoadCurrentUserInfoCubit extends Cubit<LoadCurrentUserInfoState> {
  LoadCurrentUserInfoCubit() : super(LoadCurrentUserInfoInitial());

  UserModel? userModelCurrentInfo;
  Future<void> loadUser() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(currentUser.uid);
        DataSnapshot snap = await userRef.once().then((event) => event.snapshot);
        if (snap.value != null) {
          userModelCurrentInfo = UserModel.fromsnapshot(snap);
        }
      }
    } catch (e) {
      emit(LoadCurrentUserInfoError("Error: $e"));
    }
  }
}
