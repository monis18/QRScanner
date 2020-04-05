import 'dart:io';

import 'package:flutter/material.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';

import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';
import 'package:qrreaderapp/src/models/scann_model.dart';

import 'package:qrreaderapp/src/utils/utils.dart' as utils;


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever), 
            onPressed: scansBloc.borrarScansTODOS
            )
        ],
      ),
      bottomNavigationBar: _crearBottomNavigatorBar(),
      body: _callPage(currentIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _scanQR(context),
      ),
      );
  }


  _scanQR(BuildContext context) async{
    
    //https://pub.dev/packages/barcode_scan#-installing-tab-
    //geo:40.741923619036605,-74.0540064855469


    //String futureString = '';
    String futureString ;

    try{
      futureString = await BarcodeScanner.scan();
    }catch( e ){
      futureString = e.toString();
    }

  if(futureString != null){
    
    final scan = ScannModel( valor: futureString );
    scansBloc.agregarScan(scan);

    if( Platform.isIOS ){
      Future.delayed(Duration(milliseconds: 750), (){
        utils.abrirScan(context, scan);
      } );
    }else{
      utils.abrirScan(context, scan);
    }


  }

  }

  Widget _callPage(int paginaActual){

    switch (paginaActual){

      case 0 : return MapasPage();
      case 1 : return DireccionesPage();
      default:
        return MapasPage();
   

    }

  }

  Widget _crearBottomNavigatorBar(){

    return BottomNavigationBar(
      currentIndex: currentIndex,//Le dice cual elemento esta activo
      onTap: (index){ //Recibe el index porque recibe en cual esta ativo 
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones')
        ),
      ],
    );

  }
}