import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'package:uber_clone/presentation/splash/models/user_model.dart';

part 'auth_gate_state.dart';

class AuthGateCubit extends Cubit<AuthGateState> {
  AuthGateCubit() : super(AuthGateInitial());

  UserModel? _userModelCurrentInfo;
  UserModel? get userModelCurrentInfo => _userModelCurrentInfo;

  Future<void> chackAuthState() async {
    
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(currentUser.uid);
        DataSnapshot snap = await userRef.once().then((event) => event.snapshot);
        if (snap.value != null) {
          _userModelCurrentInfo = UserModel.fromsnapshot(snap);
          emit(AuthGateAuthenticated());
          return;
        }
      }
      emit(AuthGateUnAuthenticated());
    } catch (e) {
      emit(AuthGateFailure(errorMessage: "Error: $e"));
    }
  }
}
