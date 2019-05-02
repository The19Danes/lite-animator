import 'package:equatable/equatable.dart';

abstract class UserProjectsState extends Equatable {}

class UserProjectsListUninitialized extends UserProjectsState {
  @override
  String toString() => 'UserProjectsListUninitialized';
}

class UserProjectsListLoaded extends UserProjectsState {
  final Map userInfo;

  UserProjectsListLoaded({this.userInfo});

  @override
  String toString() => 'UserProjectsListLoaded { projectNamesList : $userInfo }';
}

class UserProjectsError extends UserProjectsState {
  @override
  String toString() => 'UserProjectsError';
}