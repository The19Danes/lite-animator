import 'package:equatable/equatable.dart';

class TouchLocation extends Equatable{
  final double x, y;

  TouchLocation({this.x, this.y}) : super([x,y]);

  @override
  String toString() => 'TouchLocation { x: $x, y: $y }';
}