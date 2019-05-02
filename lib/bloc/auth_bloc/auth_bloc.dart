import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:lite_animator/bloc/bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  AuthenticationBloc();

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser firebaseUser = await _auth.currentUser();

    if(event is AppStarted){
      if(firebaseUser != null){
        print("Already authenticated user: $firebaseUser");
        yield AuthenticationAuthenticated();
      }
      else{
        yield AuthenticationLoading();
        FirebaseUser newAnonUser = await _auth.signInAnonymously();
        print("Newly authenticated anon user: $newAnonUser");
        yield AuthenticationAuthenticated();
      }
    }
  }


}