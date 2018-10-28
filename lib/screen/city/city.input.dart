import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zaraban/entity/OstanEntity.dart';
import 'package:zaraban/screen/city/city.bloc.dart';
import 'package:zaraban/util/const.text.dart';
import 'package:zaraban/util/dialog.widget.dart';
import 'package:zaraban/util/global.theme.dart';

class CityInput extends StatefulWidget {
  final CityBloc bloc;
  CityInput({Key key, this.bloc}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CityInputState();
}

class _CityInputState extends State<CityInput> {
  //------------------------------------------------------
  final cityCodeController = TextEditingController();
  final cityNameController = TextEditingController();
  OstanEntity ostan;
  //------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.bloc.streamLoading,
      builder: (context, snapshot) {
        if (snapshot.data == true)
          return Center(
            child: Container(
              width: 100.0,
              height: 100.0,
              child: CircularProgressIndicator(),
            ),
          );
        else
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              ListTile(
                trailing: Icon(
                  zNewIcon('ostan'),
                  color: zIconColor(),
                ),
                title: OutlineButton(
                  onPressed: () => widget.bloc.showOstanList(context),
                  child: StreamBuilder(
                    stream: widget.bloc.streamOstanSelect,
                    builder: (context, snapshot) => snapshot.hasData
                        ? Text(
                            '${snapshot.data.ostanName} (کد: ${snapshot.data.ostanCode})',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        : Text('$OstanListLBL'),
                  ),
                  splashColor: Colors.pink,
                ),
              ),
              ListTile(
                title: StreamBuilder(
                  stream: widget.bloc.streamCityCode,
                  builder: (context, snapshot) {
                    cityCodeController.text = snapshot.data;
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        controller: cityCodeController,
                        textAlign: TextAlign.center,
                        onFieldSubmitted: widget.bloc.sinkCityCode,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3)
                        ],
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.filter_9_plus,
                            color: zIconColor(),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: zBorderColor(),
                            ),
                          ),
                          hintText: CityCodeHINT,
                          labelText: CityCodeLBL,
                          errorText: snapshot.error,
                        ),
                      ),
                    );
                  },
                ),
              ),
              ListTile(
                title: Directionality(
                  textDirection: TextDirection.rtl,
                  child: StreamBuilder(
                    stream: widget.bloc.streamCityName,
                    builder: (context, snapshot) {
                      cityNameController.text = snapshot.data;
                      return TextFormField(
                        controller: cityNameController,
                        textAlign: TextAlign.right,
                        onFieldSubmitted: widget.bloc.sinkCityName,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.text_fields,
                            color: zIconColor(),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: zBorderColor(),
                            ),
                          ),
                          hintText: CityNameHINT,
                          labelText: CityNameLBL,
                          errorText: snapshot.error,
                        ),
                      );
                    },
                  ),
                ),
              ),
              ListTile(
                leading: Container(
                  child: FloatingActionButton(
                    elevation: 2.0,
                    child: Icon(Icons.refresh),
                    mini: true,
                    backgroundColor: Colors.pink,
                    onPressed: () => clearForm(widget.bloc, false),
                  ),
                ),
                title: Container(
                  child: StreamBuilder(
                    stream: widget.bloc.submitValid,
                    builder: (context, snapshot) => RaisedButton(
                          splashColor: Colors.white,
                          child: Text(
                            SaveButtonLBL,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: snapshot.hasData
                              ? () => _showAlert(context, widget.bloc)
                              : null,
                        ),
                  ),
                ),
                trailing: Container(
                  child: Text(''),
                ),
              ),
            ],
          );
      },
    );
  }

  //------------------------------------------------------------
  _showAlert(BuildContext context, CityBloc bloc) {
    bloc.save();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => ZDialog(
            widget.bloc.streamMSG,
            () => clearForm(widget.bloc, true),
          ),
    );
  }

//------------------------------------------------------------
  clearForm(CityBloc bloc, bool alert) {
    bloc.clearTextField();
    cityCodeController.clear();
    cityNameController.clear();
    if (alert) Navigator.of(context).pop(context);
  }

  //------------------------------------------------------------
  @override
  void dispose() {
    super.dispose();
    cityCodeController.dispose();
    cityNameController.dispose();
  }
}
