import 'package:app_nutricao/data/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class AlimentoDAO {
  static Future<int> insertAlimento(
      String dsc_alm, String fto_alm, String ctg_alm, int cal_alm) async {
    final database = await DatabaseProvider.database();
    final data = {
      'dsc_alm': dsc_alm,
      'fto_alm': fto_alm,
      'ctg_alm': ctg_alm,
      'cal_alm': cal_alm,
    };
    final id = await database.insert('tbl_alimento', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllAlimentos() async {
    final database = await DatabaseProvider.database();
    return database.query('tbl_alimento', orderBy: 'dsc_alm');
  }

  static Future<void> printAllAlimentos() async {
    final List<Map<String, dynamic>> alimentos = await getAllAlimentos();
    for (var alimento in alimentos) {
      print(
          '${alimento['dsc_alm']} | ${alimento['fto_alm']} | ${alimento['ctg_alm']} | ${alimento['cal_alm']}');
    }
  }

  static Future<int> updateAlimento(int id_alm, String dsc_alm, String fto_alm,
      String ctg_alm, int cal_alm) async {
    final database = await DatabaseProvider.database();
    final data = {
      'dsc_alm': dsc_alm,
      'fto_alm': fto_alm,
      'ctg_alm': ctg_alm,
      'cal_alm': cal_alm,
    };
    final result = await database
        .update('tbl_alimento', data, where: 'id_alm = ?', whereArgs: [id_alm]);
    return result;
  }

  static Future<void> deleteAlimento(int id) async {
    final database = await DatabaseProvider.database();
    try {
      await database
          .delete('tbl_alimento', where: 'id_alm = ?', whereArgs: [id]);
    } catch (e) {
      print(
          "Ocorreu algum erro ao remover o registro da tabela 'tbl_alimento': $e");
    }
  }

  static Future<bool> isFoodRegistered(String foodName) async {
    final database = await DatabaseProvider.database();
    final result = await database.query(
      'tbl_alimento',
      where: 'dsc_alm = ?',
      whereArgs: [foodName],
    );
    return result.isNotEmpty;
  }

  static Future<List<Map<String, dynamic>>> searchAlimentoByName(
      String nomeAlimento) async {
    final database = await DatabaseProvider.database();
    return await database.query('tbl_alimento',
        where: 'dsc_alm LIKE ?', whereArgs: ['%$nomeAlimento%']);
  }

  static Future<List<Map<String, dynamic>>> searchSpecificAlimentoByName(
      String nomeAlimento) async {
    final database = await DatabaseProvider.database();
    final List<Map<String, dynamic>> results = await database.rawQuery(
        "SELECT * FROM tbl_alimento WHERE dsc_alm = ?", [nomeAlimento]);
    if (results.length == 1) {
      return results;
    } else {
      return [];
    }
  }
}
