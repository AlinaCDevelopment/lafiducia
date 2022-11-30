import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:la_fiducia/pages/constants.dart';

var prexoIngredientes = 0.0;

class Ing extends StatefulWidget {
  final String title;
  final int idcategoria;
  final num precoFinal;
  final num idProduto;
  final String nomeProduto;
  final String imagemProduto;
  final num precoProduto;

  Ing(
      {required this.title,
      required this.idcategoria,
      required this.precoFinal,
      required this.idProduto,
      required this.nomeProduto,
      required this.imagemProduto,
      required this.precoProduto,
      Key? key})
      : super(key: key);
  @override
  _IngState createState() => _IngState();
}

var quantidadeIngredientes = 0;
List<Map<dynamic, dynamic>> lists = [];

class _IngState extends State<Ing> {
  TextEditingController _controller = TextEditingController();
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
//For demonstrate purpose I have added five static items
  void addItems() {
    List.generate(42, (i) {
      numberOfItems.add(quantidadeIngredientes);
    });
  }

  @override
  void initState() {
    super.initState();
    addItems();
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

  late List listProdutoDetalhe;
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

  String identifier = '';
  var retrievedName;
  var Valuez;
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

  var teste = 0;
  var i = 0;

  Widget _incrementButton(int index) {
    return FloatingActionButton(
      child: Icon(Icons.add, color: Colors.black87),
      backgroundColor: Colors.white,
      onPressed: () {
        if (numberOfItems[index] < 4) {
          setState(() {
            numberOfItems[index]++;
            melon = numberOfItems[index];

            prexoIngredientes = numberOfItems[index].toDouble() *
                precoDosIngredientes[index].toDouble();
            prexxoTotalissimo =
                (widget.precoFinal.toDouble() + prexoIngredientes.toDouble());
          });
          teste2 = teste2.toDouble() + precoDosIngredientes[index].toDouble();
        }
      },
    );
  }

  var melon = 0;
  double teste2 = 0;

  Widget _decrementButton(int index) {
    return FloatingActionButton(
        onPressed: () {
          if (numberOfItems[index] > 0) {
            setState(() {
              melon = 0;
              numberOfItems[index]--;
              melon = numberOfItems[index];

              prexoIngredientes = numberOfItems[index].toDouble() *
                  precoDosIngredientes[index].toDouble();
            });
            teste2 = teste2.toDouble() - precoDosIngredientes[index].toDouble();
          }
        },
        child: new Icon(const IconData(0xe516, fontFamily: 'MaterialIcons'),
            color: Colors.black),
        backgroundColor: Colors.white);
  }

  double prexxoTotalissimo = 0;
  @override
  Widget build(BuildContext context) {
    prexxoTotalissimo = teste2.toDouble() + widget.precoFinal.toDouble();
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
            'Ingredientes',
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
          actions: <Widget>[],
        ),
        bottomNavigationBar: SizedBox(),
        body: FutureBuilder<List<dynamic>>(
            future: fetchIngredientes(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return ListView.builder(
                  itemCount: numberOfItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 1.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            CachedNetworkImage(
                                imageUrl:
                                    'https://www.lafiducia.lu//ficheiros/ingredientes/${listIngredientes?[index]['imagem']}',
                                fit: BoxFit.fill,
                                placeholder: (context, url) =>
                                    new CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            Color.fromRGBO(181, 142, 0, 0.9))),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                        'assets/imagem_indisponivel.jpg',
                                        fit: BoxFit.fitWidth)),
                            Column(
                              children: [
                                Text(listIngredientes?[index]['ingrediente']),
                                Text(listIngredientes?[index]['preco']
                                    .toStringAsFixed(2)),
                              ],
                            ),
                            _decrementButton(index),
                            Text(
                              '${numberOfItems[index]}',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            _incrementButton(index),
                          ],
                        ),
                      ),
                    );
                  });
            }));
  }
}
