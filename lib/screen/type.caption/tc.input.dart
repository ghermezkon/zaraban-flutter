import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zaraban/bloc/type.caption.bloc.dart';
import 'package:zaraban/util/const.text.dart';
import 'package:zaraban/util/dialog.widget.dart';
import 'package:zaraban/util/global.theme.dart';

class TypeCaptionInput extends StatefulWidget {
  final TypeCaptionBloc bloc;
  TypeCaptionInput({Key key, this.bloc}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _TypeCaptionInputState();
}

class _TypeCaptionInputState extends State<TypeCaptionInput> {
  //------------------------------------------------------
  final tcCodeController = TextEditingController();
  final tcNameController = TextEditingController();
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
                  stream: widget.bloc.streamTcCode,
                  builder: (context, snapshot) {
                    tcCodeController.text = snapshot.data;
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        controller: tcCodeController,
                        textAlign: TextAlign.center,
                        onFieldSubmitted: widget.bloc.sinkTcCode,
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
                          hintText: TcCodeHINT,
                          labelText: TcCodeLBL,
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
                    stream: widget.bloc.streamTcName,
                    builder: (context, snapshot) {
                      tcNameController.text = snapshot.data;
                      return TextFormField(
                        controller: tcNameController,
                        textAlign: TextAlign.right,
                        onFieldSubmitted: widget.bloc.sinkTcName,
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
                          hintText: TcNameHINT,
                          labelText: TcNameLBL,
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
  _showAlert(BuildContext context, TypeCaptionBloc bloc) {
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
  clearForm(TypeCaptionBloc bloc, bool alert) {
    bloc.clearTextField();
    tcCodeController.clear();
    tcNameController.clear();
    if(alert)
      Navigator.of(context).pop(context);
  }

  //------------------------------------------------------------
  @override
  void dispose() {
    super.dispose();
    tcCodeController.dispose();
    tcNameController.dispose();
  }
}
