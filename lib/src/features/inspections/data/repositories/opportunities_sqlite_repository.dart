import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:prevencionista/src/features/inspections/domain/repositories/opportunities_repository.dart';
import 'package:prevencionista/src/shared/dtos/opportunity_create_dto.dart';
import 'package:sqflite/sqflite.dart';

class OpportunitiesSqliteRepository implements OpportunityRepository {
  final Database database;

  OpportunitiesSqliteRepository(this.database);

  @override
  Future<int> create(OpportunityCreateDTO input) async {
    print(input.toMap());
    try {
      int id = await database.insert(Sqlite.OPPORTUNITIES_TABLE, input.toMap());
      return id;
    } on Exception catch (error) {
      print('Erro ao criar oportunidade! $error');
      rethrow;
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await database.delete(Sqlite.OPPORTUNITIES_TABLE, where: '${OpportunityTable.id} = ?', whereArgs: [id]);
    } on Exception catch(error) {
      print('Erro ao tentar excluir um registro de oportunidade! $error');
    }
  }

  @override
  Future<List<Opportunity>> findAll(int inspectionId) async {
    try {
      // var result = await database.rawQuery('SELECT * FROM ${Sqlite.OPPORTUNITIES_TABLE} WHERE ${OpportunityTable.inspectionId} = ?', [inspectionId]);
      var result = await database.query(Sqlite.OPPORTUNITIES_TABLE, where: '${OpportunityTable.inspectionId} = ?', whereArgs: [inspectionId]);
      print(result);

      List<Opportunity> opportunities = [];

      for (var e in result) {
        opportunities.add(Opportunity.fromMap(e));
      }

      return opportunities;
    } on Exception catch (error) {
      print('Erro ao consultar todas as oportunidades! $error');
      rethrow;
    }
  }

  @override
  Future<Opportunity> findById(int id) async {
    try {
      var result = await database.query(Sqlite.OPPORTUNITIES_TABLE, where: '${OpportunityTable.id} = ?', whereArgs: [id]);

      var rawData = result.first;

      print('findById() - $rawData');

      return Opportunity.fromMap(rawData);
    } on Exception catch (error) {
      print('Erro ao consultar oportunidade pelo id! $error');
      rethrow;
    }
  }

  @override
  Future<int> update(int id, Map<String, dynamic> map) async {
    try {
      var result = await database.update(Sqlite.OPPORTUNITIES_TABLE, map, where: '${OpportunityTable.id} = ?', whereArgs: [id]);

      return result;
    } on Exception catch (error) {
      print('Erro ao atualizar oportunidade! $error');
      return -1;
    }
  }

  @override
  Future<void> deleteByInspectionId(int inspectionId) async {
    try {
      await database.delete(Sqlite.OPPORTUNITIES_TABLE, where: '${OpportunityTable.inspectionId} = ?', whereArgs: [inspectionId]);
    } on Exception catch(error) {
      print('Erro ao tentar excluir um registro de oportunidade! $error');
    }
  }
}