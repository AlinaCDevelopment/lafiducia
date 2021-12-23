import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:la_fiducia/login/register_page.dart';
import 'package:la_fiducia/pages/menu.dart';
import 'package:la_fiducia/login/auth.dart';
import 'package:la_fiducia/pages/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_fiducia/widgets/colors.dart';
import 'package:la_fiducia/widgets/socialButtons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:la_fiducia/login/sharedPref.dart';
import 'login.dart';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:la_fiducia/pages/checkOut2.dart';
import 'package:la_fiducia/pages/menu.dart';

class PropousDeNous extends StatefulWidget {
  @override
  _PropousDeNousState createState() => _PropousDeNousState();
}

class _PropousDeNousState extends State<PropousDeNous> {
  @override
  void initState() {
    super.initState();
  }

  bool agree = false;

  final TextEditingController nomController = new TextEditingController();
  final TextEditingController mailController = new TextEditingController();
  final TextEditingController mensagemController = new TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.only(left: 10),
              child: IconButton(
                icon: Image.asset('assets/next.png'),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => Menu()),
                      (Route<dynamic> route) => false);
                },
              ),
            );
          },
        ),

        titleSpacing: 0,
        leadingWidth: 60,
        centerTitle: true,
        title: Text(' À PROPOS DE NOUS',
            style: TextStyle(
              color: Color.fromRGBO(45, 61, 75, 1),
              fontFamily: 'Poppins',
              package: 'awesome_package',
              fontSize: 20,
              fontWeight: FontWeight.w500,
            )),
        automaticallyImplyLeading:
            false, //optional: removes the default back arrow
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/nous.jpg'),
                fit: BoxFit.fitHeight,
              ),
              shape: BoxShape.rectangle,
            ),
          ),
          Center(
            child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Text(
                    'Carlos et Teresa vous souhaitent la bienvenue à “La Fiducia”, terme qui signifie confiance en français. La confiance, c’est ce que nous souhaitons instaurer entre vous et nous.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(45, 61, 75, 1),
                      fontFamily: 'Poppins',
                      package: 'awesome_package',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ))),
          ),
        ],
      ),
    );
  }
}
