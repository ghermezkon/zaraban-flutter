import 'dart:convert';
//تعریف انواع تخصص. به عنوان مثال پزششک قبارای تخصص جراجی عروق
class TypeCaptionEntity {
  String id;
  String tcCode;
  String tcName;
  //-----------------------------------------------------
  TypeCaptionEntity({this.id, this.tcCode, this.tcName});
  //-----------------------------------------------------
  factory TypeCaptionEntity.fromJson(Map json) {
    return TypeCaptionEntity(
      id: json['_id'],
      tcCode: json['tcCode'],
      tcName: json['tcName'],
    );
  }
}

//---------------OutSide Class----------------------------------------------------
List<TypeCaptionEntity> parseTW(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<TypeCaptionEntity>((json) => TypeCaptionEntity.fromJson(json))
      .toList();
}

dynamic tcToMap(TypeCaptionEntity tc) {
  var mapData = new Map();
  if (tc.id.isNotEmpty) mapData['_id'] = tc.id;
  mapData['tcCode'] = tc.tcCode;
  mapData['tcName'] = tc.tcName;
  return mapData;
}
