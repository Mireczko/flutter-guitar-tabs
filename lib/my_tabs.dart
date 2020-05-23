import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:guitar_tabs/add_tab.dart';
import 'package:guitar_tabs/tab.dart';
import 'package:guitar_tabs/dashboard.dart' as dashboard;
import 'package:http/http.dart' as http;
import 'package:guitar_tabs/strings.dart' as strings;
import 'package:shared_preferences/shared_preferences.dart';
import 'colors.dart';

class MyTabsPage extends StatefulWidget {
  @override
  _MyTabsPageState createState() => _MyTabsPageState();
}

class _MyTabsPageState extends State<MyTabsPage> {
  Future<List<dashboard.Tab>> _futureTabsList;
  List<dashboard.Tab> _tabsList;
  int _quantity;
  @override
  void initState() {
    super.initState();
    _futureTabsList = fetchTabs();
  }

  deleteTab(id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    var response = await http.delete(
      "${strings.url}api/tabs/${id}/",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    var a =2;
  }

  Future<List<dashboard.Tab>> fetchTabs() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = sharedPreferences.getString('token');
      List<dashboard.Tab> tabs = List<dashboard.Tab>();
      var response = await http.get(
        "${strings.url}api/my_tabs/",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (response.statusCode == 200) {
        String jsonDataString = response.body.toString();
        var jsonData = json.decode(jsonDataString);
        for (var c in jsonData["results"]) {
          dashboard.Tab tab =
              dashboard.Tab(c["song"], c["band"], c["user"]["nick"], c["id"]);
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
      return List<dashboard.Tab>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Tabs",
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
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () => {
                              deleteTab(snapshot.data[index].id)
                            },
                          ),
                        ],
                        child: Center(
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
