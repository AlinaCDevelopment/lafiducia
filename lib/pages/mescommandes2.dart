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

import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:la_fiducia/pages/checkOut2.dart';
import 'package:la_fiducia/pages/menu.dart';
import 'package:intl/intl.dart';
import 'package:la_fiducia/pages/mescommandes.dart';

class MesCommandes2 extends StatefulWidget {
  final String idEncomenda;

  const MesCommandes2({
    Key? key,
    required this.idEncomenda,
  }) : super(key: key);
  @override
  _MesCommandes2State createState() => _MesCommandes2State();
}

class _MesCommandes2State extends State<MesCommandes2> {
  @override
  void initState() {
    super.initState();
    getToken();
    fetchEncomendasEncomenda();
    fetchEncomendasUser();
    fetchEncomendaProd();
  }

  String token = '';
  late var parts2;
  var i = 0;

  Future getToken() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      token = (prefs.getString("token") ?? "");
    });
  }

  String? idUser;

  List? listEncomendas;
  Future<List<dynamic>> fetchEncomendasUser() async {
    final response = await http.get(
        Uri.parse('${ApiDevLafiducia}/encomendas-user/${idUser}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listEncomendas = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  List? listEncomendasEncomendas;
  Future<List<dynamic>> fetchEncomendasEncomenda() async {
    final response = await http.get(
        Uri.parse('${ApiDevLafiducia}/encomendas-id/${widget.idEncomenda}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listEncomendasEncomendas = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  String? estadoEncomenda;

  List? listEncomendaProd;
  Future<List<dynamic>> fetchEncomendaProd() async {
    final response = await http.get(
        Uri.parse(
            '${ApiDevLafiducia}/encomendas-produtos/${widget.idEncomenda}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listEncomendaProd = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  List? listIngredientes;

  Widget build(BuildContext context) {
    if (token != '') {
      String _decodeBase64(String str) {
        String output = str.replaceAll('-', '+').replaceAll('_', '/');

        switch (output.length % 4) {
          case 0:
            break;
          case 2:
            output += '==';
            break;
          case 3:
            output += '=';
            break;
          default:
            throw Exception('Illegal base64url string!"');
        }

        return utf8.decode(base64Url.decode(output));
      }

      Map<String, dynamic> parseJwt(String token) {
        final parts = token.split('.');

        final payload = _decodeBase64(parts[1]);
        final payloadMap = json.decode(payload);

        return payloadMap;
      }

      setState(() {
        parts2 = parseJwt(token)['result'];
      });
    }

    if (parts2?[0]['id'] != null) {
      setState(() {
        idUser = parts2?[0]['id'].toString();
      });
    } else {
      setState(() {
        idUser = parts2?[1].toString();
      });
    }

    return WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MesCommandes(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            titleSpacing: 0,
            leadingWidth: 60,
            centerTitle: true,
            title: FutureBuilder(
                future: fetchEncomendasEncomenda(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Text(
                      'COMMAND Nº${listEncomendasEncomendas?[0]['id_encomenda']}',
                      style: TextStyle(
                        color: Color.fromRGBO(45, 61, 75, 1),
                        fontFamily: 'Poppins',
                        package: 'awesome_package',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ));
                }),
            automaticallyImplyLeading:
                false, //optional: removes the default back arrow
          ),
          body: FutureBuilder(
            future: fetchEncomendasEncomenda(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (listEncomendasEncomendas![0]['estado_encomenda'] == 1) {
                estadoEncomenda = 'En préparation';
              } else if (listEncomendasEncomendas![0]['estado_encomenda'] ==
                  2) {
                estadoEncomenda = 'Envoyé / Prêt à Levanter';
              } else {
                estadoEncomenda = 'Livré';
              }
              return ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                        child: Column(children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('INFORMATIONS DE COMMANDE',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Nº DE COMMANDE:',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                                '${listEncomendasEncomendas?[0]['id_encomenda']}',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('TOTAL:',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Text(
                                '${listEncomendasEncomendas?[0]['preco'] ?? 0} €',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('LIVRAISON:',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child:
                                Text('${listEncomendasEncomendas?[0]['envio']}',
                                    style: TextStyle(
                                      color: Color.fromRGBO(45, 61, 75, 1),
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('DATE:',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Text(
                                '${listEncomendasEncomendas?[0]['data'].substring(0, 10) + ', ' + listEncomendasEncomendas?[0]['data'].substring(11, 13) + 'H' + listEncomendasEncomendas?[0]['data'].substring(14, 16)}',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('DATE DE LIVRAISON:',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Text(
                                '${listEncomendasEncomendas?[0]['data'].substring(0, 10) + ', ' + listEncomendasEncomendas?[0]['hora_levantamento'].substring(0, 2) + 'H' + listEncomendasEncomendas?[0]['hora_levantamento'].substring(3, 5)}',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('PAIMENT:',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Text(
                                '${listEncomendasEncomendas?[0]['pagamento']}',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('ETAT:',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Text('${estadoEncomenda}',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      ),
                    ])),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                        child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8.0, right: 8.0),
                              child: Text('INFORMATIONS SUPPLÉMENTAIRES',
                                  style: TextStyle(
                                    color: Color.fromRGBO(45, 61, 75, 1),
                                    fontFamily: 'Poppins',
                                    package: 'awesome_package',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ],
                        ),
                        Divider(
                          color: Color.fromRGBO(190, 190, 190, 1),
                        ),
                        FutureBuilder(
                            future: fetchEncomendaProd(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: listEncomendaProd!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Future<List<dynamic>>
                                        fetchEncomendaIng() async {
                                      final response = await http.get(
                                          Uri.parse(
                                              '${ApiDevLafiducia}/encomendas-ingredientes/${widget.idEncomenda}/${listEncomendaProd?[index]['id_main']}/${listEncomendaProd?[index]['id_produto']}/${listEncomendaProd?[index]['tipo_produto']}'),
                                          headers: {
                                            'Accept': 'application/json',
                                            'Authorization': 'Bearer $token',
                                          });

                                      if (response.statusCode == 200) {
                                        // If the server did return a 200 OK response,
                                        // then parse the JSON.
                                        return listIngredientes =
                                            json.decode(response.body);
                                      } else {
                                        // If the server did not return a 200 OK response,
                                        // then throw an exception.
                                        throw Exception('Failed to load album');
                                      }
                                    }

                                    if (snapshot.hasData) {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      30),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    10,
                                                child: Text('PLAT',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          45, 61, 75, 1),
                                                      fontFamily: 'Poppins',
                                                      package:
                                                          'awesome_package',
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ),
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      30),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.6,
                                                child: Text(
                                                    '${listEncomendaProd?[index]['nome'] ?? ''}',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          45, 61, 75, 1),
                                                      fontFamily: 'Poppins',
                                                      package:
                                                          'awesome_package',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    10,
                                                child: Text(
                                                    '${listEncomendaProd?[index]['pvp'] ?? ''}€',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          45, 61, 75, 1),
                                                      fontFamily: 'Poppins',
                                                      package:
                                                          'awesome_package',
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            child: FutureBuilder(
                                                future: fetchEncomendaProd(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot snapshot) {
                                                  return FutureBuilder(
                                                      future:
                                                          fetchEncomendaIng(),
                                                      builder:
                                                          (BuildContext context,
                                                              AsyncSnapshot
                                                                  snapshot) {
                                                        return ListView.builder(
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                listIngredientes!
                                                                    .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              var quantidadii =
                                                                  listIngredientes?[
                                                                          index]
                                                                      [
                                                                      'quantidade'];
                                                              var precii = double.parse(
                                                                  listIngredientes?[
                                                                          index]
                                                                      [
                                                                      'preco']);
                                                              var totlez =
                                                                  quantidadii *
                                                                      precii;
                                                              return Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8.0),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                        width: MediaQuery.of(context).size.width /
                                                                            30),
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          10,
                                                                      child: Text(
                                                                          'EXTRA',
                                                                          style:
                                                                              TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                45,
                                                                                61,
                                                                                75,
                                                                                1),
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            package:
                                                                                'awesome_package',
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          )),
                                                                    ),
                                                                    SizedBox(
                                                                        width: MediaQuery.of(context).size.width /
                                                                            30),
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          1.6,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child: Text('${listIngredientes?[index]['nome'] ?? ''}',
                                                                                style: TextStyle(
                                                                                  color: Color.fromRGBO(45, 61, 75, 1),
                                                                                  fontFamily: 'Poppins',
                                                                                  package: 'awesome_package',
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.w400,
                                                                                )),
                                                                          ),
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                Text(
                                                                              'QUANTITÉ' + ' ' + (listIngredientes?[index]['quantidade'] ?? '').toString(),
                                                                              style: const TextStyle(
                                                                                fontFamily: 'Poppins',
                                                                                package: 'awesome_package',
                                                                                fontWeight: FontWeight.w200,
                                                                                color: Colors.black,
                                                                                fontSize: 10.5,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          10,
                                                                      child: Text(
                                                                          '${totlez ?? ''.toString()}€',
                                                                          style:
                                                                              TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                45,
                                                                                61,
                                                                                75,
                                                                                1),
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            package:
                                                                                'awesome_package',
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          )),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            });
                                                      });
                                                }),
                                          ),
                                          Divider(
                                            color: Color.fromRGBO(
                                                190, 190, 190, 1),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: Container(
                                            height: 300,
                                            child: Center(
                                                child: CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Color.fromRGBO(
                                                                181,
                                                                142,
                                                                0,
                                                                0.9))))),
                                      );
                                    }
                                  });
                            }),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 12.0, top: 4.0),
                          child: Row(
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 30),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 10,
                                child: Text('TOTAL',
                                    style: TextStyle(
                                      color: Color.fromRGBO(45, 61, 75, 1),
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 80),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.6,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 9,
                                child: Text(
                                    '${listEncomendasEncomendas?[0]['preco'] ?? ''} €',
                                    style: TextStyle(
                                      color: Color.fromRGBO(45, 61, 75, 1),
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                        child: Column(children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('INFORMATIONS DE LIVRAISON',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('NOM:',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child:
                                Text('${listEncomendasEncomendas?[0]['nome']}',
                                    style: TextStyle(
                                      color: Color.fromRGBO(45, 61, 75, 1),
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('CODE POSTAL:',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Text(
                                '${listEncomendasEncomendas?[0]['cod_postal']}',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('TELÉPHONE:',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Text(
                                '${listEncomendasEncomendas?[0]['telefone']}',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('ADRESSE:',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Text(
                                '${listEncomendasEncomendas?[0]['morada']}',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('LOCALITÉ:',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Text(
                                '${listEncomendasEncomendas?[0]['localidade']}',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('E-MAIL:',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child:
                                Text('${listEncomendasEncomendas?[0]['email']}',
                                    style: TextStyle(
                                      color: Color.fromRGBO(45, 61, 75, 1),
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    )),
                          ),
                        ],
                      ),
                    ])),
                  ),
                ],
              );
            },
          ),
        ));
  }
}
