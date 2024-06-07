import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:prevencionista/src/shared/dtos/opportunity_create_dto.dart';

abstract class OpportunityRepository {
  Future<List<Opportunity>> findAll(int inspectionId);
  Future<Opportunity> findById(int id);
  Future<int> create(OpportunityCreateDTO input);
  Future<void> delete(int id);
  Future<void> deleteByInspectionId(int inspectionId);
  Future<int> update(int id, Map<String, dynamic> map);
}