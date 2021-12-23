import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:la_fiducia/pages/detalhes.dart';
import 'package:la_fiducia/pages/boissons.dart';
import 'package:la_fiducia/carro/cart.dart';
import 'package:la_fiducia/pages/menu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:math';
import 'package:la_fiducia/pages/constants.dart';

class Desserts extends StatefulWidget {
  final String titleappbarDesserts;
  final int idcategoriaDesserts;
  final int idCategoriaAserioDesserts;

  const Desserts({
    Key? key,
    required this.idCategoriaAserioDesserts,
    required this.idcategoriaDesserts,
    required this.titleappbarDesserts,
  }) : super(key: key);
  @override
  _DessertsState createState() => _DessertsState();
}

class _DessertsState extends State<Desserts> {
  @override
  void initState() {
    fetchData();
    fetchCategoria();
    fetchidMain();
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

  int _current = 0;
  final CarouselController _controller = CarouselController();

  late List listResponse;
  Future<List<dynamic>> fetchData() async {
    http.Response response;
    response = await http.get(Uri.parse('${ApiDevLafiducia}/categorias'));
    /*if (response.statusCode == 200) {
      setState(() {
        listResponse = json.decode(response.body);
      });
    }*/
    return listResponse = json.decode(response.body);
  }

  late List listProdutos;
  Future<List<dynamic>> fetchCategoria() async {
    http.Response response;
    response =
        await http.get(Uri.parse('${ApiDevLafiducia}/produtos-categorias/9'));
    /*if (response.statusCode == 200) {
      setState(() {
        listResponse = json.decode(response.body);
      });
    }*/
    return listProdutos = json.decode(response.body);
  }

  late List listIngredientes;
  Future<List> fetchIngredientes() async {
    http.Response response;
    response = await http.get(Uri.parse('${ApiDevLafiducia}/ingredientes'));

    return listIngredientes = json.decode(response.body);
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

  List<Map<dynamic, dynamic>> lists = [];
  List<Map<dynamic, dynamic>> lists2 = [];
  var retrievedName;
  String identifier = '';
  String limite = '';
  var Valuez;
  var teste = 0;
  @override
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Boissons(
                          idCategoriaAserioBoissons:
                              widget.idCategoriaAserioDesserts,
                          idcategoriaBoissons: widget.idcategoriaDesserts,
                          titleappbarBoissons: widget.titleappbarDesserts),
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
        title: Text('DESSERTS',
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
                                (listProdutosCarrinho?.length ?? 0).toString(),
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
                              builder: (context) => Cart(
                              ),
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
                              builder: (context) => Cart(
                              ),
                            ),
                          );
                      },
                    ),
                  );
                }
              }),
        ],
      ),
      bottomNavigationBar: Container(
        color: Color.fromRGBO(45, 61, 75, 1),
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.width * 1,
        child: FutureBuilder<List<dynamic>>(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  alignment: Alignment.center,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Menu(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text('SUIVANT',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 16)),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      )),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(181, 142, 0, 0.9)),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
          future: fetchCategoria(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        height: MediaQuery.of(context).size.height *
                            listProdutos.length /
                            2,
                        child: Card(
                            elevation: 0,
                            color: Color.fromRGBO(235, 235, 235, 1),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Wrap(
                                          spacing: 28,
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.245,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.055,
                                                  child: OutlinedButton(
                                                    onPressed: () {},
                                                    child: const Text('PLATS',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            package:
                                                                'awesome_package',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Color.fromRGBO(
                                                                    181,
                                                                    142,
                                                                    0,
                                                                    1),
                                                            fontSize: 15)),
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.white,
                                                      padding: EdgeInsets.zero,
                                                      minimumSize: Size(0, 00),
                                                      side: BorderSide(
                                                        width: 1.0,
                                                        color: Color.fromRGBO(
                                                            181, 142, 0, 0.9),
                                                        style:
                                                            BorderStyle.solid,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.245,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.055,
                                                  child: OutlinedButton(
                                                    onPressed: () {},
                                                    child: const Text(
                                                        'BOISSONS',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            package:
                                                                'awesome_package',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Color.fromRGBO(
                                                                    181,
                                                                    142,
                                                                    0,
                                                                    0.9),
                                                            fontSize: 15)),
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.white,
                                                      padding: EdgeInsets.zero,
                                                      minimumSize: Size(0, 00),
                                                      side: BorderSide(
                                                        width: 1.0,
                                                        color: Color.fromRGBO(
                                                            181, 142, 0, 0.9),
                                                        style:
                                                            BorderStyle.solid,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: <Widget>[
                                                GestureDetector(
                                                    onTap: () {},
                                                    child: Image(
                                                      image: AssetImage(
                                                          'assets/desserts.png'),
                                                      fit: BoxFit.cover,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.25,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      childAspectRatio: 1,
                                    ),
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(12.0),
                                                  topRight:
                                                      Radius.circular(12.0),
                                                ),
                                                child: Container(
                                                  child: CachedNetworkImage(
                                                      imageUrl:
                                                          'https://www.lafiducia.lu/ficheiros/produtos/${listProdutos[index]['imagem'].toString()}',
                                                      fit: BoxFit.fill,
                                                      placeholder: (context, url) => Container(
                                                          height: 160,
                                                          child: Center(
                                                              child: CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                      Color.fromRGBO(
                                                                          181,
                                                                          142,
                                                                          0,
                                                                          0.9))))),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                              'assets/imagem_indisponivel.jpg',
                                                              fit: BoxFit.fitWidth)),
                                                ),
                                              ),
                                              Container(
                                                height: 100,
                                                child: ListTile(
                                                    title: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                        listProdutos[index]
                                                            ['titulo'],
                                                        style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          package:
                                                              'awesome_package',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromRGBO(
                                                              62, 63, 104, 1),
                                                          fontSize: 17,
                                                        ),
                                                      ),
                                                    ),
                                                    subtitle: Html(
                                                      data: """
                                      ${listProdutos[index]['descricao']} 
                                     """,
                                                      style: {
                                                        "body": Style(
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize:
                                                              FontSize(13),
                                                        ),
                                                      },
                                                    )),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03,
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10.0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          "${listProdutos[index]['pvp'].toStringAsFixed(2)} €",
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            package:
                                                                'awesome_package',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromRGBO(
                                                                    62,
                                                                    63,
                                                                    104,
                                                                    1),
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.35,
                                                        ),
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
                                                          child: OutlinedButton(
                                                            onPressed: () {
                                                              Future<http.Response>
                                                                  postProd() async {
                                                                var dataProd = {
                                                                  "id_equipamento":
                                                                      identifier,
                                                                  "nome": listProdutos[
                                                                              index]
                                                                          [
                                                                          'titulo']
                                                                      .toString(),
                                                                  "foto": listProdutos[
                                                                              index]
                                                                          [
                                                                          'imagem']
                                                                      .toString(),
                                                                  "id_prato": listProdutos[
                                                                              index]
                                                                          ['id']
                                                                      .toString(),
                                                                  "preco": listProdutos[
                                                                              index]
                                                                          [
                                                                          'pvp']
                                                                      .toStringAsFixed(
                                                                          2),
                                                                  "tipo_encomenda":
                                                                      'APP',
                                                                  "tipo_produto":
                                                                      2.toString(),
                                                                  "id_main":
                                                                      (idMain?[0]['total'] +
                                                                              1)
                                                                          .toString(),
                                                                  "id_subcategoria":
                                                                      listProdutos[index]
                                                                              [
                                                                              'subcategoria']
                                                                          .toString(),
                                                                };

                                                                var res = await http.post(
                                                                    Uri.parse(
                                                                        '${ApiDevLafiducia}/carrinho-app/'),
                                                                    body:
                                                                        dataProd);

                                                                return res;
                                                              }

                                                              postProd();

                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Menu()),
                                                              );
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
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                        ),
                                                      ],
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            )));
                  });
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromRGBO(181, 142, 0, 0.9))));
            }
          }),
    );
  }
}
