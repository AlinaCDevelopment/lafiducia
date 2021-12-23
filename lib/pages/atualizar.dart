import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:la_fiducia/util/world_time.dart';
import 'package:la_fiducia/pages/constants.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:uuid/uuid.dart';

class Atualizar extends StatefulWidget {
  @override
  _AtualizarState createState() => _AtualizarState();
}

class _AtualizarState extends State<Atualizar> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Allow Notifications'),
            content: Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  )),
              TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: Text(
                    'Allow',
                    style: TextStyle(
                        color: Colors.teal,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.only(top: 250.0, left: 60, right: 60),
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                height: MediaQuery.of(context).size.height / 7.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text("Mettre à jour l'application",
                              style: TextStyle(
                                color: Color.fromRGBO(45, 61, 75, 1),
                                fontFamily: 'Poppins',
                                package: 'awesome_package',
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 64,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            StoreRedirect.redirect();
                          },
                          child: const Text("Update",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontSize: 16)),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(181, 142, 0, 0.9)),
                              side: MaterialStateProperty.all(BorderSide(
                                  color: Color.fromRGBO(181, 142, 0, 0.9),
                                  width: 0.0,
                                  style: BorderStyle.solid))),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'COPYRIGHT 2021 ALBINET LDA. TODOS OS DIREITOS RESERVADOS',
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
