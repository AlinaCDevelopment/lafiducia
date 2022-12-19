/*import 'dart:ffi';*/
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:la_fiducia/pages/categoria.dart';
import 'package:la_fiducia/pages/desserts.dart';
import 'package:la_fiducia/carro/cart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:la_fiducia/pages/constants.dart';

class Boissons extends StatefulWidget {
  final String titleappbarBoissons;
  final int idcategoriaBoissons;
  final int idCategoriaAserioBoissons;

  const Boissons({
    Key? key,
    required this.idCategoriaAserioBoissons,
    required this.idcategoriaBoissons,
    required this.titleappbarBoissons,
  }) : super(key: key);
  @override
  _BoissonsState createState() => _BoissonsState();
}

class _BoissonsState extends State<Boissons> {
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

  List? idMain;
  Future<List<dynamic>?> fetchidMain() async {
    final response = await http
        .get(Uri.parse('${ApiDevLafiducia}/contar-encomenda/${identifier}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      try {
        return idMain = json.decode(response.body);
      } catch (e) {
        return null;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
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

  late List listProdutos;
  Future<List<dynamic>?> fetchCategoria() async {
    http.Response response;
    response =
        await http.get(Uri.parse('${ApiDevLafiducia}/produtos-categorias/26'));
    /*if (response.statusCode == 200) {
      setState(() {
        listResponse = json.decode(response.body);
      });
    }*/
    try {
      return listProdutos = json.decode(response.body);
    } catch (e) {
      return null;
    }
  }

  late List listIngredientes;
  Future<List> fetchIngredientes() async {
    http.Response response;
    response = await http.get(Uri.parse('${ApiDevLafiducia}/ingredientes'));

    return listIngredientes = json.decode(response.body);
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
    return WillPopScope(
        onWillPop: () async => false,
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
                            builder: (_) => Categoria(
                              idCategoriaAserio:
                                  widget.idCategoriaAserioBoissons,
                              idcategoria: widget.idCategoriaAserioBoissons,
                              titleappbar: widget.titleappbarBoissons,
                            ),
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
              title: Text('BOISSONS',
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
                          padding:
                              const EdgeInsets.only(right: 12.0, top: 30.0),
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
                          padding:
                              const EdgeInsets.only(right: 12.0, top: 30.0),
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
//============================================================================================================
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Desserts(
                                    idCategoriaAserioDesserts:
                                        widget.idCategoriaAserioBoissons,
                                    idcategoriaDesserts:
                                        widget.idcategoriaBoissons,
                                    titleappbarDesserts:
                                        widget.titleappbarBoissons,
                                  ),
                                ));
                          },
                          child: const Text('SUIVANT',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontSize: 16)),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
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
//============================================================================================================
            body: FutureBuilder<List<dynamic>?>(
                future: fetchCategoria(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Wrap(
                                spacing: 28,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.245,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.055,
                                        child: OutlinedButton(
                                          onPressed: null,
                                          child: const Text('PLATS',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  package: 'awesome_package',
                                                  fontWeight: FontWeight.w400,
                                                  color: Color.fromRGBO(
                                                      181, 142, 0, 1),
                                                  fontSize: 15)),
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.white,
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
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      GestureDetector(
                                          onTap: () {},
                                          child: Image(
                                            image: AssetImage(
                                                'assets/boissons.png'),
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                          )),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.245,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.055,
                                        child: OutlinedButton(
                                          onPressed: null,
                                          child: const Text('DESSERTS',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  package: 'awesome_package',
                                                  fontWeight: FontWeight.w400,
                                                  color: Color.fromRGBO(
                                                      181, 142, 0, 0.9),
                                                  fontSize: 15)),
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.white,
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //==================================================================================================
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final obj = listProdutos[index];
                              print(obj);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                              ),
                                              child: Image.network(
                                                'https://www.lafiducia.lu/ficheiros/produtos/${listProdutos[index]['imagem']}',
                                                fit: BoxFit.fill,
                                                loadingBuilder: (context, child,
                                                        loadingProgress) =>
                                                    (loadingProgress == null)
                                                        ? child
                                                        : Center(
                                                            child: CircularProgressIndicator(
                                                                valueColor: AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    Color.fromRGBO(
                                                                        181,
                                                                        142,
                                                                        0,
                                                                        0.9)))),
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Image.asset(
                                                        'assets/imagem_indisponivel.jpg'),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
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
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  if (listProdutos[index]
                                                              ['descricao'] !=
                                                          null &&
                                                      listProdutos[index]
                                                              ['descricao']
                                                          .toString()
                                                          .isNotEmpty)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Text(
                                                        listProdutos[index]
                                                            ['descricao'],
                                                        style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          package:
                                                              'awesome_package',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromRGBO(
                                                              62, 63, 104, 1),
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${listProdutos[index]['pvp'].toStringAsFixed(2)} €",
                                                        style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          package:
                                                              'awesome_package',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromRGBO(
                                                              62, 63, 104, 1),
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      OutlinedButton(
                                                        onPressed: () async {
                                                          await postProd(index);

                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Desserts(
                                                                          idCategoriaAserioDesserts:
                                                                              widget.idCategoriaAserioBoissons,
                                                                          idcategoriaDesserts:
                                                                              widget.idcategoriaBoissons,
                                                                          titleappbarDesserts:
                                                                              widget.titleappbarBoissons,
                                                                        )),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      10),
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
                                                                      13)),
                                                        ),
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
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromRGBO(181, 142, 0, 0.9))));
                  }
                })
                )
                );
  }

  Future<http.Response> postProd(int index) async {
    var dataProd = {
      "id_equipamento": identifier,
      "nome": listProdutos[index]['titulo'].toString(),
      "foto": listProdutos[index]['imagem'].toString(),
      "id_prato": listProdutos[index]['id'].toString(),
      "preco": listProdutos[index]['pvp'].toStringAsFixed(2),
      "tipo_encomenda": 'APP',
      "tipo_produto": 2.toString(),
      "id_main": (idMain?[0]['total'] + 1).toString(),
      "id_subcategoria": listProdutos[index]['subcategoria'].toString(),
    };

    var res = await http.post(Uri.parse('${ApiDevLafiducia}/carrinho-app/'),
        body: dataProd);

    return res;
  }
}
