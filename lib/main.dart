import 'package:flutter/material.dart';
import 'package:guitar_tabs/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guitar tabs',
      theme: buildThemeData(),
      home: MyHomePage(title: 'Guitar tabs'),
    );
  }
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
        child: Container(
          padding: EdgeInsets.all(30),
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  "Welcome to Guitar Tabs!",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w100,
                  ),
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
            leading: Icon(Icons.note_add),
            title: Text("Add new tab"),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.queue_music),
            title: Text("Browse tabs"),
            onTap: () => {},
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
              "Jakub Walawender",
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
    padding: EdgeInsets.all(50),
    child: Center(
      child: Wrap(
        direction: isScreenWide ? Axis.horizontal : Axis.vertical,
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
                  onPressed: () {},
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
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
