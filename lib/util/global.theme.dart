import 'package:flutter/material.dart';

//------------------------------------------------------------
TextStyle titleFont(BuildContext context) => Theme.of(context)
    .textTheme
    .title
    .apply(fontFamily: 'IranSansBold', color: Colors.white);

//------------------------------------------------------------
TextStyle homeItemFont(BuildContext context) =>
    Theme.of(context).textTheme.caption.copyWith(
        fontFamily: 'IranSansBold',
        color: Colors.blueGrey[900],
        fontSize: 16.0);

//------------------------------------------------------------
TextStyle drawerItem(BuildContext context) => Theme.of(context)
    .textTheme
    .caption
    .apply(fontFamily: 'IranSansBold', fontSizeDelta: 4.0);

//------------------------------------------------------------
IconData zNewIcon(String name) {
  int iconCode = 0;
  switch (name) {
    case 'ostan':
      iconCode = 0xe90a;
      break;
    case 'city':
      iconCode = 0xe909;
      break;
    case 'home':
      iconCode = 0x90d;
      break;
    case 'matab':
      iconCode = 0xe907;
      break;
    case 'matabMore':
      iconCode = 0xe908;
      break;
    case 'tc':
      iconCode = 0xe90b;
      break;
    case 'doctor':
      iconCode = 0xe90c;
      break;
    case 'ts':
      iconCode = 0xe90b;
      break;
    case 'eyeDoctor':
      iconCode = 0xe903;
      break;
    case 'dentalDoctor':
      iconCode = 0xe904;
      break;
    case 'phiziuoDoctor':
      iconCode = 0xe906;
      break;
    case 'beautyDoctor':
      iconCode = 0xe902;
      break;
    case 'globalDoctor':
      iconCode = 0xe905;
      break;
    case 'beautySalon':
      iconCode = 0xe901;
      break;
    case 'medical':
      iconCode = 0xe900;
      break;
  }
  return IconData(iconCode, fontFamily: 'svgicon');
}

Color zBorderColor() => Colors.blueGrey[100];

Color zListBorderColor() => Colors.grey[200];

Color zIconColor([int light = 200]) => Colors.lightBlue[light];

//------------------------------------------------------------
