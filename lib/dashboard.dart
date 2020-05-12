import 'package:flutter/material.dart';
import 'package:guitar_tabs/main.dart';
import 'package:guitar_tabs/terms.dart';

import 'colors.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          "Tabs",
          style: TextStyle(fontWeight: FontWeight.w100),
        ),
      ),
      bottomNavigationBar: Stack(
        children: [
          new Container(
            height: 75.0,
            color: kPrimaryColor,
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 0.0,
            bottom: 0.0,
            child: Center(
              child: Container(
                child: Text("Guitar Tabs© 2020",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(child: Text("JOŁ")),
      ),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          drawerHeader(),
          Center(child: Divider(color: Colors.black)),
          ListTile(
            leading: (Icon(Icons.event_note)),
            title: Text("Terms and conditions"),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => TermsPage(),
                ),
              )
            },
          ),
        ],
      )),
    );
  }
}

class TabWidget extends StatelessWidget {
  final String day;
  final String month;
  final String status;
  final String points;
  final String code;
  final Color color;
  CouponWidget(
      this.day, this.month, this.status, this.points, this.code, this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.grey[100],
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          width: 50,
                          height: 35,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              day,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          width: 50,
                          height: 35,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              month,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w200),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    code,
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w300),
                  ),
                ),
                Container(
                  child: Text(
                    status,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: color, fontWeight: FontWeight.w200),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  child: Text(
                    points,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}