import 'package:app_nutricao/data/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class UserDAO {
  static Future<int> insertUser(String name, String email, String birthdate,
      String password, String avatar) async {
    final database = await DatabaseProvider.database();
    final data = {
      'name': name,
      'email': email,
      'birthdate': birthdate,
      'password': password,
      'avatar': avatar
    };
    final id = await database.insert('users', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final database = await DatabaseProvider.database();
    return database.query('users', orderBy: 'id');
  }

  static Future<void> printAllUsers() async {
    final List<Map<String, dynamic>> users = await getAllUsers();
    for (var user in users) {
      print(
          '${user['name']} | ${user['email']} | ${user['password']} | ${user['avatar']}');
    }
  }

  static Future<bool> isEmailRegistered(String email) async {
    final database = await DatabaseProvider.database();
    final result = await database.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  static Future<int> updateUser(int id, String name, String email,
      String password, String avatar, String birthdate) async {
    final database = await DatabaseProvider.database();
    final data = {
      'name': name,
      'email': email,
      'password': password,
      'birthdate': birthdate,
      'avatar': avatar,
      'createdAt': DateTime.now().toString()
    };
    final result =
        await database.update('users', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteUser(int id) async {
    final database = await DatabaseProvider.database();
    try {
      await database.delete("users", where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print("Ocorreu algum erro ao remover o registro: $e");
    }
  }

  static Future<bool> verifyLogin(String email, String senha) async {
    final database = await DatabaseProvider.database();
    final List<Map<String, dynamic>> results = await database.query(
      'users',
      columns: ['id', 'email', 'password'],
      where: 'email = ? AND password = ?',
      whereArgs: [email, senha],
    );
    return results.isNotEmpty;
  }

  static Future<String?> getUserName(String email) async {
    final database = await DatabaseProvider.database();
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
}
