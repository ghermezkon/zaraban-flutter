import 'dart:async';

import 'package:flutter/material.dart';

class ZDialog extends StatelessWidget {
  //------------------------------------------------
  final Stream<dynamic> stream;
  final Function clearForm;
  ZDialog(this.stream, this.clearForm);
  //------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) => snapshot.data != ''
          ? Dialog(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.lightGreen,
                            size: 34.0,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text('${snapshot.data}'),
                        ],
                      ),
                    ),
                  ),
                  FlatButton(
                    child: Text('تائید'),
                    onPressed: () => clearForm(),
                  )
                ],
              ),
            )
          : AlertDialog(
              actions: <Widget>[
                Center(
                  child: FlatButton(
                    child: Container(),
                    onPressed: () { Navigator.of(context).pop(); },
                  ),
                ),
              ],
              content: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.lightGreen,
                      size: 34.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text('در حال دریافت اطلاعات...'),
                  ],
                ),
              ),
            ),
    );
  }
}
