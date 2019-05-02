import 'package:test/test.dart';

import 'package:lite_animator/bloc/bloc.dart';

void main() {
  group('ProjectNameBloc', () {
    ProjectNameBloc projectNameBloc;

    setUp(() {
      projectNameBloc = ProjectNameBloc();
    });

    test('Initial state is ProjectNameWaiting()', () {
      expect(projectNameBloc.initialState, ProjectNameWaiting());
    });

    test('Valid project name entered', () {
      final List<ProjectNameState> expected = [ProjectNameWaiting(), ProjectNameValid()];

      //TODO update when project name bloc is complete
      expectLater(projectNameBloc.state, emitsInOrder(expected));

      projectNameBloc.dispatch(ProjectNameEntered(projectName: 'bloc_test_valid'));
    });

    test('Inalid project name entered', () {
      final List<ProjectNameState> expected = [ProjectNameWaiting(), ProjectNameInvalid()];

      //TODO update when project name bloc is complete
      expectLater(projectNameBloc.state, emitsInOrder(expected));

      projectNameBloc.dispatch(ProjectNameEntered(projectName: 'bloc_test_invalid'));
    }, skip: 'TODO complete test stub');

  });
}