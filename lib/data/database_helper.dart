import 'package:sqflite/sqflite.dart' as sql;

class DatabaseProvider {
  static Future<void> createTables(sql.Database database) async {
    // Se der erro de cardapio, tire o comentario da linha abaixo, compile 1x o código
    // Depois remova a linha, e compile mais uma vez o código.

    await database.execute("""CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        email TEXT,
        birthdate TEXT,
        password TEXT,
        avatar TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
    await database.execute("""CREATE TABLE tbl_alimento(
        id_alm INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        dsc_alm TEXT,
        fto_alm TEXT,
        ctg_alm TEXT,
        cal_alm INT
      )
      """);
    await database.execute("""CREATE TABLE tbl_cardapio(
        id_cdp INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        dsc_cdp TEXT,
        cat_cdp INTEGER,
        str_cdp TEXT
      )
      """);
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase(
      'nutricao.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await DatabaseProvider.createTables(database);
      },
    );
  }
}
