import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class RestClient {
  //------------------------------------------------------------------------
  final String _uri = 'http://82.102.10.253:5001/api/';
  final String _init = 'zaraban_init/';
  var dio = Dio();
  //------------------------------------------------------------------------
  Future<String> fetchData(String tableName) async {
    final res = await http.get(_uri + _init + tableName);
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return null;
    }
  }

  //------------------------------------------------------------------------
  dynamic save(dynamic jsonData) async {
    final res = await dio.post(
      _uri + _init,
      data: jsonData,
    );
    if (res.statusCode == 200)
      return res.data;
    else {
      return null;
    }
  }

  //------------------------------------------------------------------------
  dynamic update(dynamic jsonData) async {
    final res = await dio.put(
      _uri + _init,
      data: jsonData,
    );
    if (res.statusCode == 200)
      return res.data;
    else {
      return null;
    }
  }
  //------------------------------------------------------------------------

}
