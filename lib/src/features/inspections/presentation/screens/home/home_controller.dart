import 'package:flutter/material.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/list_inspections_usecase.dart';
import 'package:prevencionista/src/features/inspections/presentation/screens/home/home_state.dart';

class HomeController extends ChangeNotifier {
  HomeState state = EmptyHomeState();

  getInspections() async {
    state = LoadingHomeState();
    notifyListeners();

    try {
      final inspections = await ListInspectionsUseCase.execute();

      if (inspections.isEmpty) {
        state = EmptyHomeState();
        notifyListeners();
        return;
      }

      state = FilledHomeState(inspections: inspections);

      notifyListeners();
    } on Exception catch (error) {
      state = ErrorHomeState(message: error.toString());
      notifyListeners();
    }
  }
}
