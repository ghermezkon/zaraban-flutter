import 'package:flutter/material.dart';
import 'package:zaraban/util/global.theme.dart';

//--------------------------------------------------------------------------
class ZRectangleMenu extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  ZRectangleMenu(this.icon, this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 4,
              child: Card(
                margin: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: InkWell(
                        onTap: () {},
                        splashColor: Colors.pink,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Icon(
                                  zNewIcon(icon),
                                  size: 40.0,
                                ),
                              ),
                              Center(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.green[800],
                        child: Center(
                          child: Text(
                            subtitle,
                            style:
                                TextStyle(fontSize: 10.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            )
          ],
        ),
      ),
    );
  }
}

//------------------------------------------------------
class ZBottomBarMenu extends StatelessWidget {
  final String icon;
  final String title;
  final Function menuClick;
  ZBottomBarMenu(this.icon, this.title, this.menuClick);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.pink[200],
      onTap: () => menuClick(),
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              zNewIcon(icon),
              color: zIconColor(),
            ),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

Widget zListLeftSection() {
  return Container(
    child: Icon(
      Icons.arrow_back,
      color: Colors.blueGrey[700],
    ),
  );
}

Widget zListRightSection(String iconName) {
  return Container(
    width: 50.0,
    decoration: BoxDecoration(
      border: Border(
        left: BorderSide(
          color: zListBorderColor(),
        ),
      ),
    ),
    child: Icon(
      zNewIcon(iconName),
      color: zIconColor(600),
    ),
  );
}
