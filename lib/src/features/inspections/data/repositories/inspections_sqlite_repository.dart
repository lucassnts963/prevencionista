import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';
import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';
import 'package:prevencionista/src/features/inspections/domain/repositories/inspections_repository.dart';
import 'package:sqflite/sqflite.dart';

class InspectionsSqliteRepository implements InspectionsRepository {
  final Database database;

  InspectionsSqliteRepository(this.database);

  @override
  Future<int?> create(Map<String, dynamic> map) async {
    try {
      int id = await database.insert(Sqlite.INSPECTIONS_TABLE, map);
      return id;
    } on Exception catch (error) {
      print('Erro ao criar inspeção! $error');
      return null;
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
  Future<List<Inspection>?> findAll() async {
    try {
      var result = await database.rawQuery('SELECT * FROM ${Sqlite.INSPECTIONS_TABLE}');

      List<Inspection> inspections = [];

      for (var e in result) {
        inspections.add(Inspection.fromMap(e));
      }

      return inspections;
    } on Exception catch (error) {
      print('Erro ao consultar todas as inspeções! $error');
      return null;
    }
  }

  @override
  Future<Inspection?> findByDate(String date) async {
    try {
      var result = await database.rawQuery('SELECT * FROM ${Sqlite.INSPECTIONS_TABLE} WHERE ${InspectionTable.date} = ?', [date]);
      print('findByDate(): $result');

      var rawData = result.first;

      return Inspection.fromMap(rawData);
    } on Exception catch (error) {
      print('Erro ao consultar inspeção pela data! $error');
      return null;
    }
  }

  @override
  Future<Inspection?> findById(int id) async {
    try {
      var result = await database.rawQuery('SELECT * FROM ${Sqlite.INSPECTIONS_TABLE} WHERE ${InspectionTable.id} = ?', [id]);

      var rawData = result.first;

      return Inspection.fromMap(rawData);
    } on Exception catch (error) {
      print('Erro ao consultar inspeção pela data! $error');
      return null;
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