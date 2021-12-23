import 'package:flutter/material.dart';
import 'package:la_fiducia/util/world_time.dart';
import 'package:la_fiducia/pages/constants.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:la_fiducia/pages/atualizar.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void setupWorldTime() async {
    WorldTime instance = WorldTime();
    await Future.delayed(const Duration(milliseconds: 2000), () {});

    Navigator.pushReplacementNamed(
      context,
      '/menu',
    );
  }

  void ecraDeMabutencao() async {
    WorldTime instance = WorldTime();
    await Future.delayed(const Duration(milliseconds: 1500), () {});

    Navigator.pushReplacementNamed(
      context,
      '/manutencao',
    );
  }

  List listEstadoFerias = [];
  var FechadoFerias;
  Future<List<dynamic>> fetchFerias() async {
    final response =
        await http.get(Uri.parse('${ApiDevLafiducia}/ferias-restaurante/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        FechadoFerias = 200;
      });

      return listEstadoFerias = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      setState(() {
        FechadoFerias = 400;
      });
      throw Exception('Failed to load album');
    }
  }

  List listEstadoFolga = [];
  var FechadoFolga;
  Future<List<dynamic>> fetchFolga() async {
    final response =
        await http.get(Uri.parse('${ApiDevLafiducia}/ferias-restaurante/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        FechadoFolga = 200;
      });

      return listEstadoFolga = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      setState(() {
        FechadoFolga = 400;
      });
      throw Exception('Failed to load album');
    }
  }

  List listEstado = [];
  var AbertaFechada;
  Future<List<dynamic>> fetchEstado() async {
    final response =
        await http.get(Uri.parse('${ApiDevLafiducia}/estado-app/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        AbertaFechada = 200;
      });

      return listEstado = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      setState(() {
        AbertaFechada = 400;
      });
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    fetchEstado();
    fetchFerias();
    fetchFolga();
    super.initState();
  }

  var i = 0;

  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';

  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      });
    });

    if (i < 1) {
      if (AbertaFechada == 200) {
        i++;
        setupWorldTime();
        if (FechadoFerias == 400) {
          Timer.run(() {
            showDialog(
              context: context,
              builder: (BuildContext context) =>
                  _buildPopupDialogFerias(context),
            );
          });
        } else if (FechadoFolga == 400) {
          Timer.run(() {
            showDialog(
              context: context,
              builder: (BuildContext context) =>
                  _buildPopupDialogFolga(context),
            );
          });
        } else if (version != '11.0') {
          Timer.run(() {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Atualizar(),
              ),
              (route) => false,
            );
          });
        }
      } else if (AbertaFechada == 400) {
        i++;
        ecraDeMabutencao();
      }
    }

    return Scaffold(
      body: FutureBuilder(
          future: fetchEstado(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Stack(
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
                  padding: EdgeInsets.all(40.0),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        '${version.toString()}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
                            color: Color.fromRGBO(114, 20, 17, 1)),
                      )),
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
            );
          }),
    );
  }

  Widget _buildPopupDialogFerias(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: new AlertDialog(
        actions: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Column(
                    children: [
                      Text("Nous sommes fermés jusqu'au",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(181, 142, 0, 1),
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK",
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
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildPopupDialogFolga(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: new AlertDialog(
        actions: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Column(
                    children: [
                      Text('Nous sommes fermés le mardi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(181, 142, 0, 1),
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK",
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
                ],
              ))
        ],
      ),
    );
  }
}
