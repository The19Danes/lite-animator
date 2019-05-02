import 'package:equatable/equatable.dart';

abstract class ProjectNameState extends Equatable {}

class ProjectNameWaiting extends ProjectNameState {
  @override
  String toString() => 'ProjectNameWaiting';
}

class ProjectNameValid extends ProjectNameState {
  @override
  String toString() => 'ProjectNameValid';
}

class ProjectNameInvalid extends ProjectNameState {
  @override
  String toString() => 'ProjectNameInvalid';
}

class ProjectNameValidating extends ProjectNameState {
  @override
  String toString() => 'ProjectNameValidating';
}