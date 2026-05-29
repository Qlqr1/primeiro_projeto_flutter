import 'package:sqflite_common/sqflite.dart';
import '../database/db.dart';
import '../model/aluno.dart';

Future<int> insert(Aluno aluno) async {
  final Database db = await getDatabase();
  return db.insert(
    'alunos',
    aluno.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Map<String, dynamic>>> findAll() async {
  final Database db = await getDatabase();
  List<Map<String, dynamic>> result = await db.query("alunos");
  return result;
}
