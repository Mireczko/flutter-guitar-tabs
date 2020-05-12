import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guitar_tabs/colors.dart';
import 'package:guitar_tabs/dashboard.dart';
import 'package:guitar_tabs/register.dart';
import 'package:guitar_tabs/terms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guitar tabs',
      theme: buildThemeData(),
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder(
            future: checkLoginStatus(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                return snapshot.data
                    ? DashboardPage()
                    : MyHomePage(title: "Guitar tabs");
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        '/login': (BuildContext context) => LoginPage(),
        '/register': (BuildContext context) => RegisterPage(),
        '/dashboard': (BuildContext context) => DashboardPage(),
      },
    );
  }
}

Future<bool> checkLoginStatus() async {
  print("weszlo");
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  try {
    Map verify = {
      "token": sharedPreferences.getString("token"),
    };
    Map refresh = {
      "refresh": sharedPreferences.getString("refresh"),
    };
    var strings;
    var verify_response = await http.post(
      "${strings.url}api/token/verify/",
      body: JsonEncoder().convert(verify),
      headers: {"Content-Type": "application/json"},
    );
    print(verify_response.statusCode);
    if (verify_response.statusCode != 200) {
      var refresh_response = await http.post(
        "${strings.url}api/token/refresh/",
        body: JsonEncoder().convert(refresh),
        headers: {"Content-Type": "application/json"},
      );
      var jsonData = json.decode(refresh_response.body);
      if (refresh_response.statusCode == 200) {
        sharedPreferences.setString("token", jsonData['access']);
        return true;
      }
      if (sharedPreferences.getString("token") == null) {
        return false;
      }
    } else {
      return true;
    }
  } catch (e) {
    return false;
  }
  print("wyszlo");
}

ThemeData buildThemeData() {
  final baseTheme = ThemeData.light();
  return baseTheme.copyWith(
    primaryColor: kPrimaryColor,
    primaryColorDark: kPrimaryDark,
    primaryColorLight: kPrimaryLight,
    accentColor: kSecondaryColor,
  );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          widget.title,
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
        child: Center(
          child: Container(
            padding: EdgeInsets.all(30),
            width: 700,
            child: Column(
              children: <Widget>[
                Text(
                  "Welcome to Guitar Tabs!",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "The place where you can upload and download guitar tabs for your favorite songs. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w100, height: 1.5),
                  textAlign: TextAlign.justify,
                ),
                accountContainer(data, context),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          drawerHeader(),
          ListTile(
            leading: (Icon(Icons.lock_open)),
            title: Text("Log in"),
            onTap: () => {},
          ),
          ListTile(
            leading: (Icon(Icons.person_add)),
            title: Text("Register"),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => RegisterPage(),
                ),
              )
            },
          ),
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

DrawerHeader drawerHeader() {
  return DrawerHeader(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "GuitarTabs",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            )
          ],
        )
      ],
    ),
    decoration: BoxDecoration(color: kPrimaryColor),
  );
}

Container accountContainer(data, context) {
  bool isScreenWide = data.size.width >= 800;
  return Container(
    padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
    child: Center(
      child: Wrap(
        direction: isScreenWide ? Axis.horizontal : Axis.vertical,
        alignment: WrapAlignment.spaceBetween,
        spacing: 10.0,
        children: <Widget>[
          Container(
            width: 200,
            child: Column(
              children: <Widget>[
                Icon(Icons.lock_open, size: 100, color: kPrimaryColor),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Log in",
                  style: TextStyle(fontSize: 40),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "If you have already registered in our system, log in to add new guitar tabs and browse existing ones",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text("Click to log in"),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: 80,
          ),
          Container(
            width: 200,
            child: Column(
              children: <Widget>[
                Icon(Icons.person_add, size: 100, color: kPrimaryColor),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Register",
                  style: TextStyle(fontSize: 40),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "If you haven't already registered, please do so by filling the form.\n",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text("Click to register"),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => RegisterPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

void dialog(String text1, String text2, Color button, BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //uses the custom alert dialog
          title: Text(text1, textAlign: TextAlign.center),
          content: Text(
            text2,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            RaisedButton(
              color: button,
              child: Text(
                'Ok',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}
