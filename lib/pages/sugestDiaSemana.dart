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
import 'package:cached_network_image/cached_network_image.dart';

import 'package:la_fiducia/carro/cart.dart';

class SugestDiaSemana extends StatefulWidget {
  @override
  _SugestDiaSemanaState createState() => _SugestDiaSemanaState();
}

class _SugestDiaSemanaState extends State<SugestDiaSemana> {
  @override
  void initState() {
    fetchPratodia();
    fetchPratoSemana();
    fetchidMain();
    fetchFerias();
    super.initState();
  }

  var retrievedName;
  String identifier = '';
  String limite = '';
  var Valuez;
  var teste = 0;
  String token = '';
  var parts2;
  var decoded;
  var decoded2;

  List? idMain;
  Future<List<dynamic>> fetchidMain() async {
    final response = await http
        .get(Uri.parse('${ApiDevLafiducia}/contar-encomenda/${identifier}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return idMain = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<void> _deviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;

        setState(() {
          identifier = build.androidId;
        });
        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        setState(() {
          identifier = data.identifierForVendor;
        }); //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  var i = 0;
  List? listPatoDia;
  Future<List<dynamic>> fetchPratodia() async {
    final response = await http.get(Uri.parse('${ApiDevLafiducia}/prato-dia/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listPatoDia = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return listPatoDia = json.decode(response.body);
    }
  }

  List? listPratoSemana;
  Future<List<dynamic>> fetchPratoSemana() async {
    final response =
        await http.get(Uri.parse('${ApiDevLafiducia}/sugestao-semana/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listPratoSemana = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return listPatoDia = json.decode(response.body);
    }
  }

  List? listProdutosCarrinho;
  Future<List<dynamic>> fetchProdCarrinho() async {
    final response = await http.get(
        Uri.parse('${ApiDevLafiducia}/produto-carrinho-temp/${identifier}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listProdutosCarrinho = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
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

  Widget build(BuildContext context) {
    fetchPratodia();
    fetchPratoSemana();
    fetchidMain();

    return Scaffold(
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
        leadingWidth: 60,
        centerTitle: true,
        title: Text(
          'PLATS',
          style: TextStyle(
            color: Color.fromRGBO(45, 61, 75, 1),
            fontFamily: 'Poppins',
            package: 'awesome_package',
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          FutureBuilder(
              future: fetchProdCarrinho(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (teste == 0) {
                  _deviceDetails();

                  teste++;
                }
                if (snapshot.hasData) {
                  if ((listProdutosCarrinho?.length ?? 0) != 0) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0, top: 30.0),
                      child: GestureDetector(
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            if ((listProdutosCarrinho?.length ?? 0) == 0)
                              Image.asset(
                                "assets/carroInativo.png",
                                width: 40,
                              ),
                            if ((listProdutosCarrinho?.length ?? 0) > 0)
                              Image.asset(
                                "assets/carroAtivo.png",
                                width: 40,
                              ),
                            Padding(
                              padding: const EdgeInsets.only(left: 35.0),
                              child: CircleAvatar(
                                radius: 8.0,
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                child: Text(
                                  (listProdutosCarrinho?.length ?? 0)
                                      .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          if (listProdutosCarrinho!.isNotEmpty)
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Cart(),
                              ),
                            );
                        },
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0, top: 30.0),
                      child: GestureDetector(
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Image.asset(
                              "assets/carroInativo.png",
                              width: 40,
                            ),
                          ],
                        ),
                        onTap: () {
                          if (listProdutosCarrinho!.isNotEmpty)
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Cart(),
                              ),
                            );
                        },
                      ),
                    );
                  }
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
              }),
        ],
      ),
      body: ListView(
        children: [
          FutureBuilder(
              future: fetchPratodia(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (listPatoDia != null) {
                  decoded = utf8.decode(
                      listPatoDia?[0]['titulo'].runes.toList() ?? 0.toString());
                } else {
                  decoded = '';
                }

                return Column(
                  children: [
                    if (listPatoDia != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('PLAT DU JUR',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                )),
                          ],
                        ),
                      ),
                    if (listPatoDia != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Stack(children: [
                            Column(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12.0),
                                    topRight: Radius.circular(12.0),
                                  ),
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://www.lafiducia.lu/ficheiros/produtos/${listPatoDia?[0]['imagem'] ?? 0.toString()}',
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) => Container(
                                          height: 160,
                                          child: Center(
                                              child: CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Color.fromRGBO(181,
                                                              142, 0, 0.9))))),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                              'assets/imagem_indisponivel.jpg',
                                              fit: BoxFit.fitWidth),
                                    ),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12.0),
                                    bottomRight: Radius.circular(12.0),
                                  ),
                                  child: Container(
                                      color: Colors.white,
                                      height: 150,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Row(children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.045,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.85,
                                              child: Text(
                                                decoded.toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  package: 'awesome_package',
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(
                                                      62, 63, 104, 1),
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                          ]),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 14),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${listPatoDia?[0]['pvp'].toStringAsFixed(2)} €",
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    package: 'awesome_package',
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromRGBO(
                                                        62, 63, 104, 1),
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.35,
                                                ),
                                                new SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.32,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.07,
                                                  child: OutlinedButton(
                                                    onPressed: () {
                                                      verifica3(
                                                          String tele) async {
                                                        var response = await http
                                                            .get(Uri.parse(
                                                                '${ApiDevLafiducia}/verifica-produto3/${tele}/'));

                                                        final jsonResponse =
                                                            json.decode(response
                                                                .body
                                                                .toString());

                                                        if (response.statusCode ==
                                                                200 ||
                                                            listProdutosCarrinho!
                                                                    .length ==
                                                                0) {
                                                          var decodedEnvio = utf8
                                                              .decode(listPatoDia?[
                                                                              0]
                                                                          [
                                                                          'titulo']
                                                                      .runes
                                                                      .toList() ??
                                                                  0.toString());
                                                          Future<http.Response>
                                                              postProd() async {
                                                            var dataProd = {
                                                              "id_equipamento":
                                                                  identifier,
                                                              "nome":
                                                                  decodedEnvio,
                                                              "foto": listPatoDia?[
                                                                          0]
                                                                      ['imagem']
                                                                  .toString(),
                                                              "id_prato":
                                                                  listPatoDia?[
                                                                              0]
                                                                          ['id']
                                                                      .toString(),
                                                              "preco": listPatoDia?[
                                                                      0]['pvp']
                                                                  .toStringAsFixed(
                                                                      2),
                                                              "tipo_encomenda":
                                                                  'APP',
                                                              "id_main": (idMain?[
                                                                              0]
                                                                          [
                                                                          'total'] +
                                                                      1)
                                                                  .toString(),
                                                              "tipo_produto":
                                                                  1.toString(),
                                                              "id_subcategoria":
                                                                  '1',
                                                            };

                                                            var res = await http.post(
                                                                Uri.parse(
                                                                    '${ApiDevLafiducia}/carrinho-app/'),
                                                                body: dataProd);

                                                            return res;
                                                          }

                                                          postProd();
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Menu(),
                                                            ),
                                                          );
                                                        } else {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                _buildPopupDialogMenuEstudante(
                                                                    context),
                                                          );
                                                        }
                                                      }

