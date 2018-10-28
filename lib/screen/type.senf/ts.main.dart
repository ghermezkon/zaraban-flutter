import 'package:flutter/material.dart';
import 'package:zaraban/provider/bloc.provider.dart';
import 'package:zaraban/screen/type.senf/ts.input.dart';
import 'package:zaraban/screen/type.senf/type.senf.bloc.dart';
import 'package:zaraban/util/const.text.dart';
import 'package:zaraban/util/global.widget.dart';

//--------------------------------------------------------
class TypeSenfPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TypeSenfPageState();
}

//--------------------------------------------------------
class TypeSenfPageState extends State<TypeSenfPage> {
  //==========================================
  var bloc;
  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<TypeSenfBloc>(context);
  }

  //==========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MainTsHeaderLBL),
        centerTitle: true,
        elevation: 0.0,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ZBottomBarMenu(
                'ts', TsListLBL, () => bloc.bottomMenuClick(context)),
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
                  ZRectangleMenu('ts', MainTsTitle, MainTsSubTitle),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                child: TypeSenfInput(
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
