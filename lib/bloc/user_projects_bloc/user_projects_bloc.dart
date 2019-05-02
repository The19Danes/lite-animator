import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:lite_animator/bloc/bloc.dart';
import 'package:lite_animator/bloc/user_projects_bloc/user_projects_state.dart';

class UserProjectsBloc extends Bloc<UserProjectsEvent, UserProjectsState> {
  @override
  UserProjectsState get initialState => UserProjectsListUninitialized();

  @override
  Stream<UserProjectsState> mapEventToState(UserProjectsEvent event) async* {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser firebaseUser = await _auth.currentUser();

    if(event is Fetch){
      try {
        final DocumentSnapshot doc = await Firestore.instance.collection('users').document('${firebaseUser.uid}').get();
        final Map projectsMap = doc['projects'];
        yield UserProjectsListLoaded(userInfo: projectsMap);
      } catch (e) {
        yield UserProjectsError();
      }
    }
  }
}