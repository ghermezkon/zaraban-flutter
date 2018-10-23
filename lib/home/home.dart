import 'package:flutter/material.dart';
import 'package:zaraban/util/global.theme.dart';

class HomePage extends StatelessWidget {
  Widget homeItem(BuildContext context, String icon, String caption) {
    return GestureDetector(
      onTap: () {
        final snackbar = SnackBar(content: Text('در حال آماده سازی', textAlign: TextAlign.center,));
        Scaffold.of(context).showSnackBar(snackbar);
      },
      child: Container(
        height: 120.0,
        child: Stack(
          children: <Widget>[
            Container(
                child: Center(
              child: Container(
                padding: EdgeInsets.only(top: 95.0),
                child: Text(caption, style: homeItemFont(context)),
              ),
            )),
            Positioned(
              child: Icon(
                zNewIcon(icon),
                size: 35.0,
                color: Colors.blueGrey[900],
              ),
              left: 0.0,
              right: 0.0,
              top: 0.0,
              bottom: 0.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Container(
                      height: 110.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/logo.png'),
                              fit: BoxFit.scaleDown)),
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                homeItem(context, 'dentalDoctor', 'دندانپزشکی'),
                homeItem(context, 'eyeDoctor', 'چشم پزشکی'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                homeItem(context, 'globalDoctor', 'پزشک عمومی'),
                homeItem(context, 'phiziuoDoctor', 'فیزیوتراپی'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                homeItem(context, 'beautyDoctor', 'پزشک پوست و زیبایی'),
                homeItem(context, 'beautySalon', 'سالن زیبایی'),
              ],
            )
          ],
        )
      ],
    );
  }
}
