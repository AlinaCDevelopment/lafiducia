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
import 'package:flutter_html/flutter_html.dart';
import 'package:la_fiducia/carro/cart.dart';

class MenuEstudante extends StatefulWidget {
  @override
  _MenuEstudanteState createState() => _MenuEstudanteState();
}

class _MenuEstudanteState extends State<MenuEstudante> {
  @override
  void initState() {
    fetchProdCarrinho();
    _deviceDetails();
    fetchidMain();
    super.initState();
  }

  String identifier = '';
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

  late List listMenuEstudante;
  Future<List<dynamic>> fetchMenuEstudante() async {
    http.Response response;
    response = await http.get(Uri.parse('${ApiDevLafiducia}/menu-estudante/'));
    /*if (response.statusCode == 200) {
      setState(() {
        listResponse = json.decode(response.body);
      });
    }*/
    return listMenuEstudante = json.decode(response.body);
  }

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

  var teste = 0;

  Widget build(BuildContext context) {
    fetchidMain();
    return Scaffold(
        backgroundColor: Color.fromRGBO(235, 235, 235, 1),
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
          title: Text(' Menu Estudante',
              style: TextStyle(
                color: Color.fromRGBO(45, 61, 75, 1),
                fontFamily: 'Poppins',
                package: 'awesome_package',
                fontSize: 20,
                fontWeight: FontWeight.w500,
              )),
          automaticallyImplyLeading:
              false, //optional: removes the default back arrow
          actions: <Widget>[
            FutureBuilder(
                future: fetchProdCarrinho(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (teste == 0) {
                    _deviceDetails();

                    teste++;
                  }
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
                }),
          ],
        ),
        body: Stack(
          children: [
            FutureBuilder<List<dynamic>>(
                future: fetchMenuEstudante(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return FutureBuilder<List<dynamic>>(
                        future: fetchProdCarrinho(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return ListView.builder(
                              itemCount: 1,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                    elevation: 0,
                                    color: Color.fromRGBO(235, 235, 235, 1),
                                    child: Stack(
                                      children: [
                                        Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                listMenuEstudante.length /
                                                2,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 30),
                                              child:
                                                  FutureBuilder<List<dynamic>>(
                                                      future:
                                                          fetchProdCarrinho(),
                                                      builder:
                                                          (BuildContext context,
                                                              AsyncSnapshot
                                                                  snapshot) {
                                                        return GridView.builder(
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 1,
                                                            childAspectRatio: 1,
                                                          ),
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemCount:
                                                              listMenuEstudante
                                                                  .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              child: Card(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12.0),
                                                                ),
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          const BorderRadius
                                                                              .only(
                                                                        topLeft:
                                                                            Radius.circular(12.0),
                                                                        topRight:
                                                                            Radius.circular(12.0),
                                                                      ),
                                                                      child:
                                                                          Container(
                                                                        child: CachedNetworkImage(
                                                                            imageUrl:
                                                                                'https://www.lafiducia.lu/ficheiros/produtos/${listMenuEstudante[index]['imagem'].toString()}',
                                                                            fit:
                                                                                BoxFit.fill,
                                                                            placeholder: (context, url) => Container(height: 160, child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(181, 142, 0, 0.9))))),
                                                                            errorWidget: (context, url, error) => Image.asset('assets/imagem_indisponivel.jpg', fit: BoxFit.fitWidth)),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child: ListTile(
                                                                          title: Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(vertical: 5),
                                                                            child:
                                                                                Text(
                                                                              listMenuEstudante[index]['titulo'],
                                                                              style: const TextStyle(
                                                                                fontFamily: 'Poppins',
                                                                                package: 'awesome_package',
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color.fromRGBO(62, 63, 104, 1),
                                                                                fontSize: 17,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          subtitle: Html(
                                                                            data:
                                                                                """
                                                                ${listMenuEstudante[index]['descricao']} 
                                                                    """,
                                                                            style: {
                                                                              "body": Style(
                                                                                fontFamily: 'Poppins',
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: FontSize(13),
                                                                              ),
                                                                            },
                                                                          )),
                                                                    ),
                                                                    SizedBox(
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.055,
                                                                    ),
                                                                    Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            bottom:
                                                                                10.0),
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.bottomCenter,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.03,
                                                                              ),
                                                                              Text(
                                                                                "${listMenuEstudante[index]['pvp']} €",
                                                                                style: const TextStyle(
                                                                                  fontFamily: 'Poppins',
                                                                                  package: 'awesome_package',
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Color.fromRGBO(62, 63, 104, 1),
                                                                                  fontSize: 15,
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.35,
                                                                              ),
                                                                              new SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.32,
                                                                                height: MediaQuery.of(context).size.width * 0.07,
                                                                                child: OutlinedButton(
                                                                                  onPressed: () {
                                                                                    verifica3(String tele) async {
                                                                                      var response = await http.get(Uri.parse('${ApiDevLafiducia}/verifica-produto3/${tele}/'));

                                                                                      final jsonResponse = json.decode(response.body.toString());

                                                                                      if (response.statusCode == 400 || listProdutosCarrinho!.length == 0) {
                                                                                        Future<http.Response> postProd() async {
                                                                                          var dataProd = {
                                                                                            "id_equipamento": identifier,
                                                                                            "nome": listMenuEstudante[index]['titulo'].toString(),
                                                                                            "foto": listMenuEstudante[index]['imagem'].toString(),
                                                                                            "id_prato": listMenuEstudante[index]['id'].toString(),
                                                                                            "preco": listMenuEstudante[index]['pvp'],
                                                                                            "tipo_encomenda": 'APP',
                                                                                            "id_main": (idMain?[0]['total'] + 1).toString(),
                                                                                            "tipo_produto": 3.toString(),
                                                                                          };

                                                                                          var res = await http.post(Uri.parse('${ApiDevLafiducia}/carrinho-app/'), body: dataProd);

                                                                                          return res;
                                                                                        }

                                                                                        postProd();

                                                                                        Navigator.of(context).push(
                                                                                          MaterialPageRoute(
                                                                                            builder: (context) => Menu(),
                                                                                          ),
                                                                                        );
                                                                                      } else {
                                                                                        verifica1Ou2(String tele) async {
                                                                                          var response = await http.get(Uri.parse('${ApiDevLafiducia}/verifica-produto1e2/${tele}/'));

                                                                                          final jsonResponse = json.decode(response.body.toString());
                                                                                          if (response.statusCode == 200 || listProdutosCarrinho!.length == 0) {
                                                                                            verificaBebidaSobremesas(String tele) async {
                                                                                              var response1 = await http.get(Uri.parse('${ApiDevLafiducia}/sem-bebidas-sobremessas/${tele}/'));

                                                                                              if (response1.statusCode == 200) {
                                                                                                final jsonResponse = json.decode(response1.body.toString());
                                                                                                if (jsonResponse != null) {
                                                                                                  Future<http.Response> postProd() async {
                                                                                                    var dataProd = {
                                                                                                      "id_equipamento": identifier,
                                                                                                      "nome": listMenuEstudante[index]['titulo'].toString(),
                                                                                                      "foto": listMenuEstudante[index]['imagem'].toString(),
                                                                                                      "id_prato": listMenuEstudante[index]['id'].toString(),
                                                                                                      "preco": listMenuEstudante[index]['pvp'],
                                                                                                      "tipo_encomenda": 'APP',
                                                                                                      "id_main": (idMain?[0]['total'] + 1).toString(),
                                                                                                      "tipo_produto": 3.toString(),
                                                                                                    };

                                                                                                    var res = await http.post(Uri.parse('${ApiDevLafiducia}/carrinho-app/'), body: dataProd);

                                                                                                    return res;
                                                                                                  }

                                                                                                  postProd();

                                                                                                  Navigator.of(context).push(
                                                                                                    MaterialPageRoute(
                                                                                                      builder: (context) => Menu(),
                                                                                                    ),
                                                                                                  );
                                                                                                }
                                                                                              } else {
                                                                                                showDialog(
                                                                                                  context: context,
                                                                                                  builder: (BuildContext context) => _buildPopupDialogMenuEstudante(context),
                                                                                                );
                                                                                              }
                                                                                            }

                                                                                            verificaBebidaSobremesas(identifier);
                                                                                          } else {
                                                                                            showDialog(
                                                                                              context: context,
                                                                                              builder: (BuildContext context) => _buildPopupDialogMenuEstudante(context),
                                                                                            );
                                                                                          }
                                                                                        }

                                                                                        verifica1Ou2(identifier);
                                                                                      }
                                                                                    }

                                                                                    verifica3(identifier);
                                                                                  },
                                                                                  child: const Text('AJOUTER', style: TextStyle(fontFamily: 'Poppins', package: 'awesome_package', fontWeight: FontWeight.w400, color: Colors.white, fontSize: 15)),
                                                                                  style: ButtonStyle(
                                                                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(4.0),
                                                                                    )),
                                                                                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(181, 142, 0, 0.9)),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.height * 0.02,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ))
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }),
                                            ))
                                      ],
                                    ));
                              });
                        });
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromRGBO(181, 142, 0, 0.9))));
                  }
                }),
          ],
        ));
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
                          " Il y a un menu dans le panier, il n'est pas possible d'ajouter le menu étudiant.",
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
