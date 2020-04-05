
import 'dart:async';

import 'package:qrreaderapp/src/models/scann_model.dart';

class Validators {

  final validarGeo = StreamTransformer<List<ScannModel>,List<ScannModel>>.fromHandlers(
    //Ingresa informacion y sale diferente(rechazarinf)

  handleData: (scans, sink) {

    final geoScans = scans.where((s) => s.tipo == 'geo').toList();
    sink.add(geoScans);

  }
  );

  final validarHttp = StreamTransformer<List<ScannModel>,List<ScannModel>>.fromHandlers(
    //Ingresa informacion y sale diferente(rechazarinf)

  handleData: (scans, sink) {

    final geoScans = scans.where((s) => s.tipo == 'http').toList();
    sink.add(geoScans);

  }
  );


  
}

