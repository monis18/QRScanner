
import 'package:latlong/latlong.dart';

class ScannModel {
    int id;
    String tipo;
    String valor;

    ScannModel({
        this.id,
        this.tipo,
        this.valor,
    }){
      if( valor.contains('http') ){
        this.tipo = 'http';
      }else{
        this.tipo = 'geo';
      }
    }

    factory ScannModel.fromJson(Map<String, dynamic> json) => ScannModel(
        id    : json["id"],
        tipo  : json["tipo"],
        valor : json["valor"],
    );

    Map<String, dynamic> toJson() => {
        "id"    : id,
        "tipo"  : tipo,
        "valor" : valor,
    };


    getLatLng(){
      //geo:40.741923619036605,-74.0540064855469
      //substring(4) =>40.741923619036605,-74.0540064855469
      //cplist(',')=> [40.741923619036605, -74.0540064855469] lista
      final lalo = valor.substring(4).split(',');
      final lat = double.parse( lalo[0] );
      final lon = double.parse( lalo[1] );

      return LatLng(
        lat, lon
      );
    }
}
