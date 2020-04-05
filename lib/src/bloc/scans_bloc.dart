import 'dart:async';

import 'package:qrreaderapp/src/bloc/validator.dart';
import 'package:qrreaderapp/src/models/scann_model.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScansBloc with Validators {

  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._internal(){
    //Obtener los Scans de la base de datos
    obtenerScans();//Cada que lo creo llamo a todos los scans

  }

  final _scansController = StreamController<List<ScannModel>>.broadcast();

  Stream<List<ScannModel>> get scansStream => _scansController.stream.transform(validarGeo);
  Stream<List<ScannModel>> get scansStreamHttp => _scansController.stream.transform(validarHttp);

  dispose(){
    _scansController.close();
  }

  agregarScan( ScannModel scan ) async{
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  obtenerScans() async{
    _scansController.sink.add( await DBProvider.db.getTodosScans());
  }

  borrarScan(int id) async{
    await DBProvider.db.deleteScan(id);
    obtenerScans();//Vuelve a consultar y lo adiciona :D
  }

  borrarScansTODOS() async{
    await DBProvider.db.deleteAll();
    obtenerScans();
  }

}



