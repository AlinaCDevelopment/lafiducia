/*import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(),
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
                0.21, //TRY TO CHANGE THIS **0.30** value to achieve your goal
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
        Positioned(
          width: MediaQuery.of(context).size.width * 0.6,
          top: MediaQuery.of(context).size.width * 0.83,
          left: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.width * 0.11,
          child: ButtonTheme(
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/menu');
              },
              child: const Text('LOGIN', style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(181, 142, 0, 0.9)),
              ),
            ),
          ),
          /* ElevatedButton(
            onPressed: () {},
            child: const Text('LOGIN'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(181, 142, 0, 0.8)),
            ),
          ),*/
        ),
        Positioned(
          width: MediaQuery.of(context).size.width * 0.6,
          top: MediaQuery.of(context).size.width * 0.98,
          left: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.width * 0.11,
          child: ButtonTheme(
            child: OutlinedButton(
              onPressed: () {},
              child:
                  const Text('REGISTAR', style: TextStyle(color: Colors.black)),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.black),
                )),
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(255, 255, 255, 1)),
              ),
            ),
          ),
        ),
        Positioned(
            width: MediaQuery.of(context).size.width * 1,
            top: MediaQuery.of(context).size.width * 1.15,
            height: MediaQuery.of(context).size.width * 0.11,
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "AO ACEDER, AFIRMA QUE LEU E CONCORDA COM OS \n",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11.7,
                    )),
                TextSpan(
                    text: "TERMOS E CONDIÇÕES",
                    style: TextStyle(
                      color: Color.fromRGBO(181, 142, 0, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 11.5,
                    )),
                TextSpan(
                    text: " E ",
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 11.5,
                    )),
                TextSpan(
                  text: "POLÍTICA DE PRIVACIDADE",
                  style: TextStyle(
                    color: Color.fromRGBO(181, 142, 0, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 11.5,
                  ),
                ),
              ]),
            )
            /*child: Text(
            'AO ACEDER, AFIRMA QUE LEU E CONCORDA COM OS \n TERMOS E CONDIÇÕES E POLÍTICA DE PRIVACIDADE',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10.0,
                color: Color.fromRGBO(0, 0, 0, 1)),
          ),*/
            ),

        //B58E00
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'COPYRIGHT 2021 ALBINET LDA. TODOS OS DIREITOS RESERVADOS',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 10.0,
                    color: Color.fromRGBO(0, 0, 0, 0.6)),
              )),
        ),
      ],
    ));
  }
}*/
