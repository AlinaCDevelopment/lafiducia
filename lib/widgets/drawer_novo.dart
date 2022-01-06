import 'package:carousel_slider/carousel_options.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:la_fiducia/util/customSwitch.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:la_fiducia/pages/constants.dart';
import 'package:la_fiducia/login/login_page.dart';
import 'package:la_fiducia/login/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

late List listResponse;
Future<List<dynamic>> fetchData() async {
  http.Response response;
  response = await http.get(Uri.parse('${ApiDevLafiducia}/categorias'));
  /*if (response.statusCode == 200) {
      setState(() {
        listResponse = json.decode(response.body);
      });
    }*/
  return listResponse = json.decode(response.body);
}

class Drawer1 extends StatefulWidget {
  static const routeName = "/menu";
  @override
  State<StatefulWidget> createState() {
    return _Drawer1State();
  }
}

class _Drawer1State extends State<Drawer1> {
  SharedPreferences? sharedPreferences;
  int _current = 0;
  bool isSwitched = false;
  final CarouselController _controller = CarouselController();
  late String stringResponse;
  final plugin = FacebookLogin(debug: true);
  @override
  void initState() {
    fetchData();
    super.initState();
    loginStatus();
  }

  loginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences?.getString("token") == null) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      color: Colors.white,
      child: Column(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Stack(
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).size.width * 0.06,
                      left: MediaQuery.of(context).size.width * 0.0,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width * 0.18,
                          width: MediaQuery.of(context).size.width * 0.18,
                          child: IconButton(
                            icon: Image.asset('assets/avatar.png'),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Text(
                        'BONJOUR!',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          package: 'awesome_package',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      top: MediaQuery.of(context).size.width * 0.12,
                      right: MediaQuery.of(context).size.width * 0.25,
                    ),
                    Positioned(
                        top: MediaQuery.of(context).size.width * 0.21,
                        left: MediaQuery.of(context).size.width * 0.25,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'CONNECTEZ-VOUS',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: ' ICI',
                                style: TextStyle(
                                  color: const Color(0xFFB58E00),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () => Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              LoginPage(plugin: plugin),
                                        ),
                                        (route) => false,
                                      ),
                              ),
                            ],
                          ),
                        )),
                    Positioned(
                        top: MediaQuery.of(context).size.width * 0.28,
                        left: MediaQuery.of(context).size.width * 0.25,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'SI VOUS NÊTES PAS ENCORE INSCRIT,',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )),
                    Positioned(
                      top: MediaQuery.of(context).size.width * 0.32,
                      left: MediaQuery.of(context).size.width * 0.25,
                      child: RichText(
                        text: TextSpan(
                          text: 'INSCRIVEZ-VOUS ICI',
                          style: TextStyle(
                            color: const Color(0xFFB58E00),
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        RegisterPage(),
                                  ),
                                  (route) => false,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Color.fromRGBO(145, 45, 40, 1),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.09,
                      width: MediaQuery.of(context).size.width * 0.09,
                      child: IconButton(
                        icon: Image.asset('assets/user.png'),
                        onPressed: () {},
                      ),
                    ),
                    Text(
                      '   INFORMATIONS PERSONNELLES',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        package: 'awesome_package',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.5,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Color.fromRGBO(145, 45, 40, 1),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.09,
                      width: MediaQuery.of(context).size.width * 0.09,
                      child: IconButton(
                        icon: Image.asset('assets/sobre-nos.png'),
                        onPressed: () {},
                      ),
                    ),
                    Text(
                      '   À PROPOS DE NOUS',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        package: 'awesome_package',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.5,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Color.fromRGBO(145, 45, 40, 1),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.09,
                      width: MediaQuery.of(context).size.width * 0.09,
                      child: IconButton(
                        icon: Image.asset('assets/food-delivery.png'),
                        onPressed: () {},
                      ),
                    ),
                    Text(
                      '   MES COMMANDES',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        package: 'awesome_package',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.5,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Color.fromRGBO(145, 45, 40, 1),
              ),
              /*Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.09,
                      width: MediaQuery.of(context).size.width * 0.09,
                      child: IconButton(
                        icon: Image.asset('assets/notification.png'),
                        onPressed: () {},
                      ),
                    ),
                    Text(
                      '   NOTIFICATIONS',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        package: 'awesome_package',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.5,
                      ),
                    ),
                    SizedBox(width: 80),
                    CustomSwitch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                          print(isSwitched);
                        });
                      },
                    ),
                  ],
                ),
              ),*/
              Divider(
                color: Color.fromRGBO(145, 45, 40, 1),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.09,
                      width: MediaQuery.of(context).size.width * 0.09,
                      child: IconButton(
                        icon: Image.asset('assets/letter.png'),
                        onPressed: () {},
                      ),
                    ),
                    Text(
                      '   CONTACT ET SUPPORT',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        package: 'awesome_package',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.5,
                      ),
                    )
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  sharedPreferences?.remove("token");

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          LoginPage(plugin: plugin),
                    ),
                    (route) => false,
                  );
                },
                child: const Text('LOG OUT',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        package: 'awesome_package',
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 16)),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  )),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(181, 142, 0, 0.9)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
