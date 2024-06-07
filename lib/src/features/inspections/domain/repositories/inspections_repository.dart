import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';

abstract class InspectionsRepository {
  Future<List<Inspection>> findAll();
  Future<Inspection> findById(int id);
  Future<Inspection> findByDate(String date);
  Future<int> create(Map<String, dynamic> map);
  Future<void> delete(int id);
  Future<int> update(int id, Map<String, dynamic> map);
}