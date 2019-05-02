import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lite_animator/bloc/bloc.dart';
import 'package:lite_animator/pages/animation_page.dart';
import 'package:lite_animator/pages/draw_projects_page.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print('$error, $stacktrace');
  }
}

void main() {
  debugPaintSizeEnabled=false;
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(LiteAnimator());
}

class LiteAnimator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      title: 'LiteAnimator',
      //home: AnonEntry(),
      home: AnimationPage(),
    );
  }
}

class AnonEntry extends StatefulWidget {
  @override
  _AnonEntryState createState() => _AnonEntryState();
}

class _AnonEntryState extends State<AnonEntry> {
  AuthenticationBloc authBloc;

  @override
  void initState() {
    authBloc = AuthenticationBloc();
    authBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationEvent, AuthenticationState>(
      bloc: authBloc,
      builder: (BuildContext context, AuthenticationState state) {
        if(state is AuthenticationUninitialized){
          return SplashPage();
        }
        if(state is AuthenticationLoading){
          return CircularProgressIndicator();
        }
        if(state is AuthenticationAuthenticated){
          return DrawingProjectsPage();
        }
      }
    );
  }
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}


