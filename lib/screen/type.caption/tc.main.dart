import 'package:flutter/material.dart';
import 'package:zaraban/provider/bloc.provider.dart';
import 'package:zaraban/screen/type.caption/tc.input.dart';
import 'package:zaraban/screen/type.caption/type.caption.bloc.dart';
import 'package:zaraban/util/const.text.dart';
import 'package:zaraban/util/global.widget.dart';

//--------------------------------------------------------
class TypeCaptionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TypeCaptionPageState();
}

//--------------------------------------------------------
class TypeCaptionPageState extends State<TypeCaptionPage> {
  //==========================================
  var bloc;
  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<TypeCaptionBloc>(context);
  }

  //==========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MainTcHeaderLBL),
        centerTitle: true,
        elevation: 0.0,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ZBottomBarMenu(
                'tc', TcListLBL, () => bloc.bottomMenuClick(context)),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 160.0,
              decoration: BoxDecoration(
                color: Colors.lightBlue[600],
              ),
              child: Row(
                children: <Widget>[
                  ZRectangleMenu('tc', MainTcTitle, MainTcSubTitle),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                child: TypeCaptionInput(
                  bloc: bloc,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------
  @override
  void dispose() {
    super.dispose();
  }
}
