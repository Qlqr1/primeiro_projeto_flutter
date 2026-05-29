import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqflite.dart';

Future<Database> getDatabase() async {
  final String caminhoBanco = join(await getDatabasesPath(), 'alunos.db');
  return openDatabase(
    caminhoBanco,
    onCreate: (db, version) {
      // Comandos para criar as tabelas do banco
      db.execute(
        "CREATE TABLE alunos (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, telefone TEXT, matricula TEXT);",
      );
    },
    version: 1,
  );
}
