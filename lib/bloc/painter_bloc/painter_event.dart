import 'package:equatable/equatable.dart';

import 'package:lite_animator/models/models.dart';

abstract class PainterEvent extends Equatable {
  PainterEvent([List props = const []]) : super(props);
}

class ContinueStroke extends PainterEvent {
  final TouchLocation strokePoint;

  ContinueStroke(this.strokePoint) : super([strokePoint]);

  @override
  String toString() => 'ContinueStroke { strokeMid: $strokePoint }';
}

class EndStroke extends PainterEvent {
  @override
  String toString() => 'EndStroke';
}

class Clear extends PainterEvent {
  @override
  String toString() => 'Clear';
}

class UndoStroke extends PainterEvent {
  @override
  String toString() => 'Undo';
}

class RedoStroke extends PainterEvent {
  @override
  String toString() => 'Redo';
}

class RenderPainting extends PainterEvent {
  final String drawingName;
  RenderPainting(this.drawingName) : super([drawingName]);

  @override
  String toString() => 'RenderPainting { drawingName: $drawingName}';
}