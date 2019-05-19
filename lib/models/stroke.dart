import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import './touch_location.dart';

part 'stroke.g.dart';

abstract class Stroke implements Built<Stroke, StrokeBuilder> {
  static Serializer<Stroke> get serializer => _$strokeSerializer;

  BuiltList<TouchLocation> get locations;

  Stroke._();

  factory Stroke([updates(StrokeBuilder b)]) = _$Stroke;
}
