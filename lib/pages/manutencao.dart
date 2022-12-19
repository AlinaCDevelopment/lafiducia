import 'package:flutter/material.dart';
import 'package:la_fiducia/Useless/world_time.dart';
import 'package:la_fiducia/pages/constants.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Manutencao extends StatefulWidget {
  @override
  _ManutencaoState createState() => _ManutencaoState();
}

class _ManutencaoState extends State<Manutencao> {
  @override
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/introPizza.png'),
                alignment: Alignment(1, 0),
                fit: BoxFit.cover,
              ))),
          Positioned(
              width: MediaQuery.of(context).size.width,
              top: MediaQuery.of(context).size.width *
                  0.50, //TRY TO CHANGE THIS **0.30** value to achieve your goal
              child: Container(
                margin: const EdgeInsets.all(60.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/Positivo.png', scale: 1),
                      const SizedBox(
                        height: 0,
                      ),
                    ]),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 450.0),
            child: Center(
                child: Column(
              children: [
                Text('EN MAINTENANCE',
                    style: TextStyle(
                      color: Color.fromRGBO(45, 61, 75, 1),
                      fontFamily: 'Poppins',
                      package: 'awesome_package',
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(
                  height: 10,
                ),
                Text('REVENEZ PLUS TARD',
                    style: TextStyle(
                      color: Color.fromRGBO(45, 61, 75, 1),
                      fontFamily: 'Poppins',
                      package: 'awesome_package',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    )),
              ],
            )),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'COPYRIGHT ${now.year} ALBINET LDA. TODOS OS DIREITOS RESERVADOS',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                      color: Color.fromRGBO(114, 20, 17, 1)),
                )),
          ),
        ],
      ),
    );
  }
}
