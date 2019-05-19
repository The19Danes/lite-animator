import 'package:built_value/serializer.dart';
import 'package:built_value/built_value.dart';

part 'touch_location.g.dart';

abstract class TouchLocation implements Built<TouchLocation, TouchLocationBuilder> {
  static Serializer<TouchLocation> get serializer => _$touchLocationSerializer;

  double get x;
  double get y;

  TouchLocation._();

  factory TouchLocation([updates(TouchLocationBuilder b)]) = _$TouchLocation;
}