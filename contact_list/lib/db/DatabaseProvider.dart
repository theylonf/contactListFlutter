import 'dart:async';

import 'package:contact_list/model/Pessoa.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  late Database _database;

  DatabaseProvider._();

  static final DatabaseProvider dbProvider = DatabaseProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  Future<Database> createDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'pessoa_database.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE pessoas(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT,
          fotoPath TEXT
        )
      ''');
    });
  }

  Future<List<Pessoa>> listarPessoas() async {
    final db = await database;
    final result = await db.query('pessoas');
    return result.isNotEmpty
        ? result.map((map) => Pessoa.fromMap(map)).toList()
        : [];
  }

  Future<void> inserirPessoa(Pessoa pessoa) async {
    final db = await database;
    await db.insert('pessoas', pessoa.toMap());
  }

  Future<void> atualizarPessoa(Pessoa pessoa) async {
    final db = await database;
    await db.update(
      'pessoas',
      pessoa.toMap(),
      where: 'id = ?',
      whereArgs: [pessoa.id],
    );
  }

  Future<void> removerPessoa(int pessoaId) async {
    final db = await database;
    await db.delete(
      'pessoas',
      where: 'id = ?',
      whereArgs: [pessoaId],
    );
  }
}
