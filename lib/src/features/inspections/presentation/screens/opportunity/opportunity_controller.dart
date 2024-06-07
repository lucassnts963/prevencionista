import 'package:flutter/material.dart';
import 'package:prevencionista/src/features/inspections/domain/mappers/opportunity_create_mapper.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/add_image_after_path_usecase.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/add_image_report_path_usecase.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/get_opportunity_usecase.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/update_opportunity_usecase.dart';
import 'package:prevencionista/src/features/inspections/presentation/screens/opportunity/opportunity_state.dart';
import 'package:prevencionista/src/shared/domain/usecases/generate_report_picture_usecase.dart';
import 'package:prevencionista/src/shared/domain/usecases/save_image_on_gallery_usecase.dart';
import 'package:prevencionista/src/shared/domain/usecases/share_image_usecase.dart';

class OpportunityController extends ChangeNotifier {
  OpportunityState state = LoadingOpportunityState();

  populate (Opportunity opportunity) {
    state = FilledOpportunityState(opportunity: opportunity);
    notifyListeners();
  }

  updateImagePathAfter(int opportunityId, String imagePathAfter) async {
    state = LoadingOpportunityState();
    notifyListeners();

    try {
      await AddImageReportPathUseCase.execute(opportunityId, imagePathAfter);
      final opportunity = await GetOpportunityUseCase.execute(opportunityId);
      state = FilledOpportunityState(opportunity: opportunity);
    } on Exception catch (error) {
      state = ErrorOpportunityState(message: error.toString());
      notifyListeners();
    }
  }

  update(Opportunity opportunity) async {
    state = LoadingOpportunityState();
    notifyListeners();

    try {
      final updated = await UpdateOpportunityUseCase.execute(OpportunityCreateMapper().mapTo(opportunity));

      state = FilledOpportunityState(opportunity: updated);
      notifyListeners();
    } on Exception catch (error) {
      state = ErrorOpportunityState(message: error.toString());
      notifyListeners();
    }

    state = FilledOpportunityState(opportunity: opportunity);
    notifyListeners();
  }

  generateReportImage(Opportunity opportunity) async {
    state = SavingOpportunityState();
    notifyListeners();

    final imagePathAfter = opportunity.imagePathAfter;

    if (imagePathAfter == null || imagePathAfter.isEmpty) {
      state = ErrorOpportunityState(message: 'Oportunidade sem Imagem do depois impossível gerar o Report');
      notifyListeners();
      return;
    }

    try {
      String? path = await GenerateReportPictureUseCase.execute(opportunity);
      if (path != null) {
        await AddImageAfterPathUseCase.execute(opportunity.id, imagePathAfter);
        await AddImageReportPathUseCase.execute(opportunity.id, path);
        await SaveImageOnGalleryUseCase.execute(path);

        opportunity.pictureReport = path;

        state = FilledOpportunityState(opportunity: opportunity);
        notifyListeners();
      }
    } on Exception catch (error) {
      state = ErrorOpportunityState(message: error.toString());
      notifyListeners();
    }

  }

  shareReportImage(Opportunity opportunity, int index) async  {
    final imagePathReport = opportunity.pictureReport;

    if (imagePathReport != null && imagePathReport.isNotEmpty) {
      await ShareImageUseCase.execute(opportunity.build(index), imagePathReport);
    }
  }
}