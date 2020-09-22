import 'dart:async';
 import 'package:wallpaper_dope/src/models/db_model.dart';
import 'package:wallpaper_dope/src/providers/db_provider.dart';

class DBbloc {
  static final _singleton = new DBbloc._internal();
  factory DBbloc() {
    return _singleton;
  }

  DBbloc._internal() {
    obtenerFotosGuardadas();
  }

  final _dbBlocController = StreamController<List<DBModel>>.broadcast();

  Stream<List<DBModel>> get dbStrem => _dbBlocController.stream;

  dispose() {
    _dbBlocController?.close();
  }

  agregarFoto( DBModel foto ) async {
    await DBProvider.db.nuevaFoto(foto);
    obtenerFotosGuardadas();

  }

  obtenerFotosGuardadas() async {
    _dbBlocController.sink.add(await DBProvider.db.getTodosLosScans());
  }

}
