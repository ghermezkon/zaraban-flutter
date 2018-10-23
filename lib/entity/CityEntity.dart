import 'dart:convert';
import 'package:zaraban/entity/OstanEntity.dart';

class CityEntity {
  String id;
  String cityCode;
  String cityName;
  dynamic ostan;
  //-----------------------------------------------------
  CityEntity({this.id, this.cityCode, this.cityName, this.ostan});
  //-----------------------------------------------------
  factory CityEntity.fromJson(Map res) {
    return CityEntity(
      id: res['_id'],
      cityCode: res['cityCode'],
      cityName: res['cityName'],
      ostan: OstanEntity.fromJson(res['ostan']),
    );
  }
}

//---------------------------Outside Class-----------------------------------
List<CityEntity> parseCity(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<CityEntity>((json) => CityEntity.fromJson(json)).toList();
}

dynamic cityToMap(CityEntity city) {
  var mapData = new Map();
  if (city.id.isNotEmpty) mapData['_id'] = city.id;
  mapData['cityCode'] = city.cityCode;
  mapData['cityName'] = city.cityName;
  mapData['ostan'] = ostanToMap(city.ostan);
  return mapData;
}
