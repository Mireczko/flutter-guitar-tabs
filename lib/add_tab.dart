import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:guitar_tabs/forms.dart';
import 'package:guitar_tabs/strings.dart' as strings;
import 'package:shared_preferences/shared_preferences.dart';

import 'colors.dart';

class AddTabPage extends StatefulWidget {
  @override
  _AddTabPageState createState() => _AddTabPageState();
}

class _AddTabPageState extends State<AddTabPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File _file;
  String _file_location = "";
  TextEditingController tabTextController = new TextEditingController();
  TextEditingController tabBandController = new TextEditingController();
  TextEditingController tabSongController = new TextEditingController();
  TextEditingController tabLinkController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Add new tab",
            style: TextStyle(fontWeight: FontWeight.w100),
          ),
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
        body: SingleChildScrollView(
          child: Column(
            children: [formSection(), buttonSection()],
          ),
        ));
  }

  Container formSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15.0),
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              tabTextField("Tab:", tabTextController),
              SizedBox(height: 20.0),
              tabField("Band", tabBandController),
              SizedBox(height: 20.0),
              tabField("Song", tabSongController),
              SizedBox(height: 20.0),
              tabField("Link", tabLinkController),
              SizedBox(height: 20.0),

              Center(
                child: RaisedButton(
                  child: Text("Guitar pro file"),
                  onPressed: () async {
                    File file = await FilePicker.getFile();
                    setState(() {
                      _file = file;
                      _file_location = file.path;
                    });
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                child:
                    Text(_file_location, style: TextStyle(color: Colors.black)),
              ),

              SizedBox(
                height: 25.0,
              ),
              // buttonSection(),
            ],
          )),
    );
  }

  Container buttonSection() {
    return Container(
        margin: EdgeInsets.only(top: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            Center(
              child: SizedBox(
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      addTab();
                      Navigator.of(context).pop();
                    }
                  },
                  color: kPrimaryColor,
                  child: Text(
                    "Add",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  addTab() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    Map<String, String> headers = {"Authorization": "Bearer $token", "Accept": "application/json",};
    var request = new http.MultipartRequest(
        "POST", Uri.parse("${strings.url}api/tabs/new/"));
    request.headers.addAll(headers);
    request.fields["tab_text"] = tabTextController.text;
    request.fields["song"] = tabSongController.text;
    request.fields["link"] = tabLinkController.text;
    request.fields["band"] = tabBandController.text;
    var file = await http.MultipartFile.fromPath("tab_file", _file.path);
    request.files.add(file);
    request.send().then((response) async {
      if (response.statusCode == 200)
        print(response.stream.bytesToString());
      else if (response.statusCode == 400) {
        print("DZIOOO");
      } else
        print(response.stream.bytesToString());
    });
  }
}

// var responseBody = jsonDecode(response.body);
// print(response.statusCode);
// if (response.statusCode == 200) {
//   setState(() {
//     _isLoading = false;
//     jsonData = json.decode(response.body);
//     print(jsonData['access']);
//     sharedPreferences.setString("token", jsonData['access']);
//     sharedPreferences.setString("refresh", jsonData['refresh']);
//     print(sharedPreferences.getString('token'));
//   });
//   Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(builder: (BuildContext context) => DashboardPage()),
//       (Route<dynamic> route) => false);
// } else if (response.statusCode == 401) {
//   setState(() {
//     _isLoading = false;
//     passwordController.text = "";
//     emailController.text = "";
//   });
//   dialog(
//       "Nie udało się zalogować!",
//       "Podano niewłaście dane.",
//       Colors.red[700],
//       context);
// } else {
//   setState(() {
//     _isLoading = false;
//     passwordController.text = "";
//     emailController.text = "";
//   });
//   dialog("Nie udało się zalogować!", "Coś poszło nie tak...",
//       Colors.red[700], context);
//   }
// }
// }
