import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zaraban/entity/OstanEntity.dart';
import 'package:zaraban/provider/bloc.provider.dart';
import 'package:zaraban/screen/ostan/ostan.list.dart';
import 'package:zaraban/service/rest.client.dart';
import 'package:zaraban/util/const.text.dart';
import 'package:zaraban/util/validators.dart';

class OstanBloc extends Object with Validators implements BlocBase {
  RestClient _rest;
  List<OstanEntity> _ostanList = [];
  List<OstanEntity> _queryList = [];
  //------------------------Ostan Controller------------------------------
  final _ostanIdCtrl = BehaviorSubject<String>();
  final _ostanCodeCtrl = BehaviorSubject<String>();
  final _ostanNameCtrl = BehaviorSubject<String>();
  final _ostanListCtrl = BehaviorSubject<List<OstanEntity>>();
  //--------------------------Global Controller-----------------------------
  final _loadingCtrl = BehaviorSubject<bool>();
  final _rowIndex = BehaviorSubject<int>(seedValue: -1);
  final _msgCtrl = BehaviorSubject<String>(seedValue: '');
  //----------------------------Ostan Stream--------------------------------
  Stream<String> get streamOstanCode =>
      _ostanCodeCtrl.stream.transform(validateRequired);
  Stream<String> get streamOstanName =>
      _ostanNameCtrl.stream.transform(validateRequired);
  Stream<String> get streamOstanId => _ostanIdCtrl.stream;
  Stream<List<OstanEntity>> get streamOstanList => _ostanListCtrl.stream;

  Stream<bool> get submitValid => Observable.combineLatest2(
      streamOstanCode, streamOstanName, (e, p) => true);
  //----------------------------Global Stream--------------------------------
  Stream<bool> get streamLoading => _loadingCtrl.stream;
  Stream<int> get streamRowIndex => _rowIndex.stream;
  Stream<String> get streamMSG => _msgCtrl.stream;
  //------------------------Sink Ostan---------------------------------------
  Function(String) get sinkOstanCode => _ostanCodeCtrl.sink.add;
  Function(String) get sinkOstanName => _ostanNameCtrl.sink.add;
  //------------------------Sink Global---------------------------------------
  Function(String) get sinkMSG => _msgCtrl.sink.add;
  //-----------------------------------------------------------------------
  OstanBloc() {
    _rest = RestClient();
    _fetchOstan();
  }
  //-----------------------------------------------------------------------
  bottomMenuClick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => OstanListWidget(
              streamOstanList,
              (dynamic data, int index) => _listRowClick(context, data, index),
              (String data) => _searchFunc(data),
            ),
        fullscreenDialog: true,
      ),
    );
  }

  //------------------------------------------------------------------------
  _fetchOstan() {
    if (_ostanList.isNotEmpty)
      _loadingCtrl.add(false);
    else {
      _loadingCtrl.add(true);
      _rest.fetchData('ostan').then((res) {
        if (res.isNotEmpty) {
          _ostanList.addAll(parseOstan(res));
          _ostanListCtrl.add(_ostanList);
        }
      });
    }
    _loadingCtrl.add(false);
  }

  //------------------------------------------------------------------------
  _searchFunc(String query) {
    _queryList.clear();
    if (query.isNotEmpty) {
      for (var ostan in _ostanList) {
        if (ostan.ostanName.contains(query)) {
          _queryList.add(ostan);
          _ostanListCtrl.add(_queryList);
        }
      }
    } else {
      _ostanListCtrl.add(_ostanList);
    }
  }

  //------------------------------------------------------------------------
  _listRowClick(BuildContext context, OstanEntity data, int index) {
    sinkOstanCode(data.ostanCode);
    sinkOstanName(data.ostanName);
    _ostanIdCtrl.add(data.id);
    _rowIndex.add(index);
    Navigator.pop(context);
  }

  //------------------------------------------------------------------------
  save() async {
    _loadingCtrl.add(true);
    int index = _ostanList.indexWhere((data) {
      return (data.ostanCode == _ostanCodeCtrl.value ||
          data.ostanName == _ostanNameCtrl.value);
    });
    if (_rowIndex.value != -1) {
      edit(index);
    } else {
      if (index == -1) {
        dynamic ostan = OstanEntity(
            id: '',
            ostanCode: _ostanCodeCtrl.value,
            ostanName: _ostanNameCtrl.value);
        final res = await _rest.save(ostanToMap(ostan));
        if (res.isNotEmpty) {
          _ostanList.add(OstanEntity.fromJson(res));
          _ostanListCtrl.add(_ostanList);
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
      dynamic ostan = OstanEntity(
          id: _ostanIdCtrl.value,
          ostanCode: _ostanCodeCtrl.value,
          ostanName: _ostanNameCtrl.value);
      final res = await _rest.update(ostanToMap(ostan));

      if (res.isNotEmpty) {
        _ostanList[_rowIndex.value] = ostan;
        _ostanListCtrl.add(_ostanList);
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
  String toJson(String ostanId, String ostanCode, String ostanName, bool flag) {
    var mapData = Map();
    if (flag == true) mapData['_id'] = ostanId;
    mapData['ostanCode'] = ostanCode;
    mapData['ostanName'] = ostanName;
    String json = jsonEncode(mapData);
    return json;
  }

  //------------------------------------------------------------------------
  clearTextField() {
    sinkOstanCode('');
    sinkOstanName('');
    sinkMSG('');
  }

  //------------------------------------------------------------------------
  @override
  void dispose() {
    _ostanCodeCtrl.close();
    _ostanNameCtrl.close();
    _ostanIdCtrl.close();
    _ostanListCtrl.close();
    /**/
    _loadingCtrl.close();
    _rowIndex.close();
    _msgCtrl.close();
    /**/
    _rest = null;
  }
  //------------------------------------------------------------------------
}
