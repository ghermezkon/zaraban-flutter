import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zaraban/entity/TypeSenfEntity.dart';
import 'package:zaraban/provider/bloc.provider.dart';
import 'package:zaraban/screen/type.senf/ts.list.dart';
import 'package:zaraban/service/rest.client.dart';
import 'package:zaraban/util/const.text.dart';
import 'package:zaraban/util/validators.dart';

class TypeSenfBloc extends Object with Validators implements BlocBase {
  RestClient _rest;
  List<TypeSenfEntity> _tsList = [];
  List<TypeSenfEntity> _queryList = [];
  //------------------------Type Work Controller------------------------------
  final _tsIdCtrl = BehaviorSubject<String>();
  final _tsCodeCtrl = BehaviorSubject<String>();
  final _tsNameCtrl = BehaviorSubject<String>();
  final _tsIconCtrl = BehaviorSubject<String>();
  final _tsListCtrl = BehaviorSubject<List<TypeSenfEntity>>();
  //--------------------------Global Controller-----------------------------
  final _loadingCtrl = BehaviorSubject<bool>(seedValue: false);
  final _rowIndex = BehaviorSubject<int>(seedValue: -1);
  final _msgCtrl = BehaviorSubject<String>(seedValue: '');
  //----------------------------Type Work Stream--------------------------------
  Stream<String> get streamTsCode =>
      _tsCodeCtrl.stream.transform(validateRequired);
  Stream<String> get streamTsName =>
      _tsNameCtrl.stream.transform(validateRequired);
  Stream<String> get streamTsIcon =>
      _tsIconCtrl.stream.transform(validateRequired);
  Stream<String> get streamTsId => _tsIdCtrl.stream;
  Stream<List<TypeSenfEntity>> get streamTsList => _tsListCtrl.stream;

  Stream<bool> get submitValid => Observable.combineLatest3(
      streamTsCode, streamTsName, streamTsIcon, (e, p, i) => true);
  //----------------------------Global Stream--------------------------------
  Stream<bool> get streamLoading => _loadingCtrl.stream;
  Stream<int> get streamRowIndex => _rowIndex.stream;
  Stream<String> get streamMSG => _msgCtrl.stream;
  //------------------------Sink Type Work---------------------------------------
  Function(String) get sinkTsCode => _tsCodeCtrl.sink.add;
  Function(String) get sinkTsName => _tsNameCtrl.sink.add;
  Function(String) get sinkTsIcon => _tsIconCtrl.sink.add;
  //------------------------Sink Global---------------------------------------
  Function(String) get sinkMSG => _msgCtrl.sink.add;
  //-----------------------------------------------------------------------
  TypeSenfBloc() {
    _rest = RestClient();
    _fetchTS();
  }

  //-----------------------------------------------------------------------
  bottomMenuClick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TypeSenfListWidget(
              streamTsList,
              (dynamic data, int index) => _listRowClick(context, data, index),
              (String data) => _searchFunc(data),
            ),
        fullscreenDialog: true,
      ),
    );
  }

  //------------------------------------------------------------------------
  _fetchTS() async {
    _loadingCtrl.add(true);
    if (_tsList.isEmpty) {
      final res = await _rest.fetchData('ts');
      if (res != null) {
        _tsList.addAll(parseTS(res));
        _tsListCtrl.add(_tsList);
        _loadingCtrl.add(false);
      }
    }
  }

  //------------------------------------------------------------------------
  _searchFunc(String query) {
    _queryList.clear();
    if (query.isNotEmpty) {
      for (var ts in _tsList) {
        if (ts.tsName.contains(query)) {
          _queryList.add(ts);
          _tsListCtrl.add(_queryList);
        }
      }
    } else {
      _tsListCtrl.add(_tsList);
    }
  }

  //------------------------------------------------------------------------
  _listRowClick(BuildContext context, TypeSenfEntity data, int index) {
    sinkTsCode(data.tsCode);
    sinkTsName(data.tsName);
    sinkTsIcon(data.tsIcon);
    _tsIdCtrl.add(data.id);
    _rowIndex.add(index);
    Navigator.pop(context);
  }

  //------------------------------------------------------------------------
  save() async {
    _loadingCtrl.add(true);
    int index = _tsList.indexWhere((data) {
      return (data.tsCode == _tsCodeCtrl.value ||
          data.tsName == _tsNameCtrl.value ||
          data.tsIcon == _tsIconCtrl.value);
    });
    if (_rowIndex.value != -1) {
      edit(index);
    } else {
      if (index == -1) {
        dynamic ts = TypeSenfEntity(
            id: '',
            tsCode: _tsCodeCtrl.value,
            tsName: _tsNameCtrl.value,
            tsIcon: _tsIconCtrl.value);
        final res = await _rest.save(tsToMap(ts));
        if (res.isNotEmpty) {
          _tsList.add(TypeSenfEntity.fromJson(res));
          _tsListCtrl.add(_tsList);
          _msgCtrl.add(SaveOkLBL);
        } else {
          _loadingCtrl.add(false);
          _msgCtrl.add(SaveErrorLBL);
        }
      } else {
        _msgCtrl.add(DoubleRecordLBL);
      }
    }
    _loadingCtrl.add(false);
  }

  //------------------------------------------------------------------------
  edit(int index) async {
    if (index == _rowIndex.value) {
      dynamic ts = TypeSenfEntity(
          id: _tsIdCtrl.value,
          tsCode: _tsCodeCtrl.value,
          tsName: _tsNameCtrl.value,
          tsIcon: _tsIconCtrl.value);
      final res = await _rest.update(tsToMap(ts));

      if (res.isNotEmpty) {
        _tsList[_rowIndex.value] = ts;
        _tsListCtrl.add(_tsList);
        _msgCtrl.add(UpdateOkLBL);
      } else {
        _loadingCtrl.add(false);
        _msgCtrl.add(UpdateErrorLBL);
      }
    } else {
      _msgCtrl.add(DoubleRecordLBL);
    }
    _rowIndex.add(-1);
  }

  //------------------------------------------------------------------------
  String toJson(
      String tsId, String tsCode, String tsName, String tsIcon, bool flag) {
    var mapData = Map();
    if (flag == true) mapData['_id'] = tsId;
    mapData['tsCode'] = tsCode;
    mapData['tsName'] = tsName;
    mapData['tsIcon'] = tsIcon;
    String json = jsonEncode(mapData);
    return json;
  }

  //------------------------------------------------------------------------
  clearTextField() {
    sinkTsCode('');
    sinkTsName('');
    sinkTsIcon('');
    sinkMSG('');
  }

  //------------------------------------------------------------------------
  @override
  void dispose() {
    _tsCodeCtrl.close();
    _tsNameCtrl.close();
    _tsIconCtrl.close();
    _tsIdCtrl.close();
    _tsListCtrl.close();
    /**/
    _loadingCtrl.close();
    _rowIndex.close();
    _msgCtrl.close();
    /**/
    _rest = null;
  }
  //------------------------------------------------------------------------
}
