import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:lite_animator/bloc/bloc.dart';

class ProjectNameBloc extends Bloc<ProjectNameEvent, ProjectNameState>{
  @override
  ProjectNameState get initialState => ProjectNameWaiting();

  @override
  Stream<ProjectNameState> mapEventToState(ProjectNameEvent event) async* {
    if(event is ProjectNameEntered && event.overwrite){
      yield ProjectNameValid();
    }
    else if(event is ProjectNameEntered && !event.overwrite){
      //TODO below ?
      //yield ProjectNameWaiting();//May want some loading indicator while validating name
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final FirebaseUser firebaseUser = await _auth.currentUser();
      final DocumentSnapshot doc = await Firestore.instance.collection('users').document('${firebaseUser.uid}').get();
      print('doc : $doc');
      final Map projectsMap = doc['projects'];
      //final nameList = List.from(projectsMap.keys);
      if(projectsMap.containsKey(event.projectName)){
        print('Project already exists with name : ${event.projectName}');
        yield ProjectNameInvalid();
      }
      else{
        print('valid project name : ${event.projectName}');
        yield ProjectNameValid();
      }
    }
    if(event is ProjectNameEntryRestarted){
      yield ProjectNameWaiting();
    }
  }

}