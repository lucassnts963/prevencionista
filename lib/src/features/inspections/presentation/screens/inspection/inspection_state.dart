import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';

sealed class InspectionState {}

class LoadingInspectionState extends InspectionState {}

class EmptyInspectionState extends InspectionState {}

class FilledInspectionState extends InspectionState {
  final Inspection inspection;

  FilledInspectionState({ required this.inspection });
}

class ErrorInspectionState extends InspectionState {
  final String message;

  ErrorInspectionState({ required this.message });
}
