import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';
import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:prevencionista/src/features/inspections/domain/repositories/inspections_repository.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/list_opportunities_usecase.dart';
import 'package:sqflite/sqflite.dart';

class InspectionsSqliteRepository implements InspectionsRepository {
  final Database database;

  InspectionsSqliteRepository(this.database);

  @override
  Future<int> create(Map<String, dynamic> map) async {
    try {
      int id = await database.insert(Sqlite.INSPECTIONS_TABLE, map);
      return id;
    } on Exception catch (error) {
      print('Erro ao criar inspeção! $error');
      rethrow;
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await database.delete(Sqlite.INSPECTIONS_TABLE, where: '${InspectionTable.id} = ?', whereArgs: [id]);
    } on Exception catch(error) {
      print(error);
    }
  }

  @override
  Future<List<Inspection>> findAll() async {
    try {
      var result = await database.rawQuery('SELECT * FROM ${Sqlite.INSPECTIONS_TABLE}');

      List<Inspection> inspections = [];

      for (var e in result) {
        List<Opportunity> opportunities = await ListOpportunitiesUseCase.execute(int.parse(e[InspectionTable.id].toString()));

        Inspection inspection = Inspection.fromMap(e);
        inspection.opportunities = opportunities;

        inspections.add(inspection);
      }

      return inspections;
    } on Exception catch (error) {
      print('Erro ao consultar todas as inspeções! $error');
      rethrow;
    }
  }

  @override
  Future<Inspection> findByDate(String date) async {
    try {
      var result = await database.rawQuery('SELECT * FROM ${Sqlite.INSPECTIONS_TABLE} WHERE ${InspectionTable.date} = ?', [date]);
      print('findByDate(): $result');

      var rawData = result.first;

      return Inspection.fromMap(rawData);
    } on Exception catch (error) {
      print('Erro ao consultar inspeção pela data! $error');
      rethrow;
    }
  }

  @override
  Future<Inspection> findById(int id) async {
    try {
      var result = await database.rawQuery('SELECT * FROM ${Sqlite.INSPECTIONS_TABLE} WHERE ${InspectionTable.id} = ?', [id]);

      var rawData = result.first;

      List<Opportunity> opportunities = await ListOpportunitiesUseCase.execute(int.parse(rawData[InspectionTable.id].toString()));

      Inspection inspection = Inspection.fromMap(rawData);
      inspection.opportunities = opportunities;

      return inspection;
    } on Exception catch (error) {
      print('Erro ao consultar inspeção pela data! $error');
      rethrow;
    }
  }

  @override
  Future<int> update(int id, Map<String, dynamic> map) async {
    try {
      var result = await database.update(Sqlite.INSPECTIONS_TABLE, map, where: '${InspectionTable.id} = ?', whereArgs: [id]);

      return result;
    } on Exception catch (error) {
      print('Erro ao consultar inspeção pela data! $error');
      return -1;
    }
  }
}