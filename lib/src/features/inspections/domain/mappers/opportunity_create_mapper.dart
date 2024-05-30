import 'package:prevencionista/src/core/helper/mapper.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:prevencionista/src/shared/dtos/opportunity_create_dto.dart';

class OpportunityCreateMapper
    implements Mapper<OpportunityCreateDTO, Opportunity> {
  @override
  Opportunity mapFrom(OpportunityCreateDTO input) {
    return Opportunity(
      id: input.id ?? 0,
      description: input.description,
      local: input.local,
      action: input.action,
      status: input.status,
      imagePathBefore: input.imagePathBefore,
      imagePathAfter: input.imagePathAfter,
      pictureReport: input.pictureReport,
      inspectionId: input.inspectionId,
    );
  }

  @override
  OpportunityCreateDTO mapTo(Opportunity output) {
    return OpportunityCreateDTO(
      description: output.description,
      local: output.local,
      action: output.action,
      status: output.status,
      imagePathBefore: output.imagePathBefore,
      inspectionId: output.inspectionId,
      pictureReport: output.pictureReport,
      imagePathAfter: output.imagePathAfter,
    );
  }
}
