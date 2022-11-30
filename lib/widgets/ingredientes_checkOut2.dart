import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:la_fiducia/pages/boissons.dart';
import 'package:la_fiducia/pages/menu.dart';
import 'package:la_fiducia/util/customSwitch.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:la_fiducia/pages/constants.dart';

class Ingredientes_checkOut2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Ingredientes_checkOut2State();
  }
}

class _Ingredientes_checkOut2State extends State<Ingredientes_checkOut2> {
  String identifier = '';
  var teste = 0;

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
    } on PlatformException {}
  }

  List? listProdutosCarrinho;
  Future<List<dynamic>?> fetchProdCarrinho() async {
    final response = await http.get(
        Uri.parse('${ApiDevLafiducia}/produto-carrinho-temp/${identifier}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      try {
        return listProdutosCarrinho = json.decode(response.body);
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FutureBuilder(
          future: fetchProdCarrinho(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (teste == 0) {
              _deviceDetails();
              teste++;
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: Text(
                          "RESUMÉ",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: Color.fromRGBO(45, 61, 75, 1),
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 80,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listProdutosCarrinho?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Divider(
                                color: Color.fromRGBO(190, 190, 190, 1),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 60,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Text(
                                      "${listProdutosCarrinho?[index]['nome'].toUpperCase()}",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        color: Color.fromRGBO(45, 61, 75, 1),
                                        fontFamily: 'Poppins',
                                        package: 'awesome_package',
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          5.5),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "${listProdutosCarrinho?[index]['preco'] ?? 0} €",
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          package: 'awesome_package',
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      )),
                                ]),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 40,
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: FutureBuilder(
                                      future: fetchProdCarrinho(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          var idEncomenda =
                                              (listProdutosCarrinho?[index]
                                                      ['id'] ??
                                                  0);
                                          List? listIngredientesCarrinho;
                                          Future<List<dynamic>>
                                              fetchIngCarrinho() async {
                                            final response = await http.get(
                                                Uri.parse(
                                                    '${ApiDevLafiducia}/ingrediente-carrinho/${idEncomenda}'));

                                            if (response.statusCode == 200) {
                                              // If the server did return a 200 OK response,
                                              // then parse the JSON.
                                              return listIngredientesCarrinho =
                                                  json.decode(response.body);
                                            } else {
                                              // If the server did not return a 200 OK response,
                                              // then throw an exception.
                                              throw Exception(
                                                  'Failed to load album');
                                            }
                                          }

                                          return FutureBuilder(
                                              future: fetchIngCarrinho(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                if (snapshot.hasData) {
                                                  return new ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount:
                                                          listIngredientesCarrinho
                                                                  ?.length ??
                                                              0,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        var precoIngInd = double.parse(
                                                                listIngredientesCarrinho?[
                                                                            index]
                                                                        [
                                                                        'preco'] ??
                                                                    0) *
                                                            double.parse(
                                                                listIngredientesCarrinho?[
                                                                            index]
                                                                        [
                                                                        'quantidade'] ??
                                                                    0);
                                                        return Column(
                                                            children: <Widget>[
                                                              Row(children: [
                                                                SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.5,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Align(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child: Text(
                                                                              '+' + ' ' + (listIngredientesCarrinho?[index]['nome'] ?? 0).toUpperCase().toString(),
                                                                              style: const TextStyle(
                                                                                fontFamily: 'Poppins',
                                                                                package: 'awesome_package',
                                                                                fontWeight: FontWeight.w300,
                                                                                color: Colors.black,
                                                                                fontSize: 12,
                                                                              ),
                                                                            )),
                                                                        SizedBox(
                                                                          height:
                                                                              MediaQuery.of(context).size.height * 0.003,
                                                                        ),
                                                                        Align(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child: Text(
                                                                              'QUANTITÉ' + ' ' + (listIngredientesCarrinho?[index]['quantidade'] ?? 0).toString(),
                                                                              style: const TextStyle(
                                                                                fontFamily: 'Poppins',
                                                                                package: 'awesome_package',
                                                                                fontWeight: FontWeight.w200,
                                                                                color: Colors.black,
                                                                                fontSize: 11,
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    )),
                                                                SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        5),
                                                                Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child: Text(
                                                                      "${precoIngInd.toStringAsFixed(2)} €",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        package:
                                                                            'awesome_package',
                                                                        fontWeight:
                                                                            FontWeight.w300,
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    )),
                                                              ]),
                                                              SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.02),
                                                            ]);
                                                      });
                                                } else {
                                                  return Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height,
                                                      child: Center(
                                                          child: CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Color.fromRGBO(
                                                                          181,
                                                                          142,
                                                                          0,
                                                                          0.9)))));
                                                }
                                              });
                                        } else {
                                          return Container(
                                              color: Color.fromRGBO(
                                                  235, 235, 235, 1),
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              child: Center(
                                                  child: CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Color.fromRGBO(
                                                                  181,
                                                                  142,
                                                                  0,
                                                                  0.9)))));
                                        }
                                      })),
                            ],
                          );
                        }),
                    Divider(
                      color: Color.fromRGBO(190, 190, 190, 1),
                    ),
                  ],
                ),
              ),
            );
          }),
    ]);
  }
}
