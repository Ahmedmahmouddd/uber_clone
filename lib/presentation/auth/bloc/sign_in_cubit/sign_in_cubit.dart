import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  Future<void> signIn({required String email, password}) async {
    emit(SignInLoading());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      
      emit(SignInSuccess());
    }on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        emit(SignInFailure(errMessage: "Wrong email or password provided."));
      }
    } catch (e) {
      emit(SignInFailure(errMessage: e.toString()));
    }
  }
}
