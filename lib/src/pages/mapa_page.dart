import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/models/scann_model.dart';

class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
    final map = new MapController();

    String tipoMapa = 'streets';

  @override
  Widget build(BuildContext context) {


  final ScannModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadad QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              map.move(scan.getLatLng(), 15);
            },
            )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBottonFlotante(context),
    );
  }

  Widget _crearBottonFlotante(BuildContext context){
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){
        //streets, dark, light, outdoors, satellite
        if(tipoMapa=='streets'){
          tipoMapa='dark';
        }else if(tipoMapa=='dark'){
          tipoMapa='light';
        }else if(tipoMapa=='light'){
          tipoMapa='outdoors';
        }else if(tipoMapa=='outdoors'){
          tipoMapa='satellite';
        }else{
          tipoMapa='streets';
        }
        setState(() {});
      },

      );
  }

  Widget _crearFlutterMap(ScannModel scan){

    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15
      ),
      layers: [
        //Capas de informacion que deseo poner

        _crearMapa(),
        _crearMarcadores( scan ),
      ],
    );

  }

  _crearMapa(){

    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/' //De donde voy a obtener la inf del mapa, servidor
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken' : 'pk.eyJ1IjoibW9uaXMxODE4IiwiYSI6ImNrOG05d2U1YjBnaXEzbG80a2tsOGxkYTMifQ.H7EwFy-i1ciW9bbIonuA1A',
        'id'          : 'mapbox.$tipoMapa'
      }
      //streets, dark, light, outdoors, satellite
    
    );


  }

  _crearMarcadores( ScannModel scan ){
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(
              Icons.location_on, 
              size: 60.0,
              color: Theme.of(context).primaryColor,
              ),
          )
        )


      ]
    );
  }
}