import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';

import './touch_location.dart';

class Stroke extends Equatable {
  final BuiltList<TouchLocation>  locations;

  Stroke({this.locations}) : super([locations]);

  @override
  String toString() => 'Stroke { locations: ${locations.length} }';
}
