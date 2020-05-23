import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guitar_tabs/add_tab.dart';
import 'package:guitar_tabs/main.dart';
import 'package:guitar_tabs/my_tabs.dart';
import 'package:guitar_tabs/tab.dart';
import 'package:guitar_tabs/terms.dart';
import 'package:http/http.dart' as http;
import 'package:guitar_tabs/strings.dart' as strings;
import 'package:shared_preferences/shared_preferences.dart';
import 'colors.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<List<Tab>> _futureTabsList;
  List<Tab> _tabsList;
  int _quantity;
  @override
  void initState() {
    super.initState();
    _futureTabsList = fetchTabs();
  }

  Future<List<Tab>> fetchTabs() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = sharedPreferences.getString('token');
      List<Tab> tabs = List<Tab>();
      var response = await http.get(
        "${strings.url}api/tabs/",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (response.statusCode == 200) {
        String jsonDataString = response.body.toString();
        var jsonData = json.decode(jsonDataString);
        for (var c in jsonData["results"]) {
          Tab tab = Tab(c["song"], c["band"], c["user"]["nick"], c["id"]);
          tabs.add(tab);
        }
        setState(() {
          _tabsList = tabs;
          _quantity = tabs.length;
        });
        print("Quantity:" + _quantity.toString());
        return tabs;
      }
      return tabs;
    } catch (e) {
      return List<Tab>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Tabs",
          style: TextStyle(fontWeight: FontWeight.w100),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => (AddTabPage()),
                ),
              );
            },
          )
        ],
      ),
      bottomNavigationBar: Stack(
        children: [
          new Container(
            height: 30.0,
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
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder(
            future: _futureTabsList,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount:
                        _tabsList.length == null ? 1 : _tabsList.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        // return the header
                        return TabWidget("Band", "Song", "User", Colors.white,
                            kPrimaryColor);
                      }
                      index -= 1;
                      return Center(
                        child: Card(
                          child: ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      snapshot.data[index].song,
                                      style: TextStyle(fontSize: 11),
                                      textAlign: TextAlign.center,
                                    )),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      snapshot.data[index].band,
                                      style: TextStyle(fontSize: 11),
                                      textAlign: TextAlign.center,
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      snapshot.data[index].user,
                                      style: TextStyle(fontSize: 11),
                                      textAlign: TextAlign.center,
                                    ))
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TabPage(tab: snapshot.data[index])),
                              );
                            },
                          ),
                        ),
                      );
                    });
              } else {
                return Container(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            }),
      ),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          drawerHeader(),
          ListTile(
            leading: (Icon(Icons.add)),
            title: Text("Add new tab"),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => (AddTabPage()),
                ),
              )
            },
          ),
          ListTile(
            leading: (Icon(Icons.line_style)),
            title: Text("My Tabs"),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => MyTabsPage(),
                ),
              )
            },
          ),
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
          ListTile(
            leading: Icon(Icons.arrow_back_ios),
            title: Text("Log out"),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        //uses the custom alert dialog
                        title: Text("Are you sure you want to log out?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w200)),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RaisedButton(
                              color: kPrimaryColor,
                              child: Text(
                                'Tak',
                              ),
                              textColor: Colors.white,
                              onPressed: () async {
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                sharedPreferences =
                                    await SharedPreferences.getInstance();
                                sharedPreferences.setString("token", null);
                                sharedPreferences.setString("refresh", null);
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            MyHomePage()),
                                    (Route<dynamic> route) => false);
                              },
                            ),
                            RaisedButton(
                              textColor: Colors.black,
                              color: Colors.red,
                              child: Text(
                                'Nie',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        ));
                  });
            },
          ),
        ],
      )),
    );
  }
}

class TabWidget extends StatelessWidget {
  final String band;
  final String song;
  final String user;
  final Color text_color;
  final Color bg_color;

  TabWidget(this.band, this.song, this.user, this.text_color, this.bg_color);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            color: bg_color,
            child: Row(
              children: [
                Expanded(
                    flex: 11,
                    child: Text(
                      this.song,
                      style: TextStyle(fontSize: 17, color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 8,
                    child: Text(
                      this.band,
                      style: TextStyle(fontSize: 17, color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 6,
                    child: Text(
                      this.user,
                      style: TextStyle(fontSize: 17, color: Colors.white),
                      textAlign: TextAlign.center,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Tab {
  final String song;
  final String band;
  final String user;
  final int id;

  Tab(this.song, this.band, this.user, this.id);
}
