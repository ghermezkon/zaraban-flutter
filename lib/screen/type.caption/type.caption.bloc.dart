import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zaraban/entity/TypeCaptionEntity.dart';
import 'package:zaraban/provider/bloc.provider.dart';
import 'package:zaraban/screen/type.caption/tc.list.dart';
import 'package:zaraban/service/rest.client.dart';
import 'package:zaraban/util/const.text.dart';
import 'package:zaraban/util/validators.dart';

class TypeCaptionBloc extends Object with Validators implements BlocBase {
  RestClient _rest;
  List<TypeCaptionEntity> _tcList = [];
  List<TypeCaptionEntity> _queryList = [];
  //------------------------Type Work Controller------------------------------
  final _tcIdCtrl = BehaviorSubject<String>();
  final _tcCodeCtrl = BehaviorSubject<String>();
  final _tcNameCtrl = BehaviorSubject<String>();
  final _tcListCtrl = BehaviorSubject<List<TypeCaptionEntity>>();
  //--------------------------Global Controller-----------------------------
  final _loadingCtrl = BehaviorSubject<bool>(seedValue: false);
  final _rowIndex = BehaviorSubject<int>(seedValue: -1);
  final _msgCtrl = BehaviorSubject<String>(seedValue: '');
  //----------------------------Type Work Stream--------------------------------
  Stream<String> get streamTcCode =>
      _tcCodeCtrl.stream.transform(validateRequired);
  Stream<String> get streamTcName =>
      _tcNameCtrl.stream.transform(validateRequired);
  Stream<String> get streamTcId => _tcIdCtrl.stream;
  Stream<List<TypeCaptionEntity>> get streamTcList => _tcListCtrl.stream;

  Stream<bool> get submitValid => Observable.combineLatest2(
      streamTcCode, streamTcName, (e, p) => true);
  //----------------------------Global Stream--------------------------------
  Stream<bool> get streamLoading => _loadingCtrl.stream;
  Stream<int> get streamRowIndex => _rowIndex.stream;
  Stream<String> get streamMSG => _msgCtrl.stream;
  //------------------------Sink Type Work---------------------------------------
  Function(String) get sinkTcCode => _tcCodeCtrl.sink.add;
  Function(String) get sinkTcName => _tcNameCtrl.sink.add;
  //------------------------Sink Global---------------------------------------
  Function(String) get sinkMSG => _msgCtrl.sink.add;
  //-----------------------------------------------------------------------
  TypeCaptionBloc() {
    _rest = RestClient();
    _fetchTC();
  }
  //-----------------------------------------------------------------------
  bottomMenuClick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TypeCaptionListWidget(
              streamTcList,
              (dynamic data, int index) => _listRowClick(context, data, index),
              (String data) => _searchFunc(data),
            ),
        fullscreenDialog: true,
      ),
    );
  }

  //------------------------------------------------------------------------
  _fetchTC() async {
    _loadingCtrl.add(true);
    if (_tcList.isEmpty) {
      final res = await _rest.fetchData('tc');
      if (res != null) {
        _tcList.addAll(parseTW(res));
        _tcListCtrl.add(_tcList);
        _loadingCtrl.add(false);
      }
    }
  }

  //------------------------------------------------------------------------
  _searchFunc(String query) {
    _queryList.clear();
    if (query.isNotEmpty) {
      for (var tc in _tcList) {
        if (tc.tcName.contains(query)) {
          _queryList.add(tc);
          _tcListCtrl.add(_queryList);
        }
      }
    } else {
      _tcListCtrl.add(_tcList);
    }
  }

  //------------------------------------------------------------------------
  _listRowClick(BuildContext context, TypeCaptionEntity data, int index) {
    sinkTcCode(data.tcCode);
    sinkTcName(data.tcName);
    _tcIdCtrl.add(data.id);
    _rowIndex.add(index);
    Navigator.pop(context);
  }

  //------------------------------------------------------------------------
  save() async {
    _loadingCtrl.add(true);
    int index = _tcList.indexWhere((data) {
      return (data.tcCode == _tcCodeCtrl.value ||
          data.tcName == _tcNameCtrl.value);
    });
    if (_rowIndex.value != -1) {
      edit(index);
    } else {
      if (index == -1) {
        dynamic tc = TypeCaptionEntity(
            id: '',
            tcCode: _tcCodeCtrl.value,
            tcName: _tcNameCtrl.value);
        final res = await _rest.save(tcToMap(tc));
        if (res.isNotEmpty) {
          _tcList.add(TypeCaptionEntity.fromJson(res));
          _tcListCtrl.add(_tcList);
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
      dynamic tc = TypeCaptionEntity(
          id: _tcIdCtrl.value,
          tcCode: _tcCodeCtrl.value,
          tcName: _tcNameCtrl.value);
      final res = await _rest.update(tcToMap(tc));

      if (res.isNotEmpty) {
        _tcList[_rowIndex.value] = tc;
        _tcListCtrl.add(_tcList);
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
  String toJson(String tcId, String tcCode, String tcName, bool flag) {
    var mapData = Map();
    if (flag == true) mapData['_id'] = tcId;
    mapData['tcCode'] = tcCode;
    mapData['tcName'] = tcName;
    String json = jsonEncode(mapData);
    return json;
  }

  //------------------------------------------------------------------------
  clearTextField() {
    sinkTcCode('');
    sinkTcName('');
    sinkMSG('');
  }

  //------------------------------------------------------------------------
  @override
  void dispose() {
    _tcCodeCtrl.close();
    _tcNameCtrl.close();
    _tcIdCtrl.close();
    _tcListCtrl.close();
    /**/
    _loadingCtrl.close();
    _rowIndex.close();
    _msgCtrl.close();
    /**/
    _rest = null;
  }
  //------------------------------------------------------------------------
}
