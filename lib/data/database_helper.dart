import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Database {
  // id: Chave primária do registro
  // name: nome do registro
  // email: email do registro
  //birthdate: data de nascimento do registro
  // created_at: Data e hora da criação do registro. Isso é retornado pelo banco de dados
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        email TEXT,
        birthdate TEXT,
        password TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase(
      'banco.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Insere um novo registro
  static Future<int> insereRegistro(String name, String email, String birthdate, String password) async {
    final database = await Database.database();

    final data = {'name': name, 'email': email, 'birthdate': birthdate, 'password': password};

    final id = await database.insert('users', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Retorna todos os registros da tabela
  static Future<List<Map<String, dynamic>>> exibeTodosRegistros() async {
    final database = await Database.database();
    return database.query('users', orderBy: "id");
  }

  // Retorna um único registro através de um ID
  // Esse método não foi usado mas deixado aqui para consulta
  static Future<List<Map<String, dynamic>>> retornaRegistro(int id) async {
    final database = await Database.database();
    return database.query('users', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Atualiza um registro
  static Future<int> atualizaRegistro(
      int id, String name, String email, String password, String birthdate) async {
    final database = await Database.database();

    final data = {
      'name': name,
      'email': email,
      'password': password,
      'birthdate': birthdate,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await database.update('users', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Remove um registro
  static Future<void> removeRegistro(int id) async {
    final database = await Database.database();
    try {
      await database.delete("users", where: "id = ?", whereArgs: [id]);
    } catch (e) {
      debugPrint("Ocorreu algum erro ao remover o registro: $e");
    }
  }
}
