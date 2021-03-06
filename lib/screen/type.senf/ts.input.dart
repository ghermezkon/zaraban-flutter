import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zaraban/screen/type.senf/type.senf.bloc.dart';
import 'package:zaraban/util/const.text.dart';
import 'package:zaraban/util/dialog.widget.dart';
import 'package:zaraban/util/global.theme.dart';

class TypeSenfInput extends StatefulWidget {
  final TypeSenfBloc bloc;
  TypeSenfInput({Key key, this.bloc}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _TypeSenfInputState();
}

class _TypeSenfInputState extends State<TypeSenfInput> {
  //------------------------------------------------------
  final tsCodeController = TextEditingController();
  final tsNameController = TextEditingController();
  final tsIconController = TextEditingController();
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
                title: StreamBuilder(
                  stream: widget.bloc.streamTsCode,
                  builder: (context, snapshot) {
                    tsCodeController.text = snapshot.data;
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        controller: tsCodeController,
                        textAlign: TextAlign.center,
                        onFieldSubmitted: widget.bloc.sinkTsCode,
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
                          hintText: TsCodeHINT,
                          labelText: TsCodeLBL,
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
                    stream: widget.bloc.streamTsName,
                    builder: (context, snapshot) {
                      tsNameController.text = snapshot.data;
                      return TextFormField(
                        controller: tsNameController,
                        textAlign: TextAlign.right,
                        onFieldSubmitted: widget.bloc.sinkTsName,
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
                          hintText: TsNameHINT,
                          labelText: TsNameLBL,
                          errorText: snapshot.error,
                        ),
                      );
                    },
                  ),
                ),
              ),
              ListTile(
                title: Directionality(
                  textDirection: TextDirection.rtl,
                  child: StreamBuilder(
                    stream: widget.bloc.streamTsIcon,
                    builder: (context, snapshot) {
                      tsIconController.text = snapshot.data;
                      return TextFormField(
                        controller: tsIconController,
                        textAlign: TextAlign.center,
                        onFieldSubmitted: widget.bloc.sinkTsIcon,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.link,
                            color: zIconColor(),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: zBorderColor(),
                            ),
                          ),
                          hintText: TsIconHINT,
                          labelText: TsIconLBL,
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
  _showAlert(BuildContext context, TypeSenfBloc bloc) {
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
  clearForm(TypeSenfBloc bloc, bool alert) {
    bloc.clearTextField();
    tsCodeController.clear();
    tsNameController.clear();
    tsIconController.clear();
    if (alert) Navigator.of(context).pop(context);
  }

  //------------------------------------------------------------
  @override
  void dispose() {
    super.dispose();
    tsCodeController.dispose();
    tsNameController.dispose();
    tsIconController.dispose();
  }
}
