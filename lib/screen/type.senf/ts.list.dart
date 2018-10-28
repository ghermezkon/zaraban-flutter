import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zaraban/entity/TypeSenfEntity.dart';
import 'package:zaraban/util/const.text.dart';
import 'package:zaraban/util/global.theme.dart';
import 'package:zaraban/util/global.widget.dart';

class TypeSenfListWidget extends StatelessWidget {
  //--------------------------------------------------
  /// List data
  final Stream<dynamic> streamList;

  /// Row Click for List
  final Function(dynamic data, int index) rowClick;

  /// Search Function for Filter List
  final Function(String query) searchFunc;
  //--------------------------------------------------
  TypeSenfListWidget(this.streamList, this.rowClick, this.searchFunc);
  //--------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                onChanged: searchFunc,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    labelText: SearchTsLBL),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: streamList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  splashColor: Colors.pink,
                  onTap: () => rowClick(snapshot.data[index], index),
                  child: zListTile(snapshot.data[index]),
                );
              },
            );
          }
        },
      ),
    );
  }
}

Widget zListTile(TypeSenfEntity snapshot) {
  return Container(
    height: 55.0,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: zListBorderColor(),
        ),
      ),
    ),
    child: Row(
      textDirection: TextDirection.rtl,
      children: <Widget>[
        zListRightSection('tc'),
        zCenterSection(snapshot),
        zListLeftSection(),
      ],
    ),
  );
}

Widget zCenterSection(TypeSenfEntity snapshot) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.only(right: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            '${snapshot.tsName}',
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
            '$TsCodeLBL: ${snapshot.tsCode}',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}
