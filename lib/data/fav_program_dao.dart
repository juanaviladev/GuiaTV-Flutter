import 'package:guia_tv_flutter/models/program.dart';

import 'db.dart';

final programsDao = _ProgramDAO();

class _ProgramDAO {
  create(Program p) async {
    final db = await DbConnection.instance.db;
    await db.insert("program", p.toMap());
  }

  delete(String id) async {
    final db = await DbConnection.instance.db;
    await db.delete("program", where: "id = ?", whereArgs: [id]);
  }

  Future<List<Program>> readAll() async {
    final db = await DbConnection.instance.db;
    final res = await db.query("program");
    List<Program> list =
        res.isNotEmpty ? res.map((c) => Program.fromMap(c)).toList() : [];
    return list;
  }

  deleteAll() async {
    final db = await DbConnection.instance.db;
    await db.delete("program");
  }
}
