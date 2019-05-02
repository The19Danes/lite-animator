import 'package:built_collection/built_collection.dart';
import 'package:test/test.dart';

import 'package:lite_animator/bloc/bloc.dart';
import 'package:lite_animator/models/models.dart';

void main() {
  PainterBloc painterBloc;

  setUp(() {
    painterBloc = PainterBloc();
  });

  group('PainterBloc', () {
    test('initial state is []', () {
      expect(painterBloc.initialState, []);
    });

    test('Continue stroke', () {
      //BuiltList<Stroke> expectedStrokes = BuiltList<Stroke>();

      painterBloc.dispatch(ContinueStroke(TouchLocation(x: 100, y: 100)));

      expectLater(painterBloc.state, emits([]));
    }, skip: 'TODO resolve async issue.');

    test('Clear strokes', () {
      painterBloc.dispatch(Clear());

      expectLater(painterBloc.state, emits([]));
    });

    test('Undo a stroke', () {
      painterBloc.dispatch(ContinueStroke(TouchLocation(x: 100, y: 100)));
      painterBloc.dispatch(ContinueStroke(TouchLocation(x: 115, y: 100)));
      painterBloc.dispatch(UndoStroke());

      //TODO understand expectLater, not sure I am doing this correctly. Only the first two events print.
      expectLater(painterBloc.state, emits([]));
    });

    test('Redo a stroke', () {

    }, skip: 'TODO complete test stub');

  });
}