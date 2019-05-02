import 'package:equatable/equatable.dart';

abstract class UserProjectsEvent extends Equatable {}

class Fetch extends UserProjectsEvent {
  @override
  String toString() => 'Fetch';
}