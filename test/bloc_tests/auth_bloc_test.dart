import 'package:test/test.dart';

import 'package:lite_animator/bloc/bloc.dart';
///TODO may need to use Mockito

void main() {
  AuthenticationBloc authBloc;

  setUp(() {
    authBloc = AuthenticationBloc();
  });

  group('AuthBloc', () {

    test('Initial state is AuthenticationUninitialized()', () {
      expect(authBloc.initialState, AuthenticationUninitialized());
    });

    test('Dispose does not emit new states', () {
      expectLater(
        authBloc.state,
        emitsInOrder([]),
      );
      authBloc.dispose();
    });

    test('App start up', () {
      final List<AuthenticationState> expectedForExistingUser = [AuthenticationUninitialized(),AuthenticationAuthenticated()];
      final List<AuthenticationState> expectedForNewAnonUser =
        [AuthenticationUninitialized(), AuthenticationLoading(), AuthenticationAuthenticated()];

//      expectLater(authBloc.state, emitsAnyOf([expectedForExistingUser, expectedForNewAnonUser]));
      expectLater(authBloc.state, emitsInOrder(expectedForExistingUser));

      authBloc.dispatch(AppStarted());
    }, skip: 'TODO resolve await/firebase issue' );

  });
}