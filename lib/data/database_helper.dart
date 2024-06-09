import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Database {
  static Future<void> createTables(sql.Database database) async {
    await createUsersTable(database);
    await createAlmTable(database);
    await createCdpTable(database);
  }

  // CRIAR TABELAS
  // Criar tabela Users
  static Future<void> createUsersTable(sql.Database database) async {
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

  // Criar tabela Alimento
  static Future<void> createAlmTable(sql.Database database) async {
    await database.execute("""CREATE TABLE tbl_alimento(
        id_alm INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        dsc_alm TEXT,
        fto_alm TEXT,
        ctg_alm TEXT,
        cal_alm INT
      )
      """);
  }

  // Criar tabela Cardápio
  static Future<void> createCdpTable(sql.Database database) async {
    await database.execute("""CREATE TABLE tbl_cardapio(
        id_cdp INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        dsc_cdp TEXT,
        cat_cdp INTEGER,
        fk_id_alm INTEGER,
        FOREIGN KEY (fk_id_alm) REFERENCES tbl_alimento(id_alm)
      )
      """);
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase(
      'nutricao.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // INSERIR REGISTROS
  // Insere registro em 'users'
  static Future<int> insereRegistro(
      String name, String email, String birthdate, String password) async {
    final database = await Database.database();

    final data = {
      'name': name,
      'email': email,
      'birthdate': birthdate,
      'password': password
    };

    final id = await database.insert('users', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Insere registro em 'tbl_cardapio'
  static Future<int> insereRegistroCardapio(
      String dsc_cdp, int cat_cdp, int fk_id_alm) async {
    final database = await Database.database();

    final data = {
      'dsc_cdp': dsc_cdp,
      'cat_cdp': cat_cdp,
      'fk_id_alm': fk_id_alm,
    };

    final id = await database.insert('tbl_cardapio', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Insere um novo registro na tabela 'tbl_alimento'
  static Future<int> insereRegistroAlimento(
      String dsc_alm, String fto_alm, String ctg_alm, int cal_alm) async {
    final database = await Database.database();

    final data = {
      'dsc_alm': dsc_alm,
      'fto_alm': fto_alm,
      'ctg_alm': ctg_alm,
      'cal_alm': cal_alm,
    };

    final id = await database.insert('tbl_alimento', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // EXIBIR REGISTROS
  // Retorna todos os registros da tabela 'users'
  static Future<List<Map<String, dynamic>>> exibeTodosRegistrosUsers() async {
    final database = await Database.database();
    return database.query('users', orderBy: 'id');
  }

  // Retorna todos os registros da tabela 'tbl_alimento'
  static Future<List<Map<String, dynamic>>>
      exibeTodosRegistrosAlimento() async {
    final database = await Database.database();
    return database.query('tbl_alimento', orderBy: 'id_alm');
  }

  // Retorna todos os registros da tabela 'tbl_cardapio'
  static Future<List<Map<String, dynamic>>>
      exibeTodosRegistrosCardapio() async {
    final database = await Database.database();
    return database.query('tbl_cardapio', orderBy: 'id_cdp');
  }

  // Buscar por nome na 'tbl_alimento'
  static Future<List<Map<String, dynamic>>> buscaAlimentoPorNome(
      String nomeAlimento) async {
    final database = await Database.database();
    return database.query('tbl_alimento',
        where: 'dsc_alm LIKE ?', whereArgs: ['%$nomeAlimento%']);
  }

  // Busca um alimento pelo nome na tabela 'tbl_cardapio'
  static Future<List<Map<String, dynamic>>> buscaAlimentoNoCardapio(
      String nomeAlimento) async {
    final database = await Database.database();
    return database.rawQuery('''
      SELECT tbl_cardapio.*, tbl_alimento.*
      FROM tbl_cardapio
      JOIN tbl_alimento ON tbl_cardapio.fk_id_alm = tbl_alimento.id_alm
      WHERE tbl_alimento.dsc_alm LIKE ?
    ''', ['%$nomeAlimento%']);
  }

  // VALIDAÇÕES DE LOGIN
  // Exibir usuarios no console(somente para controle)
  static Future<void> imprimirUsuariosNoPrompt() async {
    final List<Map<String, dynamic>> users = await exibeTodosRegistrosUsers();

    for (var user in users) {
      print('${user['name']} | ${user['email']} | ${user['password']}');
    }
  }

  // Verifica se o login é válido
  static Future<bool> verificaLogin(String email, String senha) async {
    final database = await Database.database();

    final List<Map<String, dynamic>> results = await database.query(
      'users',
      columns: ['id', 'email', 'password'],
      where: 'email = ? AND password = ?',
      whereArgs: [email, senha],
    );

    return results.isNotEmpty;
  }

  // Retornar usuario logado para ser usado no menu principal
  static Future<String?> getNomeUsuario(String email) async {
    final database = await Database.database();

    final List<Map<String, dynamic>> results = await database.query(
      'users',
      columns: ['name'],
      where: 'email = ?',
      whereArgs: [email],
    );

    if (results.isNotEmpty) {
      return results.first['name'] as String?;
    } else {
      return null;
    }
  }

  // ATUALIZAÇÃO DE REGISTROS
  // Atualizar registros na tabela 'users'
  static Future<int> atualizaRegistro(int id, String name, String email,
      String password, String birthdate) async {
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

  // Atualiza um registro da tabela 'tbl_alimento'
  static Future<int> atualizaRegistroAlimento(int id_alm, String dsc_alm,
      String fto_alm, String ctg_alm, int cal_alm) async {
    final database = await Database.database();

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

  // Atualiza um registro da tabela 'tbl_cardapio'
  static Future<int> atualizaRegistroCardapio(
      int id_cdp, String dsc_cdp, int cat_cdp, int fk_id_alm) async {
    final database = await Database.database();

    final data = {
      'dsc_cdp': dsc_cdp,
      'cat_cdp': cat_cdp,
      'fk_id_alm': fk_id_alm,
    };

    final result = await database
        .update('tbl_cardapio', data, where: 'id_cdp = ?', whereArgs: [id_cdp]);
    return result;
  }

  // REMOÇÃO DE REGISTRO (todos por ID)
  // Remove registro no 'users'
  static Future<void> removeRegistrouUsers(int id) async {
    final database = await Database.database();
    try {
      await database.delete("users", where: "id = ?", whereArgs: [id]);
    } catch (e) {
      debugPrint("Ocorreu algum erro ao remover o registro: $e");
    }
  }

  // Remove um registro da tabela 'tbl_alimento'
  static Future<void> removeRegistroAlimento(int id_alm) async {
    final database = await Database.database();
    try {
      await database
          .delete('tbl_alimento', where: 'id_alm = ?', whereArgs: [id_alm]);
    } catch (e) {
      debugPrint(
          "Ocorreu algum erro ao remover o registro da tabela 'tbl_alimento': $e");
    }
  }

  // Remove um registro da tabela 'tbl_cardapio'
  static Future<void> removeRegistroCardapio(int id_cdp) async {
    final database = await Database.database();
    try {
      await database
          .delete('tbl_cardapio', where: 'id_cdp = ?', whereArgs: [id_cdp]);
    } catch (e) {
      debugPrint(
          "Ocorreu algum erro ao remover o registro da tabela 'tbl_cardapio': $e");
    }
  }

  // Verificar se o e-mail já está registrado - Usado no cadastro (loginPage)
  static Future<bool> isEmailRegistered(String email) async {
    final database = await Database.database();
    final result = await database.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    return result.isNotEmpty;
  }
}
