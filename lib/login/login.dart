import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'login_page.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late SharedPreferences sharedPreferences;
  final plugin = FacebookLogin(debug: true);

  @override
  void initState() {
    super.initState();
    loginStatus();
  }

  loginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => LoginPage(plugin: plugin)),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Authentication System",
              style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                sharedPreferences.clear();
                sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            LoginPage(plugin: plugin)),
                    (Route<dynamic> route) => false);
              },
              child: Row(
                children: [Icon(Icons.open_in_new), Text('Logout')],
              ),
            )
          ],
        ),
        body: Center(
          child: Text(
            "${sharedPreferences.getString("username")}",
            style: TextStyle(fontSize: 20, color: Colors.green),
          ),
        ));
  }
}
