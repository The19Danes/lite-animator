import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ProjectNameEvent extends Equatable {
  ProjectNameEvent([List props = const []]) : super(props);
}

class ProjectNameEntered extends ProjectNameEvent {
  final String projectName;
  final bool overwrite;
  ProjectNameEntered({@required this.projectName, @required this.overwrite}) : super([projectName]);

  @override
  String toString() => 'NameEntered { projectName: $projectName }';
}

class ProjectNameEntryRestarted extends ProjectNameEvent {
  @override
  String toString() => 'ProjectNameEntryRestarted';
}