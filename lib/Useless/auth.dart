/* import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:la_fiducia/login/login_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:la_fiducia/login/register_page.dart';
import 'package:la_fiducia/pages/menu.dart';
import 'package:la_fiducia/login/auth.dart';
import 'package:la_fiducia/pages/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:la_fiducia/widgets/colors.dart';
import 'package:la_fiducia/widgets/socialButtons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Google extends StatefulWidget {
  @override
  _GoogleState createState() => _GoogleState();
}

class _GoogleState extends State<Google> {
  final controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    print(controller.googleAccount.value);
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: Center(
            /*child: CustomWidgets.socialButtonRect(
                'Login with Google', googleColor, FontAwesomeIcons.googlePlusG,
                onTap: () {
          GoogleSignIn().signIn();
          print('I am google');
        })*/
            child: Obx(() {
          if (controller.googleAccount.value == null)
            return botaoGoogle();
          else
            return Avatar();
        })),
      ),
    );
  }

  Column Avatar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundImage: Image.network('').image,
          radius: 100,
        ),
        Text('Name'),
        Text('Email'),
      ],
    );
  }

  FloatingActionButton botaoGoogle() {
    return FloatingActionButton.extended(
      onPressed: () {
        controller.login();
      },
      icon: Image.asset(
        'assets/next.png',
        height: 32,
        width: 32,
      ),
      label: Text('sign in with google'),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    );
  }
}
 */
//TODO