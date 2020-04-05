import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart'; 

import 'package:qrreaderapp/src/models/scann_model.dart';


abrirScan( BuildContext context, ScannModel scan ) async {

  if ( scan.tipo == 'http' ){

    if (await canLaunch(scan.valor)) {
      await launch(scan.valor);
    } else {
      throw 'Could not launch ${scan.valor}';
    }
    
  }else{
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }
}





