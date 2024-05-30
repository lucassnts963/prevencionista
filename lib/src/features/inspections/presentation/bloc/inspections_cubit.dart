import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';

class InspectionsCubit extends Cubit<List<Inspection>> {
  InspectionsCubit(super.initialState);

  void populate() {}

  void add(Inspection inspection) {
    List<Inspection> inspections = state;
    inspections.add(inspection);
    emit(inspections);
  }

  void remove(int index) {
    List<Inspection> inspections = state;
    inspections.removeAt(index);
    emit(inspections);
  }
}