import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zaraban/entity/CityEntity.dart';
import 'package:zaraban/entity/OstanEntity.dart';
import 'package:zaraban/provider/bloc.provider.dart';
import 'package:zaraban/screen/city/city.list.dart';
import 'package:zaraban/screen/ostan/ostan.list.dart';
import 'package:zaraban/service/rest.client.dart';
import 'package:zaraban/util/const.text.dart';
import 'package:zaraban/util/validators.dart';

class CityBloc extends Object with Validators implements BlocBase {
  RestClient _rest;
  List<CityEntity> _cityList = [];
  List<OstanEntity> _ostanList = [];

  List<OstanEntity> queryOstanList = [];
  List<CityEntity> queryCityList = [];

  //------------------------City Controller--------------------------------
  final _cityIdCtrl = BehaviorSubject<String>();
  final _cityCodeCtrl = BehaviorSubject<String>();
  final _cityNameCtrl = BehaviorSubject<String>();

  final _cityListCtrl = BehaviorSubject<List<CityEntity>>();
  final _ostanListCtrl = BehaviorSubject<List<OstanEntity>>();
  final _ostanSelectCtrl = BehaviorSubject<OstanEntity>();
  //--------------------------Global Controller-----------------------------
  final _loadingCtrl = BehaviorSubject<bool>(seedValue: false);
  final _rowIndex = BehaviorSubject<int>(seedValue: -1);
  final _msgCtrl = BehaviorSubject<String>(seedValue: '');
  //----------------------------Ostan Stream--------------------------------
  Stream<String> get streamCityCode =>
      _cityCodeCtrl.stream.transform(validateRequired);
  Stream<String> get streamCityName =>
      _cityNameCtrl.stream.transform(validateRequired);
  Stream<String> get streamCityId => _cityIdCtrl.stream;
  Stream<List<CityEntity>> get streamCityList => _cityListCtrl.stream;
  Stream<List<OstanEntity>> get streamOstanList => _ostanListCtrl.stream;
  Stream<OstanEntity> get streamOstanSelect => _ostanSelectCtrl.stream;

  Stream<bool> get submitValid => Observable.combineLatest3(
      streamCityCode, streamCityName, streamOstanSelect, (e, p, ostan) => true);
  //----------------------------Global Stream--------------------------------
  Stream<bool> get streamLoading => _loadingCtrl.stream;
  Stream<int> get streamRowIndex => _rowIndex.stream;
  Stream<String> get streamMSG => _msgCtrl.stream;
  //------------------------Sink Ostan---------------------------------------
  Function(String) get sinkCityCode => _cityCodeCtrl.sink.add;
  Function(String) get sinkCityName => _cityNameCtrl.sink.add;
  //------------------------Sink Global--------------------------------------
  Function(String) get sinkMSG => _msgCtrl.sink.add;
  //-------------------------------------------------------------------------
  CityBloc() {
    _rest = RestClient();
    _fetchCity();
  }
  //--------------------------Bottom Menu City List--------------------------
  bottomMenuClick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => CityListWidget(
              streamCityList,
              (dynamic data, int index) => _listRowClick(context, data, index),
              (String data) => _searchCityFunc(data),
            ),
        fullscreenDialog: true,
      ),
    );
  }

  //---------------- Ostan List Button Click--------------------------------
  showOstanList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => OstanListWidget(
              streamOstanList,
              (dynamic data, int index) =>
                  _ostanListRowClick(context, data, index),
              (String data) => _searchOstanFunc(data),
            ),
        fullscreenDialog: true,
      ),
    );
  }

  //------------------------------------------------------------------------
  _fetchCity() async {
    _loadingCtrl.add(true);
    if (_cityList.isEmpty) {
      List<String> list = await Future.wait(
          [_rest.fetchData('city'), _rest.fetchData('ostan')]);
      if (list[0].isNotEmpty) {
        _cityList.addAll(parseCity(list[0]));
        _cityListCtrl.add(_cityList);
      }
      if (list[1].isNotEmpty) {
        _ostanList.addAll(parseOstan(list[1]));
        _ostanListCtrl.add(_ostanList);
      }
      _loadingCtrl.add(false);
    }
  }

  //-------------------------City List Search Function---------------------
  _searchCityFunc(String query) {
    queryCityList.clear();
    if (query.isNotEmpty) {
      for (var city in _cityList) {
        if (city.cityName.contains(query)) {
          queryCityList.add(city);
          _cityListCtrl.add(queryCityList);
        }
      }
    } else {
      _cityListCtrl.add(_cityList);
    }
  }

  //-----------------Ostan List Search Function--------------------------
  _searchOstanFunc(String query) {
    queryOstanList.clear();
    if (query.isNotEmpty) {
      for (var ostan in _ostanList) {
        if (ostan.ostanName.contains(query)) {
          queryOstanList.add(ostan);
          _ostanListCtrl.add(queryOstanList);
        }
      }
    } else {
      _ostanListCtrl.add(_ostanList);
    }
  }

  //----------------------------City List Row Click----------------------
  _listRowClick(BuildContext context, CityEntity data, int index) {
    sinkCityCode(data.cityCode);
    sinkCityName(data.cityName);
    _cityIdCtrl.add(data.id);
    _ostanSelectCtrl.add(data.ostan);
    _rowIndex.add(index);
    Navigator.pop(context);
  }

  //----------------------------Ostan List Row Click----------------------
  _ostanListRowClick(BuildContext context, OstanEntity data, int index) {
    _ostanSelectCtrl.add(data);
    Navigator.pop(context);
  }

  //----------------------------------------------------------------------
  save() async {
    _loadingCtrl.add(true);
    var index = -1;
    index = _cityList.indexWhere((data) {
      return ((data.cityCode == _cityCodeCtrl.value &&
              data.ostan.ostanCode == _ostanSelectCtrl.value.ostanCode) ||
          (data.cityName == _cityNameCtrl.value &&
              data.ostan.ostanCode == _ostanSelectCtrl.value.ostanCode));
    });
    if (_rowIndex.value != -1) {
      edit(index);
    } else {
      if (index == -1) {
        dynamic city = CityEntity(
            id: '',
            cityCode: _cityCodeCtrl.value,
            cityName: _cityNameCtrl.value,
            ostan: _ostanSelectCtrl.value);
        final res = await _rest.save(cityToMap(city));
        if (res.isNotEmpty) {
          _cityList.add(CityEntity.fromJson(res));
          _cityListCtrl.add(_cityList);
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
      dynamic city = CityEntity(
          id: _cityIdCtrl.value,
          cityCode: _cityCodeCtrl.value,
          cityName: _cityNameCtrl.value,
          ostan: _ostanSelectCtrl.value);
      final res = await _rest.update(cityToMap(city));

      if (res.isNotEmpty) {
        _cityList[_rowIndex.value] = city;
        _cityListCtrl.add(_cityList);
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
  clearTextField() {
    sinkCityCode('');
    sinkCityName('');
    _ostanSelectCtrl.add(null);
    sinkMSG('');
  }

  //------------------------------------------------------------------------
  @override
  void dispose() {
    _cityCodeCtrl.close();
    _cityNameCtrl.close();
    _cityIdCtrl.close();
    _cityListCtrl.close();
    _ostanSelectCtrl.close();
    /**/
    _loadingCtrl.close();
    _rowIndex.close();
    _msgCtrl.close();
    /**/
    _rest = null;
  }
  //------------------------------------------------------------------------
}
