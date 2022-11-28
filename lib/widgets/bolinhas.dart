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

late List listSugest;
Future<List<dynamic>> fetchBanners() async {
  http.Response response;
  response = await http.get(Uri.parse('${ApiDevLafiducia}/sugestoes'));
  /*if (response.statusCode == 200) {
      setState(() {
        listResponse = json.decode(response.body);
      });
    }*/
  return listSugest = json.decode(response.body);
}

class Bolinhas extends StatefulWidget {
  static const routeName = "/menu";
  @override
  State<StatefulWidget> createState() {
    return _BolinhasState();
  }
}

class _BolinhasState extends State<Bolinhas> {
  int _current = 0;
  bool isSwitched = false;
  final CarouselController _controller = CarouselController();
  late String stringResponse;

  var retrievedName;
  String identifier = '';
  var Valuez;
  var teste = 0;
  @override
  void initState() {
    fetchBanners();
    fetchidMain();
    fetchFerias();
    fetchFolga();
    fetchProdCarrinho();
    super.initState();
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

  Map? idMain;
  Future<Map<String, dynamic>> fetchidMain() async {
    final response = await http
        .get(Uri.parse('${ApiDevLafiducia}/contar-encomenda/${identifier}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return idMain = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Falhou Aqui');
    }
  }

  Map? listEstadoFerias;
  var FechadoFerias;
  Future<Map<String, dynamic>> fetchFerias() async {
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

  Map? listEstadoFolga;
  var FechadoFolga;
  Future<Map<String, dynamic>> fetchFolga() async {
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

  Map? listProdutosCarrinho;
  Future<Map<String, dynamic>> fetchProdCarrinho() async {
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

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder<Map<String, dynamic>>(
            future: fetchidMain(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return FutureBuilder<List<dynamic>>(
                  future: fetchBanners(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (teste == 0) {
                      _deviceDetails();

                      teste++;
                    }
                    if (snapshot.hasData) {
                      return Scaffold(
                        backgroundColor: Color.fromRGBO(45, 61, 75, 0.11),
                        body: Column(children: [
                          Padding(padding: EdgeInsets.only(top: 0)),
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            child: Text(
                              'Suggestions',
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  package: 'awesome_package',
                                  fontSize: 17,
                                  color: Color.fromRGBO(62, 63, 104, 1)),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 5)),
                          CarouselSlider.builder(
                            itemCount: listSugest.length,
                            carouselController: _controller,
                            options: CarouselOptions(
                                autoPlay: false,
                                enlargeCenterPage: true,
                                aspectRatio: 1.5,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                }),
                            itemBuilder: (context, index, realIdx) {
                              return Container(
                                margin: EdgeInsets.all(2.0),
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(top: 5),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                            ),
                                            child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://www.lafiducia.lu/ficheiros/produtos/${listSugest[index]['imagem'].toString()}',
                                                fit: BoxFit.fitHeight,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4.5,
                                                placeholder: (context, url) => Container(
                                                    height: 400,
                                                    child: Center(
                                                        child: CircularProgressIndicator(
                                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                                Color.fromRGBO(
                                                                    181, 142, 0, 0.9))))),
                                                errorWidget: (context, url, error) =>
                                                    Image.asset(
                                                        'assets/imagem_indisponivel.jpg',
                                                        fit: BoxFit.fitHeight)),
                                            /*child: CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            LinearProgressIndicator(
                                          minHeight: 10,
                                          backgroundColor:
                                              Color.fromRGBO(181, 142, 0, 1),
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Color.fromRGBO(
                                                      62, 63, 104, 1)),
                                        ),
                                        imageUrl:
                                            "https://www.lafiducia.lu/ficheiros/produtos/${listSugest[index]['imagem'].toString()}",
                                        fit: BoxFit.fill,
                                        height: 170.0,

                                        errorWidget: (context, url, error) =>
                                            new Image(
                                                image: AssetImage(
                                                    'assets/imagem_indisponivel.jpg')), //// YOU CAN CREATE YOUR OWN ERROR WIDGET HERE
                                      )*/
                                          ),
                                        ),
                                        FutureBuilder<Map<String, dynamic>>(
                                            future: fetchProdCarrinho(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot snapshot) {
                                              return Positioned(
                                                bottom: 15.0,
                                                left: 0.0,
                                                right: 0.0,
                                                child: Container(
                                                  height: 88,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(10.0),
                                                      bottomRight:
                                                          Radius.circular(10.0),
                                                    ),
                                                    color: Colors.white,
                                                  ),
                                                  child: Column(
                                                    children: <Widget>[
                                                      const SizedBox(
                                                          height: 8.0),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 0.0),
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      5),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            /* listResponse[0]['titulo'].toString(),*/

                                                            listSugest[index]
                                                                ['titulo'],
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 0.0),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0.0),
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                "${listSugest[index]['pvp'].toStringAsFixed(2)} €",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 5.0),
                                                      new SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.32,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.07,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            if (FechadoFerias ==
                                                                    200 &&
                                                                FechadoFolga ==
                                                                    200)
                                                              OutlinedButton(
                                                                onPressed: () {
                                                                  verifica3(
                                                                      String
                                                                          tele) async {
                                                                    var response =
                                                                        await http
                                                                            .get(Uri.parse('${ApiDevLafiducia}/verifica-produto3/${tele}/'));

                                                                    final jsonResponse =
                                                                        json.decode(response
                                                                            .body
                                                                            .toString());

                                                                    if (response.statusCode ==
                                                                            200 ||
                                                                        listProdutosCarrinho!.length ==
                                                                            0) {
                                                                      Future<http.Response>
                                                                          postProd() async {
                                                                        var dataProd =
                                                                            {
                                                                          "id_equipamento":
                                                                              identifier,
                                                                          "nome":
                                                                              listSugest[index]['titulo'].toString(),
                                                                          "foto":
                                                                              listSugest[index]['imagem'].toString(),
                                                                          "id_prato":
                                                                              listSugest[index]['id'].toString(),
                                                                          "preco":
                                                                              listSugest[index]['pvp'].toStringAsFixed(2),
                                                                          "tipo_encomenda":
                                                                              'APP',
                                                                          "id_main":
                                                                              (idMain?[0]['total'] + 1).toString(),
                                                                          "tipo_produto":
                                                                              2.toString(),
                                                                          "id_subcategoria":
                                                                              listSugest[index]['subcategoria'].toString(),
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
                                                                          builder: (context) =>
                                                                              Menu(),
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext context) =>
                                                                                _buildPopupDialogMenuEstudante(context),
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
                                                                style:
                                                                    ButtonStyle(
                                                                  shape: MaterialStateProperty
                                                                      .all(
                                                                          RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4.0),
                                                                  )),
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all<
                                                                          Color>(const Color
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
                                              );
                                            })
                                      ],
                                    )),
                              );
                            },
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 2)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: listSugest.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () =>
                                    _controller.animateToPage(entry.key),
                                child: Container(
                                  width: 12.0,
                                  height: 12.0,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Color.fromRGBO(45, 61, 75, 1))
                                          .withOpacity(_current == entry.key
                                              ? 0.9
                                              : 0.4)),
                                ),
                              );
                            }).toList(),
                          ),
                        ]),
                      );
                    } else {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            height: MediaQuery.of(context).size.height * 1,
                            child: Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color.fromRGBO(181, 142, 0, 0.9))))),
                      );
                    }
                  });
            }));
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
