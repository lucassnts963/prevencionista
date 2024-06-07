import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';

sealed class HomeState {}

class ErrorHomeState extends HomeState {
  String message;

  ErrorHomeState({ required this.message });
}

class EmptyHomeState extends HomeState {}

class LoadingHomeState extends HomeState {}

class FilledHomeState extends HomeState {
  final List<Inspection> inspections;

  FilledHomeState({ required this.inspections });
}