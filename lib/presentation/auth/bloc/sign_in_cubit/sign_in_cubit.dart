import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  Future<void> signIn({required String email, password}) async {
    emit(SignInLoading());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(currentUser.uid);
        DataSnapshot snapshot = await userRef.get();

        if (snapshot.exists) {
          Map<String, dynamic> userMap = Map<String, dynamic>.from(snapshot.value as Map);
          if (userMap["role"] == "Rider") {
            emit(SignInSuccessAsRider());
          } else {
            emit(SignInSuccessAsDriver());
          }
        }
      }
      emit(SignInSuccessAsRider());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        emit(SignInFailure(errMessage: "Wrong email or password provided."));
      }
    } catch (e) {
      emit(SignInFailure(errMessage: e.toString()));
    }
  }
}
