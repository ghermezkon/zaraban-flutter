import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zaraban/bloc/application.bloc.dart';
import 'package:zaraban/drawer/drawer.dart';
import 'package:zaraban/home/home.dart';
import 'package:zaraban/provider/bloc.provider.dart';
import 'package:zaraban/screen/city/city.bloc.dart';
import 'package:zaraban/screen/city/city.main.dart';
import 'package:zaraban/screen/ostan/ostan.bloc.dart';
import 'package:zaraban/screen/ostan/ostan.main.dart';
import 'package:zaraban/screen/type.caption/tc.main.dart';
import 'package:zaraban/screen/type.caption/type.caption.bloc.dart';
import 'package:zaraban/screen/type.senf/ts.main.dart';
import 'package:zaraban/screen/type.senf/type.senf.bloc.dart';
import 'package:zaraban/util/global.theme.dart';

void main() async {
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => StartupPage(),
        '/ostan': (context) => BlocProvider<OstanBloc>(
              bloc: OstanBloc(),
              child: OstanPage(),
            ),
        '/city': (context) => BlocProvider<CityBloc>(
              bloc: CityBloc(),
              child: CityPage(),
            ),
        '/tc': (context) => BlocProvider<TypeCaptionBloc>(
              bloc: TypeCaptionBloc(),
              child: TypeCaptionPage(),
            ),
        '/ts': (context) => BlocProvider<TypeSenfBloc>(
              bloc: TypeSenfBloc(),
              child: TypeSenfPage(),
            ),
      },
      theme: ThemeData(
          fontFamily: 'IranSans',
          primaryColor: Colors.lightBlue[600],
          bottomAppBarColor: Colors.white,
          buttonColor: Colors.pink[500]),
    );
  }
}

//----------------------------------
class StartupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'نوبت دهی ضربان',
          style: titleFont(context),
        ),
      ),
      body: HomePage(),
      endDrawer: MyDrawer(),
    );
  }
}
