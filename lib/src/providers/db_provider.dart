
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qrreaderapp/src/models/scann_model.dart';
export 'package:qrreaderapp/src/models/scann_model.dart';//Cada que cargue este se agrega tambien o se puede usar

class DBProvider {

  static Database _database;
  static final DBProvider db = DBProvider._();//Constructor privado para que no se creen dos bases de datos

  DBProvider._();//Constructor privado

  Future<Database> get database async {

    if(_database != null) return _database; //Si ya se encuentra creada solo se retorna 
    

    _database = await initDB();

    return _database;
  }


  initDB() async{

    //Donde se encuentra nuestra base de datos
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    final path = join( documentDirectory.path, 'ScansDB.db' );//Direccion junto con el nombre del archivo

    return await openDatabase(
      path,
      version: 1,// si hacemos un cambio, agregar una tabla o algo, aumentar en 1 la version
      onOpen: (db){},
      onCreate: (Database db, int version) async{
        //Aqui ya la tengo creada y lista para usarse

        await db.execute(
          'CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' tipo TEXT,'
          ' valor TEXT'
          ')'
        );
      }

    );
  }


  //CREAR - Registros
  nuevoScanRaw( ScannModel nuevoScan ) async{

    final db = await database;

    final res = await db.rawInsert(
      "INSERT INTO Scans (id, tipo, valor) "
      "VALUES ( ${ nuevoScan.id }, '${ nuevoScan.tipo }', '${ nuevoScan.valor }' )"
    );//String que mando como argumento

    return res; //retorna el numero de inserciones realizadas
  }

  nuevoScan( ScannModel nuevoScan ) async{

    final db = await database;
    final res = await db.insert('Scans', nuevoScan.toJson() );
    return res;

  }
   

  //SELECT - Obtener informacion
  Future<ScannModel> getScanId( int id) async{

    final db = await database;

    final res = await db.query('Scans',where: 'id = ?', whereArgs: [id] );//Retornara una lista de Mapas con esas condiciones

    //Si la respuesta no esta vacia envio el Map para que me regrese una instancia,
    //Pero pongo el .first para que solo me traega el primer resultado, si es que hay 2 o mas
    return res.isNotEmpty ? ScannModel.fromJson(res.first) : null;

  }

  Future<List<ScannModel>> getTodosScans() async{
    
    final db = await database;
    final res = await db.query('Scans');//Retorna un listado de Mapas

    List<ScannModel> list = res.isNotEmpty 
                              ? res.map( (c) => ScannModel.fromJson(c) ).toList()
                              : [];

    return list;
  }

  Future<List<ScannModel>> getScansPorTipo(String tipo) async{
    
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$tipo'");

    List<ScannModel> list = res.isNotEmpty 
                              ? res.map( (c) => ScannModel.fromJson(c) ).toList()
                              : [];

    return list;
  }


  //Actualizar Registros
  Future<int> updateScan( ScannModel nuevoScan ) async{

    final db = await database;

    final res = await db.update('Scans', nuevoScan.toJson(), where: 'id = ?', whereArgs: [nuevoScan.id]);

    return res;
  }


  //Eliminar Registros
  deleteScan( int id) async{

    final db = await database;

    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return res; //Numero de eliminados

  }


  deleteAll( ) async{

    final db = await database;

    final res = await db.rawDelete('DELETE FROM Scans');

    return res; //Numero de eliminados

  }


}


