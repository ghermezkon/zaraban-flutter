import 'package:flutter/material.dart';
import 'package:zaraban/bloc/ostan.bloc.dart';
import 'package:zaraban/provider/bloc.provider.dart';
import 'package:zaraban/screen/ostan/ostan.input.dart';
import 'package:zaraban/util/const.text.dart';
import 'package:zaraban/util/global.widget.dart';

//--------------------------------------------------------
class OstanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OstanPageState();
}

//--------------------------------------------------------
class OstanPageState extends State<OstanPage> {
  //==========================================
  var bloc;
  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<OstanBloc>(context);
  }
  //==========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MainOstanHeaderLBL),
        centerTitle: true,
        elevation: 0.0,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ZBottomBarMenu(
                'ostan', OstanListLBL, () => bloc.bottomMenuClick(context)),
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
                  ZRectangleMenu('ostan', MainOstanTitle, MainOstanSubTitle),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                child: OstanInput(
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
