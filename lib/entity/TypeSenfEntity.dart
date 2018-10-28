import 'dart:convert';
//تعریف انواع صنف/پزشک/شغل که دارای سیستم آنلاین رزرو می باشند.
//منوهای اصلی برنامه در این قسمت تعریف می شود
class TypeSenfEntity {
  String id;
  String tsCode;
  String tsName;
  String tsIcon;
  //-----------------------------------------------------
  TypeSenfEntity({this.id, this.tsCode, this.tsName, this.tsIcon});
  //-----------------------------------------------------
  factory TypeSenfEntity.fromJson(Map json) {
    return TypeSenfEntity(
      id: json['_id'],
      tsCode: json['tsCode'],
      tsName: json['tsName'],
      tsIcon: json['tsIcon'],
    );
  }
}

//---------------OutSide Class----------------------------------------------------
List<TypeSenfEntity> parseTS(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<TypeSenfEntity>((json) => TypeSenfEntity.fromJson(json))
      .toList();
}

dynamic tsToMap(TypeSenfEntity ts) {
  var mapData = new Map();
  if (ts.id.isNotEmpty) mapData['_id'] = ts.id;
  mapData['tsCode'] = ts.tsCode;
  mapData['tsName'] = ts.tsName;
  mapData['tsIcon'] = ts.tsIcon;
  return mapData;
}
