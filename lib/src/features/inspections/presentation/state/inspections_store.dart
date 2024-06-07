import 'package:flutter/material.dart';
import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/list_inspections_usecase.dart';

class InspectionsStore extends ChangeNotifier {
  bool isLoading = false;
  String error = '';
  int selectedInspection = 0;
  List<Inspection> inspections = [];

  add(Inspection inspection) {
    inspections.add(inspection);
    notifyListeners();
  }

  remove(int inspectionId) {
    inspections =  inspections.where((element) => element.id != inspectionId).toList();
    notifyListeners();
  }

  select(int index) {
    selectedInspection = index;
    notifyListeners();
  }

  int opportunityIndex(Opportunity opportunity) {
    Inspection inspection = inspections.where((element) => element.id == opportunity.inspectionId).first;

    int index = inspection.opportunities.indexWhere((element) => element.id == opportunity.id);

    if (index == -1) {
      error = 'Nenhuma opportunidade encontrda!';
    }

    return index;
  }

  addOpportunity(Opportunity opportunity) {
    inspections[selectedInspection].opportunities.add(opportunity);
    notifyListeners();
  }

  removeOpportunity(Inspection inspection, Opportunity opportunity) {
    inspections.where((element) => element.id == inspection.id).first.opportunities.removeWhere((element) => element.id == opportunity.id);
    notifyListeners();
  }

  Future<void> populate() async {
    isLoading = true;
    error = '';
    notifyListeners();

    try {
      List<Inspection> loadedInspections = await ListInspectionsUseCase.execute();
      inspections = loadedInspections;
      isLoading = false;
      error = '';
      print(inspections);
      notifyListeners();
    } on Exception catch (error) {
      this.error = error.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}