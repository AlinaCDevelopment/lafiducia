import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:la_fiducia/pages/detalhes.dart';
import 'package:la_fiducia/pages/boissons.dart';
import 'package:la_fiducia/carro/cart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:la_fiducia/pages/menu.dart';
import 'package:la_fiducia/pages/constants.dart';
import 'dart:convert';
import 'package:http/http.dart';

class Categoria extends StatefulWidget {
  final String titleappbar;
  final int idcategoria;
  final int idCategoriaAserio;
  const Categoria(
      {Key? key,
      required this.idcategoria,
      required this.titleappbar,
      required this.idCategoriaAserio})
      : super(key: key);
//super is used to call the constructor of the base class which is the StatefulWidget here
  @override
  _CategoriaState createState() => _CategoriaState();
}

class _CategoriaState extends State<Categoria> {
  @override
  void initState() {
    fetchData();
    fetchCategoria();
    fetchidMain();
    fetchFerias();
    fetchFolga();
    super.initState();
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

  /* late List listProdutos;
  Future<List<dynamic>> fetchCategoria() async {
    http.Response response;
    response = await http.get(Uri.parse(
        'https://dev.lafiducia.lu/produtos-categorias/${widget.idcategoria}'));
    /*if (response.statusCode == 200) {
      setState(() {
        listResponse = json.decode(response.body);
      });
    }*/
    return listProdutos = json.decode(response.body);
  }*/
  late List listProdutos;
  Future<List<dynamic>> fetchCategoria() async {
    final response = await http.get(Uri.parse(
        '${ApiDevLafiducia}/produtos-categorias/${widget.idcategoria}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listProdutos = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  late List listIngredientes;
  Future<List> fetchIngredientes() async {
    http.Response response;
    response = await http.get(Uri.parse('${ApiDevLafiducia}/ingredientes'));

    return listIngredientes = json.decode(response.body);
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

  List<Map<dynamic, dynamic>> lists = [];
  List<Map<dynamic, dynamic>> lists2 = [];

  var retrievedName;
  String identifier = '';
  String limite = '';
  var Valuez;
  var teste = 0;
  var altura;
  @override
  Widget build(BuildContext context) {
    fetchidMain();
    return WillPopScope(
        onWillPop: () async {
          widget.idcategoria;
          widget.idCategoriaAserio;
          widget.titleappbar;
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
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
                          builder: (_) => Menu(),
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
            title: Text(widget.titleappbar.toUpperCase(),
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
          body: FutureBuilder<List<dynamic>>(
              future: fetchCategoria(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if ((snapshot.data[index]['descricao'].length) > 150) {
                        altura = MediaQuery.of(context).size.height / 18;
                      } else
                        altura = MediaQuery.of(context).size.height / 2.2;
                      return Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            height: altura,
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
                                            MediaQuery.of(context).size.height /
                                                3.7,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://www.lafiducia.lu/ficheiros/produtos/${listProdutos[index]['imagem'].toString()}',
                                          fit: BoxFit.fitHeight,
                                          placeholder: (context, url) => Container(
                                              height: 160,
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
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  'assets/imagem_indisponivel.jpg',
                                                  fit: BoxFit.fitWidth),
                                        ),
                                      ),
                                    ),
                                    Column(children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.015,
                                      ),
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
                                            snapshot.data[index]['titulo'],
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
                                      Row(children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.025,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.85,
                                          child: Html(
                                            data: """
                                    ${snapshot.data[index]['descricao']} 
                                   """,
                                            style: {
                                              "body": Style(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                                fontSize: FontSize(13),
                                              ),
                                            },
                                          ),
                                        ),
                                      ]),
                                    ]),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                        ),
                                        Text(
                                          "${snapshot.data[index]['pvp'].toStringAsFixed(2)} €",
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            package: 'awesome_package',
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(62, 63, 104, 1),
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                        ),
                                        if (listProdutos[index]
                                                    ['multiplo_preco'] !=
                                                1 &&
                                            listProdutos[index]
                                                    ['subcategoria'] !=
                                                3)
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.18,
                                          ),
                                        if (listProdutos[index]
                                                    ['multiplo_preco'] ==
                                                1 ||
                                            listProdutos[index]
                                                    ['subcategoria'] ==
                                                3)
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.185,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.07,
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        new Detalhes(
                                                      onChanged:
                                                          (void Function) {},
                                                      idCategoriaAserio: widget
                                                          .idCategoriaAserio,
                                                      idcategoria:
                                                          listProdutos[index]
                                                              ['id'],
                                                      titleappbar:
                                                          listProdutos[index]
                                                                  ['categoria']
                                                              .toString(),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Text('PLUS',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      package:
                                                          'awesome_package',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color.fromRGBO(
                                                          181, 142, 0, 0.9),
                                                      fontSize: 16)),
                                              style: OutlinedButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                minimumSize: Size(0, 00),
                                                side: BorderSide(
                                                  width: 1.0,
                                                  color: Color.fromRGBO(
                                                      181, 142, 0, 0.9),
                                                  style: BorderStyle.solid,
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (widget.idcategoria == 26)
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
                                                if (FechadoFerias == 200 &&
                                                    FechadoFolga == 200)
                                                  OutlinedButton(
                                                    onPressed: () {
                                                      Future<http.Response>
                                                          postProd() async {
                                                        var dataProd = {
                                                          "id_equipamento":
                                                              identifier,
                                                          "nome": listProdutos[
                                                                      index]
                                                                  ['titulo']
                                                              .toString(),
                                                          "foto": listProdutos[
                                                                      index]
                                                                  ['imagem']
                                                              .toString(),
                                                          "id_prato":
                                                              listProdutos[
                                                                          index]
                                                                      ['id']
                                                                  .toString(),
                                                          "preco": listProdutos[
                                                                  index]['pvp']
                                                              .toStringAsFixed(
                                                                  2),
                                                          "tipo_encomenda":
                                                              'APP',
                                                          "id_main": (idMain?[0]
                                                                      [
                                                                      'total'] +
                                                                  1)
                                                              .toString(),
                                                          "tipo_produto":
                                                              2.toString(),
                                                          "id_subcategoria":
                                                              listProdutos[
                                                                          index]
                                                                      [
                                                                      'subcategoria']
                                                                  .toString(),
                                                        };

                                                        var res = await http.post(
                                                            Uri.parse(
                                                                '${ApiDevLafiducia}/carrinho-app/'),
                                                            body: dataProd);

                                                        return res;
                                                      }

                                                      postProd();

                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              Menu(),
                                                        ),
                                                        (route) => false,
                                                      );
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
                                              ],
                                            ),
                                          ),
                                        if (widget.idcategoria == 9)
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
                                                if (FechadoFerias == 200 &&
                                                    FechadoFolga == 200)
                                                  OutlinedButton(
                                                    onPressed: () {
                                                      Future<http.Response>
                                                          postProd() async {
                                                        var dataProd = {
                                                          "id_equipamento":
                                                              identifier,
                                                          "nome": listProdutos[
                                                                      index]
                                                                  ['titulo']
                                                              .toString(),
                                                          "foto": listProdutos[
                                                                      index]
                                                                  ['imagem']
                                                              .toString(),
                                                          "id_prato":
                                                              listProdutos[
                                                                          index]
                                                                      ['id']
                                                                  .toString(),
                                                          "preco": listProdutos[
                                                                  index]['pvp']
                                                              .toStringAsFixed(
                                                                  2),
                                                          "tipo_encomenda":
                                                              'APP',
                                                          "id_main": (idMain?[0]
                                                                      [
                                                                      'total'] +
                                                                  1)
                                                              .toString(),
                                                          "tipo_produto":
                                                              2.toString(),
                                                          "id_subcategoria":
                                                              listProdutos[
                                                                          index]
                                                                      [
                                                                      'subcategoria']
                                                                  .toString(),
                                                        };

                                                        var res = await http.post(
                                                            Uri.parse(
                                                                '${ApiDevLafiducia}/carrinho-app/'),
                                                            body: dataProd);

                                                        return res;
                                                      }

                                                      postProd();
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              Menu(),
                                                        ),
                                                        (route) => false,
                                                      );
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
                                              ],
                                            ),
                                          ),
                                        if ((widget.idcategoria != 26) &&
                                            (widget.idcategoria != 9))
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
                                                if (FechadoFerias == 200 &&
                                                    FechadoFolga == 200)
                                                  OutlinedButton(
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
                                                          Future<http.Response>
                                                              postProd() async {
                                                            var dataProd = {
                                                              "id_equipamento":
                                                                  identifier,
                                                              "nome": listProdutos[
                                                                          index]
                                                                      ['titulo']
                                                                  .toString(),
                                                              "foto": listProdutos[
                                                                          index]
                                                                      ['imagem']
                                                                  .toString(),
                                                              "id_prato":
                                                                  listProdutos[
                                                                              index]
                                                                          ['id']
                                                                      .toString(),
                                                              "preco": listProdutos[
                                                                          index]
                                                                      ['pvp']
                                                                  .toStringAsFixed(
                                                                      2),
                                                              if ((listProdutos[
                                                                          index]
                                                                      [
                                                                      'multiplo_preco'] ==
                                                                  1))
                                                                "tamanho":
                                                                    'GRAND',
                                                              "tipo_encomenda":
                                                                  'APP',
                                                              "id_main": (idMain?[
                                                                              0]
                                                                          [
                                                                          'total'] +
                                                                      1)
                                                                  .toString(),
                                                              "tipo_produto":
                                                                  2.toString(),
                                                              "id_subcategoria":
                                                                  listProdutos[
                                                                              index]
                                                                          [
                                                                          'subcategoria']
                                                                      .toString(),
                                                            };

                                                            var res = await http.post(
                                                                Uri.parse(
                                                                    '${ApiDevLafiducia}/carrinho-app/'),
                                                                body: dataProd);

                                                            return res;
                                                          }

                                                          postProd();

                                                          Navigator
                                                              .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  Boissons(
                                                                idCategoriaAserioBoissons:
                                                                    widget
                                                                        .idCategoriaAserio,
                                                                idcategoriaBoissons:
                                                                    listProdutos[
                                                                            index]
                                                                        ['id'],
                                                                titleappbarBoissons:
                                                                    listProdutos[index]
                                                                            [
                                                                            'categoria']
                                                                        .toString(),
                                                              ),
                                                            ),
                                                            (route) => false,
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
                                              ],
                                            ),
                                          ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ));
                    },
                  );
                } else {
                  return Container(
                      height: 400,
                      child: Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color.fromRGBO(181, 142, 0, 0.9)))));
                }
              }),
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
