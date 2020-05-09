import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guitar_tabs/colors.dart';
import 'package:guitar_tabs/dashboard.dart';
import 'package:guitar_tabs/forms.dart';
import 'package:guitar_tabs/main.dart';
import 'package:guitar_tabs/register.dart';
import 'package:guitar_tabs/strings.dart' as strings;
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Log in",
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
      body: _isLoading
          ? Container(child: (Center(child: CircularProgressIndicator())))
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(30),
                  width: 700,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Log in",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      formSection(),
                      buttonSection(),
                    ],
                  ),
                ),
              ),
            ),
    );
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
              emailField("Email", emailController),
              SizedBox(height: 20.0),
              singePasswordField("Password", passwordController),
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
                      signIn(emailController.text, passwordController.text);
                    }
                  },
                  color: kPrimaryColor,
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Haven't registered yet?"),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context) => RegisterPage()),
                    );
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  signIn(String email, password) async {
    Map data = {
      "email": email,
      "password": password,
    };

    var response = await http.post(
      "${strings.url}api/login/",
      body: JsonEncoder().convert(data),
      headers: {
        "Content-Type": "application/json",
      },
    );
    var responseBody = jsonDecode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => dashboardPage()),
          (Route<dynamic> route) => false);
    } else if (response.statusCode == 401) {
      setState(() {
        _isLoading = false;
        passwordController.text = "";
        emailController.text = "";
      });
      dialog(
          "Nie udało się zalogować!",
          "Podany adres email istnieje w naszej bazie danych\nUżyj innego",
          Colors.red[700],
          context);
    } else {
      setState(() {
        _isLoading = false;
        passwordController.text = "";
        emailController.text = "";
      });
      dialog("Nie udało się zalogować!", "Coś poszło nie tak...",
          Colors.red[700], context);
    }
  }
}
