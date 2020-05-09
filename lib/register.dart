import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guitar_tabs/colors.dart';
import 'package:guitar_tabs/forms.dart';
import 'package:guitar_tabs/login.dart';
import 'package:guitar_tabs/main.dart';
import 'package:guitar_tabs/strings.dart' as strings;
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  TextEditingController emailController = new TextEditingController();
  TextEditingController nickController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register",
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
                        "Register",
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
              nickField("Nick", nickController),
              SizedBox(height: 20.0),
              passwordField(
                  "Password", confirmPasswordController, passwordController),
              SizedBox(height: 20.0),
              confirmPasswordField("Repeat password", confirmPasswordController,
                  passwordController),
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
                      registerUser(emailController.text,
                          passwordController.text, nickController.text);
                    }
                  },
                  color: kPrimaryColor,
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Already registered?"),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()),
                    );
                  },
                  child: Text(
                    "Log in",
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  registerUser(String email, password, nick) async {
    Map data = {
      "email": email,
      "nick": nick,
      "password": password,
    };

    var response = await http.post(
      "${strings.url}api/register/",
      body: JsonEncoder().convert(data),
      headers: {
        "Content-Type": "application/json",
      },
    );

    var responseBody = jsonDecode(response.body);
    print(response.statusCode);
    if (response.statusCode == 201) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
      dialog(
          "You have been registered!",
          "Check you mailbox and confirm e-mail address.",
          kPrimaryColor,
          context);
    } else if (response.statusCode == 400) {
      setState(() {
        _isLoading = false;
        passwordController.text = "";
        confirmPasswordController.text = "";
        emailController.text = "";
      });
      dialog(
          "Nie udało się!",
          "Podany adres email istnieje w naszej bazie danych\nUżyj innego",
          Colors.red[700],
          context);
    } else {
      setState(() {
        _isLoading = false;
        passwordController.text = "";
        confirmPasswordController.text = "";
        emailController.text = "";
      });
      dialog("Nie udało się zarejestrować!", "Coś poszło nie tak...",
          Colors.red[700], context);
    }
  }
}
