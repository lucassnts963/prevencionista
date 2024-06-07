import 'package:flutter/cupertino.dart';
import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/add_opportunity_usecase.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/delete_opportunity_usecase.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/get_inspection_usecase.dart';
import 'package:prevencionista/src/features/inspections/presentation/screens/inspection/inspection_state.dart';
import 'package:prevencionista/src/shared/dtos/opportunity_create_dto.dart';

class InspectionController extends ChangeNotifier {
  InspectionState state = EmptyInspectionState();

  populate(Inspection inspection) {
    state = LoadingInspectionState();
    notifyListeners();

    if (inspection.opportunities.isEmpty) {
      state = EmptyInspectionState();
      notifyListeners();
    }

    state = FilledInspectionState(inspection: inspection);
    notifyListeners();
  }

  addOpportunity(OpportunityCreateDTO input) async {
    state = LoadingInspectionState();
    notifyListeners();

    try {
      final inspection = await GetInspectionUseCase.execute(input.inspectionId);
      final opportunity = await AddOpportunityUseCase.execute(input);
      final opportunities = inspection.opportunities;

      opportunities.add(opportunity);

      inspection.opportunities = opportunities;

      state = FilledInspectionState(inspection: inspection);
      notifyListeners();
    } on Exception catch (error) {
      state = ErrorInspectionState(message: error.toString());
      notifyListeners();
    }
  }

  removeOpportunity(Opportunity opportunity) async {
    state = LoadingInspectionState();
    notifyListeners();

    try {
      await DeleteOpportunityUseCase.execute(opportunity.id);
      final inspection = await GetInspectionUseCase.execute(opportunity.inspectionId);
      final opportunities = inspection.opportunities;

      if (inspection.opportunities.isEmpty) {
        state = EmptyInspectionState();
        notifyListeners();
        return;
      }

      inspection.opportunities = opportunities.where((element) => element.id != opportunity.id).toList();

      state = FilledInspectionState(inspection: inspection);
      notifyListeners();
    } on Exception catch (error) {
      state = ErrorInspectionState(message: error.toString());
    }
  }

  reload(int inspectionId) async {
    state = LoadingInspectionState();
    notifyListeners();

    final inspection = await GetInspectionUseCase.execute(inspectionId);
    state = FilledInspectionState(inspection: inspection);
    notifyListeners();

    if (inspection.opportunities.isEmpty) {
      state = EmptyInspectionState();
      notifyListeners();
    }
  }
}