import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scann_model.dart';

import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class  DireccionesPage extends StatelessWidget {

  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    scansBloc.obtenerScans();

    return StreamBuilder<List<ScannModel>>(
      stream: scansBloc.scansStreamHttp ,
      builder: (BuildContext context, AsyncSnapshot<List<ScannModel>> snapshot) {

        if( !snapshot.hasData ){
          return Center(
            child: CircularProgressIndicator(),
          );
        }  

        final scans = snapshot.data;

        if( scans.length == 0 ){
          return Center(child: Text('No hay informacion'));
        }

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i)=>Dismissible( //Permite deslizar de izq a der o viseversa
            key: UniqueKey(), //UniqueKey() => es una ayuda de flutter para crear un id unico
            background: Container( color: Theme.of(context).primaryColor),
            onDismissed: ( direction) => scansBloc.borrarScan(scans[i].id),
            child: ListTile(
              leading: Icon(Icons.cloud_queue, color: Theme.of(context).primaryColor,),
              title: Text(scans[i].valor),
              subtitle: Text('ID: ${ scans[i].id }'),
              trailing: Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
              onTap: () => utils.abrirScan(context ,scans[i])
            ),
          ),
        );

      },
    );
  }
}