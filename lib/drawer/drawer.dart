import 'package:flutter/material.dart';
import 'package:zaraban/util/global.theme.dart';

class DrawerItem {
  final String itemName;
  final IconData itemIcon;
  final String routeName;
  DrawerItem({this.itemName, this.itemIcon, this.routeName});
}

//-----------------------------------------------------------------------
class MyDrawer extends StatelessWidget {
  final List<DrawerItem> itemList = [
    DrawerItem(
        itemName: 'تعریف استان',
        itemIcon: zNewIcon('ostan'),
        routeName: '/ostan'),
    DrawerItem(
        itemName: 'تعریف شهر', itemIcon: zNewIcon('city'), routeName: '/city'),
    DrawerItem(
        itemName: 'تعریف انواع تخصص/عنوان ',
        itemIcon: zNewIcon('tc'),
        routeName: '/tc'),
    DrawerItem(
        itemName: 'تعریف انواع صنف/پزشک/شغل',
        itemIcon: zNewIcon('ts'),
        routeName: '/ts'),
    DrawerItem(itemName: 'تعریف پزشک', itemIcon: zNewIcon('doctor')),
    DrawerItem(itemName: 'تعاریف اولیه مطب', itemIcon: zNewIcon('matab')),
    DrawerItem(itemName: 'تعریف تکمیلی مطب', itemIcon: zNewIcon('matabMore')),
  ];
  @override
  Widget build(BuildContext context) {
    //------------------------------------------------------------------
    final List<Widget> drawerOptions = [];
    for (var i = 0; i < itemList.length; i++) {
      drawerOptions.add(
        ListTile(
          title: Text(
            itemList[i].itemName,
            textDirection: TextDirection.rtl,
            style: drawerItem(context),
          ),
          trailing: Icon(
            itemList[i].itemIcon,
            size: 27.0,
            color: Colors.black54,
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, itemList[i].routeName);
          },
        ),
      );
    }
    drawerOptions.add(
      Divider(
        color: Colors.black12,
      ),
    );
    //------------------------------------------------------------------
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 150.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                      image: AssetImage('assets/images/drawerBG.jpg'),
                      fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 65.0,
                right: 75.0,
                child: Icon(
                  zNewIcon('medical'),
                  color: Colors.cyanAccent[700],
                  size: 40.0,
                ),
              )
            ],
          ),
          Column(
            children: drawerOptions,
          )
        ],
      ),
    );
  }
}
