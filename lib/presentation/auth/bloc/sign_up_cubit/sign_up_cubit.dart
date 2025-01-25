import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:firebase_database/firebase_database.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  Future<void> signUp({required String email, password, userName, address, phone}) async {
    emit(SignUpLoading());
    try {
      UserCredential auth =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      // userModel? userModelCurrentInfo;
      User? currentUser = auth.user;
      if (currentUser != null) {
        Map userMap = {
          "id": currentUser.uid,
          "name": userName,
          "email": email,
          "address": address,
          "phone": phone,
        };

        DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");
        await userRef.child(currentUser.uid).set(userMap).catchError((error) {
          emit(SignUpFailure(errMessage: error.toString()));
        });

        emit(SignUpSuccess());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(SignUpFailure(errMessage: "The password provided is too weak."));
      } else if (e.code == 'email-already-in-use') {
        emit(SignUpFailure(
            errMessage: "An account already exists for that email. If it is yours, Login instead."));
      } else if (e.code == 'invalid-email') {
        emit(SignUpFailure(errMessage: "The email provided is invalid."));
      }
    }
  }
}
