import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallpaper_dope/src/models/db_model.dart';
export  'package:wallpaper_dope/src/models/db_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database; //para saber si esta inicializada
 
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory directorio = await getApplicationDocumentsDirectory();
    final path = join(directorio.path, 'Scans.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Fotos ("
          " id INTEGER PRIMARY KEY,"
          " url TEXT,"
          " lowResUrl TEXT"
          ")");
    });
   }

  Future<List<DBModel>> getTodosLosScans() async {
    final db = await database;
    final res = await db.query("Fotos");

    List<DBModel> list =
        res.isNotEmpty ? res.map((e) => DBModel.fromJson(e)).toList() : [];
    return list;
  }

  nuevaFoto(DBModel foto) async{
    final db = await database;
    final res = await db.insert('Fotos', foto.toJson());
    return res;
  }
}
