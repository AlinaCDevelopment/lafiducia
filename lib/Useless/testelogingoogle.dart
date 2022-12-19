/*import 'dart:ffi';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:la_fiducia/login/login_controller.dart';
import 'package:la_fiducia/pages/categoria.dart';
import 'package:la_fiducia/util/customSwitch.dart';
import 'package:flutter/gestures.dart';
import 'package:la_fiducia/widgets/build_botao.dart';
import 'package:la_fiducia/widgets/bolinhas.dart';
import 'package:la_fiducia/widgets/drawer_novo.dart';
import 'package:la_fiducia/carro/cart.dart';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:la_fiducia/pages/constants.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:la_fiducia/login/login_page.dart';

class testeLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _testeLoginState();
  }
}

class _testeLoginState extends State<testeLogin> {
  final controller = Get.put(LoginController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            title: Text('TESTE GOOGLE',
                style: TextStyle(
                  color: Color.fromRGBO(45, 61, 75, 1),
                  fontFamily: 'Poppins',
                  package: 'awesome_package',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                )),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: Image.network('').image,
                radius: 100,
              ),
              Text(controller.googleAccount.value?.displayName ?? ''),
              Text(
                controller.googleAccount.value?.email ?? '',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ));
  }
}*/
//TODO