import 'package:app_nutricao/data/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class CardapioDAO {
  static Future<int> insertCardapio(
      String dsc_cdp, int cat_cdp, String str_cdp) async {
    final database = await DatabaseProvider.database();
    final data = {
      'dsc_cdp': dsc_cdp,
      'cat_cdp': cat_cdp,
      'str_cdp': str_cdp,
    };
    final id = await database.insert('tbl_cardapio', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllCardapios() async {
    final database = await DatabaseProvider.database();
    return database.query('tbl_cardapio', orderBy: 'id_cdp');
  }

  static Future<bool> isMenuRegistered(String menuName) async {
    final database = await DatabaseProvider.database();
    final result = await database.query(
      'tbl_cardapio',
      where: 'dsc_cdp = ?',
      whereArgs: [menuName],
    );
    return result.isNotEmpty;
  }

  static Future<void> printAllCardapios() async {
    final List<Map<String, dynamic>> cardapios = await getAllCardapios();
    for (var cardapio in cardapios) {
      print(
          '${cardapio['id_cdp']} | ${cardapio['dsc_cdp']} | ${cardapio['cat_cdp']} | ${cardapio['str_cdp']}');
    }
  }

  static Future<List<Map<String, dynamic>>> searchCardapioByName(
      String searchText) async {
    final db = await DatabaseProvider.database();
    return await db.query('tbl_cardapio',
        where: 'dsc_cdp LIKE ?', whereArgs: ['%$searchText%']);
  }

  static Future<int> updateCardapio(
      int id_cdp, String dsc_cdp, int cat_cdp, int fk_id_alm) async {
    final database = await DatabaseProvider.database();
    final data = {
      'dsc_cdp': dsc_cdp,
      'cat_cdp': cat_cdp,
      'fk_id_alm': fk_id_alm,
    };
    final result = await database
        .update('tbl_cardapio', data, where: 'id_cdp = ?', whereArgs: [id_cdp]);
    return result;
  }

  static Future<void> deleteCardapio(int id_cdp) async {
    final database = await DatabaseProvider.database();
    try {
      await database
          .delete('tbl_cardapio', where: 'id_cdp = ?', whereArgs: [id_cdp]);
    } catch (e) {
      print(
          "Ocorreu algum erro ao remover o registro da tabela 'tbl_cardapio': $e");
    }
  }

  static Future<List<Map<String, dynamic>>> searchAlimentoInCardapio(
      String nomeAlimento) async {
    final database = await DatabaseProvider.database();
    return database.rawQuery('''
    SELECT tbl_cardapio.*, tbl_alimento.*
    FROM tbl_cardapio
    JOIN tbl_alimento ON tbl_cardapio.fk_id_alm = tbl_alimento.id_alm
    WHERE tbl_alimento.dsc_alm LIKE ?
  ''', ['%$nomeAlimento%']);
  }
}
