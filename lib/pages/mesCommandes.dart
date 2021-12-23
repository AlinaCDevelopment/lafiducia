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
import 'package:intl/intl.dart';
import 'package:la_fiducia/pages/mescommandes2.dart';

class MesCommandes extends StatefulWidget {
  @override
  _MesCommandesState createState() => _MesCommandesState();
}

class _MesCommandesState extends State<MesCommandes> {
  @override
  void initState() {
    getToken();

    fetchEncomendasUser();
    super.initState();
  }

  String token = '';
  late var parts2;
  var i = 0;
  List? encomenda;
  String? estadoEncomenda;

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
        }).then((result) {
      encomenda = json.decode(result.body);
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

  Widget build(BuildContext context) {
    if (i == 0) {
      fetchEncomendasUser();
      i++;
    }
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

    if (parts2[0]['id'] != null) {
      setState(() {
        idUser = parts2[0]['id'].toString();
      });
    } else {
      setState(() {
        idUser = parts2[1].toString();
      });
    }

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
          title: Text('MES COMMANDES',
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
        body: FutureBuilder(
            future: fetchEncomendasUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: encomenda?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      var data = encomenda?[index]['data'].substring(0, 10);
                      var hora = encomenda?[index]['data'].substring(11, 16);

                      var tipoEncomenda;
                      if (encomenda?[index]['envio'] ==
                          'LIVRAISON À DOMICILE (2,50€)') {
                        tipoEncomenda = 'LIVRAISON À DOMICILE';
                      } else {
                        tipoEncomenda = 'RAMASSER AU RESTAURANT';
                      }

                      if (encomenda![index]['estado_encomenda'] == 1) {
                        estadoEncomenda = 'En préparation';
                      } else if (encomenda![index]['estado_encomenda'] == 2) {
                        estadoEncomenda = 'Envoyé / Prêt à Levanter';
                      } else {
                        estadoEncomenda = 'Livré';
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Card(
                            child: Row(children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.63,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          'Nº${encomenda?[index]['id_encomenda'].toString()}',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(45, 61, 75, 1),
                                            fontFamily: 'Poppins',
                                            package: 'awesome_package',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Icon(Icons.fiber_manual_record,
                                        color: Colors.grey, size: 8),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${data}',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(45, 61, 75, 1),
                                            fontFamily: 'Poppins',
                                            package: 'awesome_package',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                          )),
                                    ),
                                    Icon(Icons.fiber_manual_record,
                                        color: Colors.grey, size: 8),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${hora}',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(45, 61, 75, 1),
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
                                      child: Text('PRIX:',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(45, 61, 75, 1),
                                            fontFamily: 'Poppins',
                                            package: 'awesome_package',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          '${encomenda?[index]['preco']} €',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(45, 61, 75, 1),
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
                                      child: Text('LIVRAISON:',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(45, 61, 75, 1),
                                            fontFamily: 'Poppins',
                                            package: 'awesome_package',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 8.0, top: 8.0),
                                      child: Text('${tipoEncomenda} ',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(45, 61, 75, 1),
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
                                            color:
                                                Color.fromRGBO(45, 61, 75, 1),
                                            fontFamily: 'Poppins',
                                            package: 'awesome_package',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 8.0, top: 8.0),
                                      child: Text('${estadoEncomenda}',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(45, 61, 75, 1),
                                            fontFamily: 'Poppins',
                                            package: 'awesome_package',
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.22,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MesCommandes2(
                                            idEncomenda: encomenda![index]
                                                    ['id_encomenda']
                                                .toString(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('VOIR PLUS',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            package: 'awesome_package',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                            fontSize: 11)),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      )),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromRGBO(
                                                  181, 142, 0, 0.9)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ])),
                      );
                    });
              } else {
                return Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Container(
                      height: 300,
                      child: Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color.fromRGBO(181, 142, 0, 0.9))))),
                );
              }
            }));
  }
}
