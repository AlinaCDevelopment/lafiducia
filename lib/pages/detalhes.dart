import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:la_fiducia/pages/boissons.dart';
import 'package:la_fiducia/pages/desserts.dart';
import 'package:la_fiducia/pages/home.dart';
import 'package:la_fiducia/widgets/buildBarra.dart';
import 'package:la_fiducia/pages/categoria.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:la_fiducia/widgets/build_botao.dart';
import 'package:la_fiducia/carro/cart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math';
import 'package:la_fiducia/pages/quantityButton.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_fiducia/pages/constants.dart';
import 'dart:ui';

class Detalhes extends StatefulWidget {
  final String titleappbar;
  final int idcategoria;
  final int minValue;
  final int maxValue;
  final int idCategoriaAserio;

  final ValueChanged<int> onChanged;

  const Detalhes({
    Key? key,
    required this.idCategoriaAserio,
    required this.idcategoria,
    required this.titleappbar,
    this.minValue = 0,
    this.maxValue = 4,
    required this.onChanged,
  }) : super(key: key);
//super is used to call the constructor of the base class which is the StatefulWidget here
  @override
  _DetalhesState createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {
  final P0 = 0;
  int counter = 0;
  int presunto = 0;
  String identifier = '';
  var tamanhoEscolhido;

  List numberOfItems = [];
  List precoDosIngredientes = [
    2.5,
    3,
    0.3,
    1,
    2,
    2,
    2,
    0.7,
    3.5,
    1.5,
    5,
    2,
    2,
    4.5,
    5,
    5,
    2.5,
    5,
    2,
    3,
    1.5,
    1.2,
    1,
    0.7,
    2,
    1.5,
    2.5,
    2.5,
    2,
    2,
    5,
    1.3,
    5,
    3,
    1.7,
    2.5,
    5,
    3,
    5,
    1.7,
    3,
    4.5
  ];

  late var precoFinal = listProdutoDetalhe?[0]['pvp'] ?? 0;
  double prexxoTotalissimo = 0;
  Widget _incrementButton(int index) {
    return Container(
        width: 26.0,
        child: OutlinedButton(
          onPressed: () {
            if (numberOfItems[index] < 4) {
              setState(() {
                numberOfItems[index]++;
                melon = numberOfItems[index];

                prexoIngredientes = numberOfItems[index].toDouble() *
                    precoDosIngredientes[index].toDouble();
                prexxoTotalissimo =
                    (precoFinal.toDouble() + prexoIngredientes.toDouble());
              });
              teste2 =
                  teste2.toDouble() + precoDosIngredientes[index].toDouble();
            }
          },
          child: Icon(Icons.add, color: Colors.black54, size: 21),
          style: OutlinedButton.styleFrom(
              shape: CircleBorder(), padding: EdgeInsets.only(right: 0)),
        ));
  }

  var melon = 0;
  double teste2 = 0;

  Widget _decrementButton(int index) {
    return Container(
        width: 26.0,
        child: OutlinedButton(
          child: new Icon(const IconData(0xe516, fontFamily: 'MaterialIcons'),
              color: Colors.black54, size: 21),
          onPressed: () {
            if (numberOfItems[index] > 0) {
              setState(() {
                melon = 0;
                numberOfItems[index]--;
                melon = numberOfItems[index];

                prexoIngredientes = numberOfItems[index].toDouble() *
                    precoDosIngredientes[index].toDouble();
              });
              teste2 =
                  teste2.toDouble() - precoDosIngredientes[index].toDouble();
            }
          },
          style: OutlinedButton.styleFrom(
              shape: CircleBorder(), padding: EdgeInsets.only(right: 0)),
        ));
  }

  /*Future<http.Response> genearalRequest() async {
    var data = {
      "id_equipamento": identifier,
      "nome": listProdutoDetalhe[0]['titulo'],
      "foto": listProdutoDetalhe[0]['imagem'],
      "id_prato": listProdutoDetalhe[0]['id'].toStringAsFixed(2),
      "preco": precoFinal.toStringAsFixed(2),
      "preco_total": precoFinal.toString(),
    };

    var res = await http.post(Uri.parse('${ApiDevLafiducia}/carrinho-app/'),
        body: data);


    Map<String, dynamic> idDaResposta =
        new Map<String, dynamic>.from(json.decode(res.body));

    print(idDaResposta['id'].toString());

    return res;

  }*/

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

  List<String> items = [];

  List<String> originalItems = List<String>.generate(42, (i) => "Item $i");
  int perPage = 42;
  int present = 0;
  List<Map<dynamic, dynamic>> lists = [];
  List<Map<dynamic, dynamic>> lists2 = [];

  var retrievedName;
  String limite = '';
  var Valuez;
  var teste = 0;

  @override
  void initState() {
    fetchidMain();
    fetchFerias();
    fetchFolga();
    super.initState();
    addItems();
  }

  void addItems() {
    List.generate(42, (i) {
      numberOfItems.add(quantidadeIngredientes);
    });
  }

  late List listPrecos;
  Future<List<dynamic>> fetchPreco() async {
    final response = await http
        .get(Uri.parse('${ApiDevLafiducia}/produtos/${widget.idcategoria}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listPrecos = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  late List listResponse;
  Future<List<dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('${ApiDevLafiducia}/categorias'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listResponse = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

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

  List? listProdutoDetalhe;
  Future<List<dynamic>> fetchDetalhe() async {
    final response = await http
        .get(Uri.parse('${ApiDevLafiducia}/produtos/${widget.idcategoria}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listProdutoDetalhe = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  List? listIngredientes;
  Future<List<dynamic>> fetchIngredientes() async {
    final response =
        await http.get(Uri.parse('${ApiDevLafiducia}/ingredientes'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listIngredientes = json.decode(response.body);
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

  /*var counter = NumericStepButton.counter;*/
  var _locations = ['PETTIT', 'GRAND'];

  var _selectedLocation = 'GRAND';
  var isVisible = true;
  var idUnico;

  bool _value = false;
  late int val = 1;

  @override
  Widget build(BuildContext context) {
    var pixelRatio = window.devicePixelRatio;

    //Size in physical pixels
    var physicalScreenSize = window.physicalSize;
    var physicalHeight = physicalScreenSize.height;
    fetchidMain();
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
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
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
            titleSpacing: 0,
            leadingWidth: 60,
            centerTitle: true,
            title: Text(
              widget.titleappbar.toUpperCase(),
              style: TextStyle(
                color: Color.fromRGBO(45, 61, 75, 1),
                fontFamily: 'Poppins',
                package: 'awesome_package',
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
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
          bottomNavigationBar: FutureBuilder<List<dynamic>>(
              future: fetchDetalhe(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return new ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        color: Color.fromRGBO(45, 61, 75, 1),
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 1,
                        child: FutureBuilder<List<dynamic>>(
                          future: fetchDetalhe(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            precoFinal = listProdutoDetalhe?[0]['pvp'] + teste2;
                            if (val == 2)
                              precoFinal =
                                  listProdutoDetalhe?[0]['pvp2'] + teste2;
                            print(teste2);
                            return Row(
                              children: <Widget>[
                                /*if (prexxoTotalissimo != 0)
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${(prexxoTotalissimo.toDouble()).toStringAsFixed(2)} €",
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        package: 'awesome_package',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                if (prexxoTotalissimo == 0)*/
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${precoFinal.toStringAsFixed(2)} €",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  alignment: Alignment.center,
                                  child: Container(
                                      height: 20,
                                      child: VerticalDivider(
                                        thickness: 2,
                                        color: Colors.white,
                                      )),
                                ),
                                Row(
                                  children: [
                                    if (FechadoFerias == 200 &&
                                        FechadoFolga == 200)
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        alignment: Alignment.center,
                                        child: OutlinedButton(
                                          onPressed: () async {
                                            verifica3(String tele) async {
                                              var response = await http.get(
                                                  Uri.parse(
                                                      '${ApiDevLafiducia}/verifica-produto3/${tele}/'));

                                              final jsonResponse = json.decode(
                                                  response.body.toString());

                                              if (response.statusCode == 200 ||
                                                  listProdutosCarrinho!
                                                          .length ==
                                                      0) {
                                                Future<http.Response>
                                                    postProd() async {
                                                  var dataProd = {
                                                    "id_equipamento":
                                                        identifier,
                                                    "nome":
                                                        listProdutoDetalhe![0]
                                                            ['titulo'],
                                                    "foto":
                                                        listProdutoDetalhe![0]
                                                            ['imagem'],
                                                    "id_prato":
                                                        listProdutoDetalhe![0]
                                                                ['id']
                                                            .toString(),
                                                    if (val == 1)
                                                      "preco":
                                                          listProdutoDetalhe?[0]
                                                                  ['pvp']
                                                              .toStringAsFixed(
                                                                  2),
                                                    if (val == 2)
                                                      "preco":
                                                          listProdutoDetalhe?[0]
                                                                  ['pvp2']
                                                              .toStringAsFixed(
                                                                  2),
                                                    "preco_total":
                                                        precoFinal.toString(),
                                                    if (val == 1)
                                                      "tamanho": 'GRAND',
                                                    if (val == 2)
                                                      "tamanho": 'PETTIT',
                                                    "tipo_encomenda": 'APP',
                                                    "id_main": (idMain?[0]
                                                                ['total'] +
                                                            1)
                                                        .toString(),
                                                    "tipo_produto":
                                                        2.toString(),
                                                    "id_subcategoria":
                                                        listProdutoDetalhe![
                                                                    index]
                                                                ['subcategoria']
                                                            .toString(),
                                                  };

                                                  var res = await http.post(
                                                      Uri.parse(
                                                          '${ApiDevLafiducia}/carrinho-app/'),
                                                      body: dataProd);

                                                  Map<String, dynamic>
                                                      idDaResposta = new Map<
                                                              String,
                                                              dynamic>.from(
                                                          json.decode(
                                                              res.body));

                                                  for (var i = 0; i < 42; i++) {
                                                    if (numberOfItems[i] > 0) {
                                                      Future<http.Response>
                                                          postIngredientes() async {
                                                        var dataIng = {
                                                          "id_encomenda":
                                                              idDaResposta['id']
                                                                  .toString(),
                                                          "id_equipamento":
                                                              identifier,
                                                          "id_ingrediente":
                                                              listIngredientes![
                                                                      i]['id']
                                                                  .toString(),
                                                          "nome": listIngredientes![
                                                                      i][
                                                                  'ingrediente']
                                                              .toString(),
                                                          "foto":
                                                              listIngredientes![
                                                                          i]
                                                                      ['imagem']
                                                                  .toString(),
                                                          "quantidade":
                                                              numberOfItems[i]
                                                                  .toString(),
                                                          "preco":
                                                              listIngredientes![
                                                                          i]
                                                                      ['preco']
                                                                  .toStringAsFixed(
                                                                      2),
                                                          "id_main": (idMain?[0]
                                                                      [
                                                                      'total'] +
                                                                  1)
                                                              .toString(),
                                                          "id_produto":
                                                              listProdutoDetalhe![
                                                                      0]['id']
                                                                  .toString(),
                                                        };

                                                        var ing = await http.post(
                                                            Uri.parse(
                                                                '${ApiDevLafiducia}/carrinho-ingredientes/'),
                                                            body: dataIng);

                                                        return ing;
                                                      }

                                                      postIngredientes();
                                                    }
                                                  }

                                                  return res;
                                                }

                                                await postProd();

                                                await Navigator
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
                                                          widget.idcategoria,
                                                      titleappbarBoissons:
                                                          widget.titleappbar,
                                                    ),
                                                  ),
                                                  (route) => false,
                                                );
                                              } else {
                                                await showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      _buildPopupDialogMenuEstudante(
                                                          context),
                                                );
                                              }
                                            }

                                            await verifica3(identifier);
                                          },
                                          child: const Text('AJOUTER',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  package: 'awesome_package',
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                  fontSize: 16)),
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            )),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    const Color.fromRGBO(
                                                        181, 142, 0, 0.9)),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    });
              }),
          body: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                    child: FutureBuilder<List<dynamic>>(
                        future: fetchCategoria(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: 1,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  child: Card(
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Wrap(
                                                spacing: 28,
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      GestureDetector(
                                                          onTap: () {},
                                                          child: Image(
                                                            image: AssetImage(
                                                                'assets/plats.png'),
                                                            fit: BoxFit.cover,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.25,
                                                          )),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.245,
                                                        height: MediaQuery.of(
                                                                    context)
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
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          181,
                                                                          142,
                                                                          0,
                                                                          1),
                                                                  fontSize:
                                                                      15)),
                                                          style: OutlinedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.white,
                                                            padding:
                                                                EdgeInsets.zero,
                                                            minimumSize:
                                                                Size(0, 00),
                                                            side: BorderSide(
                                                              width: 1.0,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      181,
                                                                      142,
                                                                      0,
                                                                      0.9),
                                                              style: BorderStyle
                                                                  .solid,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.245,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.055,
                                                        child: OutlinedButton(
                                                          onPressed: () {},
                                                          child: const Text(
                                                              'DESSERTS',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  package:
                                                                      'awesome_package',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          181,
                                                                          142,
                                                                          0,
                                                                          0.9),
                                                                  fontSize:
                                                                      15)),
                                                          style: OutlinedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.white,
                                                            padding:
                                                                EdgeInsets.zero,
                                                            minimumSize:
                                                                Size(0, 00),
                                                            side: BorderSide(
                                                              width: 1.0,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      181,
                                                                      142,
                                                                      0,
                                                                      0.9),
                                                              style: BorderStyle
                                                                  .solid,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12.0),
                                            topRight: Radius.circular(12.0),
                                          ),
                                          child: Container(
                                            child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://www.lafiducia.lu/ficheiros/produtos/${listProdutoDetalhe?[index]['imagem'] ?? 0}',
                                                fit: BoxFit.fill,
                                                placeholder: (context, url) =>
                                                    new CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<Color>(
                                                                Color.fromRGBO(
                                                                    181,
                                                                    142,
                                                                    0,
                                                                    0.9))),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Image.asset(
                                                        'assets/imagem_indisponivel.jpg',
                                                        fit: BoxFit.fitWidth)),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(children: [
                                              SizedBox(
                                                width: 6,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.85,
                                                height: 20,
                                                child: Text(
                                                  listProdutoDetalhe?[0]
                                                          ['titulo'] ??
                                                      0,
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
                                                      0.85,
                                                  height: 45,
                                                  child: Html(
                                                    data: listProdutoDetalhe?[
                                                                index]
                                                            ['descricao'] ??
                                                        0,
                                                    style: {
                                                      "body": Style(
                                                        fontFamily: 'Poppins',
                                                        fontSize:
                                                            FontSize(13.0),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    },
                                                  )),
                                            ]),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        if (listProdutoDetalhe?[index]
                                                ['multiplo_preco'] ==
                                            1)
                                          Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12.0)),
                                              child: Container(
                                                color: Color.fromRGBO(
                                                    102, 118, 131, 1),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              50,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              13,
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.5,
                                                          child: Text(
                                                            "CHOISISSEZ UNE TAILLE",
                                                            textAlign: TextAlign
                                                                .center,
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Poppins',
                                                              package:
                                                                  'awesome_package',
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              80,
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              160,
                                                    ),
                                                    Divider(
                                                      color: Color.fromRGBO(
                                                          190, 190, 190, 1),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              15,
                                                      child: Theme(
                                                        data: ThemeData(
                                                            unselectedWidgetColor:
                                                                Colors.white),
                                                        child: ListTile(
                                                          title: Text(
                                                            "GRAND" +
                                                                '' +
                                                                "- ${(listProdutoDetalhe?[0]['pvp'] ?? 0.toDouble()).toStringAsFixed(2)} €",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Poppins',
                                                              package:
                                                                  'awesome_package',
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          leading: Radio(
                                                            value: 1,
                                                            groupValue: val,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                val = 1;
                                                                precoFinal =
                                                                    listProdutoDetalhe?[
                                                                            0]
                                                                        ['pvp'];
                                                              });
                                                            },
                                                            activeColor:
                                                                Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Divider(
                                                      color: Color.fromRGBO(
                                                          190, 190, 190, 1),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              12.5,
                                                      child: Theme(
                                                        data: ThemeData(
                                                            unselectedWidgetColor:
                                                                Colors.white),
                                                        child: ListTile(
                                                          title: Text(
                                                            "PETTIT" +
                                                                '' +
                                                                "- ${(listProdutoDetalhe?[0]['pvp2'] ?? 0.toDouble()).toStringAsFixed(2)} €",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Poppins',
                                                              package:
                                                                  'awesome_package',
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          leading: Radio(
                                                            value: 2,
                                                            groupValue: val,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                val = 2;

                                                                precoFinal =
                                                                    listProdutoDetalhe?[
                                                                            0][
                                                                        'pvp2'];
                                                              });
                                                            },
                                                            activeColor:
                                                                Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              30,
                                        ),
                                        if (widget.idCategoriaAserio == 3)
                                          Column(
                                            children: [
                                              Container(
                                                child: FutureBuilder<
                                                        List<dynamic>>(
                                                    future: fetchIngredientes(),
                                                    builder:
                                                        (BuildContext context,
                                                            AsyncSnapshot
                                                                snapshot) {
                                                      if (snapshot.hasData) {
                                                        late var precoFinal =
                                                            listProdutoDetalhe?[
                                                                    0]['pvp'] ??
                                                                0;
                                                        prexxoTotalissimo =
                                                            teste2.toDouble() +
                                                                precoFinal
                                                                    .toDouble();
                                                        return ListView.builder(
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemCount: 1,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return ClipRRect(
                                                                child:
                                                                    Container(
                                                                        child: Stack(
                                                                            children: <Widget>[
                                                                      Container(
                                                                          child: FutureBuilder<List<dynamic>>(
                                                                              future: fetchIngredientes(),
                                                                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                                                return ListView.builder(
                                                                                    shrinkWrap: true,
                                                                                    physics: NeverScrollableScrollPhysics(),
                                                                                    itemCount: numberOfItems.length,
                                                                                    itemBuilder: (BuildContext context, int index) {
                                                                                      return Card(
                                                                                        elevation: 1.0,
                                                                                        child: SizedBox(
                                                                                          width: MediaQuery.of(context).size.width,
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                            children: <Widget>[
                                                                                              SizedBox(
                                                                                                width: 10,
                                                                                              ),
                                                                                              CachedNetworkImage(imageUrl: 'https://www.lafiducia.lu//ficheiros/ingredientes/${listIngredientes?[index]['imagem'] ?? 0}', fit: BoxFit.fill, errorWidget: (context, url, error) => Image.asset('assets/imagem_indisponivel.jpg', fit: BoxFit.fitWidth)),
                                                                                              SizedBox(
                                                                                                width: 20,
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: MediaQuery.of(context).size.width / 3,
                                                                                                child: Column(
                                                                                                  children: [
                                                                                                    Align(
                                                                                                      alignment: Alignment.centerLeft,
                                                                                                      child: Text(listIngredientes?[index]['ingrediente'] ?? 0.toString()),
                                                                                                    ),
                                                                                                    Align(
                                                                                                      alignment: Alignment.centerLeft,
                                                                                                      child: Text("${listIngredientes?[index]['preco'] ?? 0.toStringAsFixed(2)} €"),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: MediaQuery.of(context).size.width / 3.8,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                                  children: [
                                                                                                    _decrementButton(index),
                                                                                                    Text(
                                                                                                      '${numberOfItems[index]}',
                                                                                                      style: TextStyle(fontSize: 16.0),
                                                                                                    ),
                                                                                                    _incrementButton(index),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 2,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    });
                                                                              })),
                                                                    ])),
                                                              );
                                                            });
                                                      } else {
                                                        return Container(
                                                          height: 2,
                                                          child: Center(
                                                              child: CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Color.fromRGBO(
                                                                          181,
                                                                          142,
                                                                          0,
                                                                          0.9)))),
                                                        );
                                                      }
                                                    }),
                                                color: Colors.white,
                                                width: 1000.0,
                                                height: physicalHeight / 0.78,
                                              ),
                                            ],
                                          )
                                      ],
                                    ),
                                    elevation: 0,
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color.fromRGBO(181, 142, 0, 0.9))));
                          }
                        })),
              ),
            ],
          ),
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
