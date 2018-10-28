import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zaraban/screen/ostan/ostan.bloc.dart';
import 'package:zaraban/util/const.text.dart';
import 'package:zaraban/util/dialog.widget.dart';
import 'package:zaraban/util/global.theme.dart';

class OstanInput extends StatefulWidget {
  final OstanBloc bloc;
  OstanInput({Key key, this.bloc}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _OstanInputState();
}

class _OstanInputState extends State<OstanInput> {
  //------------------------------------------------------
  final ostanCodeController = TextEditingController();
  final ostanNameController = TextEditingController();
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
                  stream: widget.bloc.streamOstanCode,
                  builder: (context, snapshot) {
                    ostanCodeController.text = snapshot.data;
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        controller: ostanCodeController,
                        textAlign: TextAlign.center,
                        onFieldSubmitted: widget.bloc.sinkOstanCode,
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
                          hintText: OstanCodeHINT,
                          labelText: OstanCodeLBL,
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
                    stream: widget.bloc.streamOstanName,
                    builder: (context, snapshot) {
                      ostanNameController.text = snapshot.data;
                      return TextFormField(
                        controller: ostanNameController,
                        textAlign: TextAlign.right,
                        onFieldSubmitted: widget.bloc.sinkOstanName,
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
                          hintText: OstanNameHINT,
                          labelText: OstanNameLBL,
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
  _showAlert(BuildContext context, OstanBloc bloc) {
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
  clearForm(OstanBloc bloc, bool alert) {
    bloc.clearTextField();
    ostanCodeController.clear();
    ostanNameController.clear();
    if(alert)
      Navigator.of(context).pop(context);
  }

  //------------------------------------------------------------
  @override
  void dispose() {
    super.dispose();
    ostanCodeController.dispose();
    ostanNameController.dispose();
  }
}