                                                      verifica3(identifier);
                                                    },
                                                    child: const Text('AJOUTER',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            package:
                                                                'awesome_package',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.white,
                                                            fontSize: 15)),
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty
                                                          .all(
                                                              RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                      )),
                                                      backgroundColor:
                                                          MaterialStateProperty.all<
                                                              Color>(const Color
                                                                  .fromRGBO(181,
                                                              142, 0, 0.9)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ]),
                        ),
                      ),
                    if (listPatoDia == null) SizedBox(),
                  ],
                );
              }),
          FutureBuilder(
              future: fetchPratoSemana(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                print(listPratoSemana);
                if (listPratoSemana != null) {
                  decoded2 = utf8.decode(
                      listPratoSemana?[0]['titulo'].runes.toList() ??
                          0.toString());
                } else {
                  decoded = '';
                }

                return Column(
                  children: [
                    if (listPratoSemana != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('PLAT DE LA SEMANIE',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                )),
                          ],
                        ),
                      ),
                    if (listPratoSemana != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Stack(children: [
                            Column(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12.0),
                                    topRight: Radius.circular(12.0),
                                  ),
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://www.lafiducia.lu/ficheiros/produtos/${listPratoSemana?[0]['imagem'] ?? 0.toString()}',
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) => Container(
                                          height: 160,
                                          child: Center(
                                              child: CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Color.fromRGBO(181,
                                                              142, 0, 0.9))))),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                              'assets/imagem_indisponivel.jpg',
                                              fit: BoxFit.fitWidth),
                                    ),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12.0),
                                    bottomRight: Radius.circular(12.0),
                                  ),
                                  child: Container(
                                      color: Colors.white,
                                      height: 150,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Row(children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.045,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.85,
                                              child: Text(
                                                decoded2.toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  package: 'awesome_package',
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(
                                                      62, 63, 104, 1),
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                          ]),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 14),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${listPratoSemana?[0]['pvp'].toStringAsFixed(2)} €",
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    package: 'awesome_package',
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromRGBO(
                                                        62, 63, 104, 1),
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.35,
                                                ),
                                                new SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.32,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.07,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      if (FechadoFerias == 200)
                                                        OutlinedButton(
                                                          onPressed: () {
                                                            verifica3(
                                                                String
                                                                    tele) async {
                                                              var response =
                                                                  await http.get(
                                                                      Uri.parse(
                                                                          '${ApiDevLafiducia}/verifica-produto3/${tele}/'));

                                                              final jsonResponse =
                                                                  json.decode(
                                                                      response
                                                                          .body
                                                                          .toString());

                                                              if (response.statusCode ==
                                                                      200 ||
                                                                  listProdutosCarrinho!
                                                                          .length ==
                                                                      0) {
                                                                var decodedEnvio2 = utf8.decode(listPratoSemana?[0]
                                                                            [
                                                                            'titulo']
                                                                        .runes
                                                                        .toList() ??
                                                                    0.toString());
                                                                Future<http.Response>
                                                                    postProd() async {
                                                                  var dataProd =
                                                                      {
                                                                    "id_equipamento":
                                                                        identifier,
                                                                    "nome": decoded2
                                                                        .toString(),
                                                                    "foto":
                                                                        decodedEnvio2,
                                                                    "id_prato": listPratoSemana?[0]
                                                                            [
                                                                            'id']
                                                                        .toString(),
                                                                    "preco": listPratoSemana?[0]
                                                                            [
                                                                            'pvp']
                                                                        .toStringAsFixed(
                                                                            2),
                                                                    "tipo_encomenda":
                                                                        'APP',
                                                                    "id_main":
                                                                        (idMain?[0]['total'] +
                                                                                1)
                                                                            .toString(),
                                                                    "tipo_produto":
                                                                        1.toString(),
                                                                    "id_subcategoria":
                                                                        '1'
                                                                  };

                                                                  var res = await http.post(
                                                                      Uri.parse(
                                                                          '${ApiDevLafiducia}/carrinho-app/'),
                                                                      body:
                                                                          dataProd);

                                                                  return res;
                                                                }

                                                                postProd();
                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Menu(),
                                                                  ),
                                                                );
                                                              } else {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      _buildPopupDialogMenuEstudante(
                                                                          context),
                                                                );
                                                              }
                                                            }

                                                            verifica3(
                                                                identifier);
                                                          },
                                                          child: const Text(
                                                              'AJOUTER',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  package:
                                                                      'awesome_package',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15)),
                                                          style: ButtonStyle(
                                                            shape: MaterialStateProperty
                                                                .all(
                                                                    RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.0),
                                                            )),
                                                            backgroundColor:
                                                                MaterialStateProperty.all<
                                                                        Color>(
                                                                    const Color
                                                                            .fromRGBO(
                                                                        181,
                                                                        142,
                                                                        0,
                                                                        0.9)),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ]),
                        ),
                      ),
                    if (listPratoSemana == null) SizedBox(),
                  ],
                );
              }),
        ],
      ),
    );
  }

  Widget _buildPopupDialogMenuEstudante(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: new AlertDialog(
        actions: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height / 5,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Column(
                    children: [
                      Text(
                          "Il y a un menu étudiant dans le panier, il n'est pas possible d'ajouter ce produit.",
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
                        child: const Text("Réessayer",
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
