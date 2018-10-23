import 'dart:convert';

class OstanEntity {
  String id;
  String ostanCode;
  String ostanName;
  //-----------------------------------------------------
  OstanEntity({this.id, this.ostanCode, this.ostanName});
  //-----------------------------------------------------
  factory OstanEntity.fromJson(Map json) {
    return OstanEntity(
      id: json['_id'],
      ostanCode: json['ostanCode'],
      ostanName: json['ostanName'],
    );
  }
}
//---------------OutSide Class----------------------------------------------------
List<OstanEntity> parseOstan(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<OstanEntity>((json) => OstanEntity.fromJson(json)).toList();
}

dynamic ostanToMap(OstanEntity ostan) {
  var mapData = new Map();
  if (ostan.id.isNotEmpty) mapData['_id'] = ostan.id;
  mapData['ostanCode'] = ostan.ostanCode;
  mapData['ostanName'] = ostan.ostanName;
  return mapData;
}
