import 'package:flutter/material.dart';
import 'package:zaraban/bloc/city.bloc.dart';
import 'package:zaraban/provider/bloc.provider.dart';
import 'package:zaraban/screen/city/city.input.dart';
import 'package:zaraban/util/const.text.dart';
import 'package:zaraban/util/global.widget.dart';

//--------------------------------------------------------
class CityPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CityPageState();
}

//--------------------------------------------------------
class CityPageState extends State<CityPage> {
  @override
  Widget build(BuildContext context) {
    //-------------------------------------------------------
    final bloc = BlocProvider.of<CityBloc>(context);
    //-------------------------------------------------------
    return Scaffold(
      appBar: AppBar(
        title: Text(MainCityHeaderLBL),
        centerTitle: true,
        elevation: 0.0,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ZBottomBarMenu(
                'city', CityListLBL, () => bloc.bottomMenuClick(context)),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue[600],
                ),
                child: Row(
                  children: <Widget>[
                    ZRectangleMenu('city', MainCityTitle, MainCitySubTitle),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                child: CityInput(
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
