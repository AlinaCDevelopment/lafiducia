import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:la_fiducia/pages/menu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:la_fiducia/pages/constants.dart';
import 'package:la_fiducia/pages/checkOut.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:la_fiducia/login/login_page.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<Map<dynamic, dynamic>> lists = [];
  List<Map<dynamic, dynamic>> lists2 = [];
  List<Map<dynamic, dynamic>> lists3 = [];
  List<Map<dynamic, dynamic>> sobremesas = [];
  List<Map<dynamic, dynamic>> imgsIng = [];
  final plugin = FacebookLogin(debug: true);
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

  @override
  void initState() {
    getToken();
    fetchVerificacaoMenuEstudante();
    super.initState();
  }

  var checkOpen = '';
  List? verifica_menu_estudante_aberto;
  Future<List<dynamic>?> fetchVerificacaoMenuEstudante() async {
    final response =
        await http.get(Uri.parse('${ApiDevLafiducia}/bloquear-botao/'));

    if (response.statusCode == 200) {
      setState(() {
        checkOpen = 'aberto';
      });
      try {
        return verifica_menu_estudante_aberto = json.decode(response.body);
      } catch (e) {
        return null;
      }
    } else {
      setState(() {
        checkOpen = 'fechado';
      });
      return null;
    }
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

  List? listTotalProdIngCarrinho;
  Future<List<dynamic>?> fetchTotalProdIngCarrinho() async {
    final response = await http
        .get(Uri.parse('${ApiDevLafiducia}/total-carrinho/${identifier}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      try {
        return listTotalProdIngCarrinho = json.decode(response.body);
      } catch (e) {
        return null;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future<http.Response> deleteProd(String id) async {
    final http.Response response = await http.delete(
      Uri.parse('${ApiDevLafiducia}/encomendas-app/$id'),
    );

    return response;
  }

  Future<http.Response> deleteIng(String id) async {
    final http.Response response = await http.delete(
      Uri.parse('${ApiDevLafiducia}/encomendas-ingredientes/$id'),
    );

    return response;
  }

  List listProdutoDetalhe = [];
  Future<List<dynamic>> fetchDetalhe() async {
    http.Response response;
    response = await http.get(Uri.parse('${ApiDevLafiducia}/produtos/26'));
    if (response.statusCode == 200) {
      setState(() {
        listProdutoDetalhe = json.decode(response.body);
      });
    }
    return listProdutoDetalhe = json.decode(response.body);
  }

  late List listProdutos;
  Future<List<dynamic>?> fetchProdutos() async {
    final response = await http.get(Uri.parse('${ApiDevLafiducia}/produtos/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      try {
        return listProdutos = json.decode(response.body);
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  List listIngredientes = [];
  Future<List<dynamic>?> fetchIngredientes() async {
    final response =
        await http.get(Uri.parse('${ApiDevLafiducia}/ingredientes'));

    try {
      return listIngredientes = json.decode(response.body);
    } catch (e) {
      return null;
    }
  }

  List? listHora;
  Future<List<dynamic>> fetchHora() async {
    final response =
        await http.get(Uri.parse('${ApiDevLafiducia}/horas-encomendas'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listHora = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return listHora = [
        "00:00",
        "18:00",
        "18:15",
        "18:30",
        "18:45",
        "19:00",
        "19:15",
        "19:30",
        "19:45",
        "20:00",
        "20:15",
        "20:30",
        "20:45",
        "21:00",
        "21:15",
        "21:30"
      ];
    }
  }

  var idUnico;
  List<Map<dynamic, dynamic>> listUnico = [];
  var retrievedName;
  var Valuez;
  var Valuez2;
  var i = 0;
  late var valorFinal = '';
  var teste = 0;
  double totlez = 0;
  double totlezIng = 0;
  var precoIngInd;
  late String idEncomenda = '';
  var parts2;

  String token = '';

  Future getToken() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      token = (prefs.getString("token") ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (i == 0) {
      fetchVerificacaoMenuEstudante();
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

    return WillPopScope(
        onWillPop: () async {
          valorFinal = '';
          lists2 = [];
          lists = [];
          return false;
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
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => Menu()),
                          (Route<dynamic> route) => false);
                    },
                  ),
                );
              },
            ),

            titleSpacing: 0,
            leadingWidth: 60,
            centerTitle: true,
            title: Text('Panier',
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
          body: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                FutureBuilder(
                    future: fetchProdCarrinho(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (teste == 0) {
                        _deviceDetails();
                        teste++;
                      }

                      if (snapshot.hasData) {
                        if ((listProdutosCarrinho?.length ?? 0) > 0) {
                          return new ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: listProdutosCarrinho?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(children: [
                                  Card(
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Row(children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                            ),
                                            /*Text(idEncomenda.toString()),*/
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: SizedBox(
                                                    width: MediaQuery.of(context).size.width *
                                                        0.23,
                                                    height: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.065,
                                                    child: CachedNetworkImage(
                                                        imageUrl:
                                                            'https://www.lafiducia.lu/ficheiros/produtos/${listProdutosCarrinho?[index]['foto'] ?? 0}',
                                                        fit: BoxFit.fill,
                                                        placeholder: (context, url) =>
                                                            new CircularProgressIndicator(
                                                                valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(
                                                                    181, 142, 0, 0.9))),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset('assets/imagem_indisponivel.jpg', fit: BoxFit.fitWidth))),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02,
                                            ),
                                            Column(children: [
                                              if ((listProdutosCarrinho?[index]
                                                          ['tamanho'] ??
                                                      0) ==
                                                  0)
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.56,
                                                  child: Text(
                                                    (listProdutosCarrinho?[
                                                                    index]
                                                                ['nome'] ??
                                                            0)
                                                        .toUpperCase()
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      package:
                                                          'awesome_package',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              if ((listProdutosCarrinho?[index]
                                                          ['tamanho'] ??
                                                      0) !=
                                                  0)
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.56,
                                                  child: Text(
                                                    (listProdutosCarrinho?[
                                                                        index]
                                                                    ['nome'] ??
                                                                0)
                                                            .toUpperCase() +
                                                        ' ' +
                                                        '-' +
                                                        ' ' +
                                                        (listProdutosCarrinho?[
                                                                        index][
                                                                    'tamanho'] ??
                                                                0)
                                                            .toString(),
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      package:
                                                          'awesome_package',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.005,
                                              ),
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.56,
                                                  child: Text(
                                                    "${listProdutosCarrinho?[index]['preco'] ?? 0} €",
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      package:
                                                          'awesome_package',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  )),
                                            ]),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.08,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.08,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                    child: Material(
                                                      color: Color.fromRGBO(
                                                          181, 142, 0, 0.9),
                                                      child: InkWell(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          child: Icon(
                                                              Icons.delete,
                                                              size: 20.0,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        onTap: () {
                                                          deleteProd(
                                                              (listProdutosCarrinho?[
                                                                              index]
                                                                          [
                                                                          'id'] ??
                                                                      0)
                                                                  .toString());
                                                          deleteIng((listProdutosCarrinho?[
                                                                          index]
                                                                      ['id'] ??
                                                                  0)
                                                              .toString());
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      super
                                                                          .widget));
                                                        },
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          ]),
                                        ),
                                        FutureBuilder(
                                            future: fetchProdCarrinho(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot snapshot) {
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

                                                if (response.statusCode ==
                                                    200) {
                                                  // If the server did return a 200 OK response,
                                                  // then parse the JSON.
                                                  return listIngredientesCarrinho =
                                                      json.decode(
                                                          response.body);
                                                } else {
                                                  // If the server did not return a 200 OK response,
                                                  // then throw an exception.
                                                  throw Exception(
                                                      'Failed to load album');
                                                }
                                              }

                                              return FutureBuilder(
                                                  future: fetchIngCarrinho(),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot snapshot) {
                                                    return new ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            listIngredientesCarrinho
                                                                    ?.length ??
                                                                0,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
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
                                                              children: <
                                                                  Widget>[
                                                                Row(children: [
                                                                  SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.04,
                                                                  ),
                                                                  SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.1,
                                                                      child: CachedNetworkImage(
                                                                          imageUrl:
                                                                              'https://www.lafiducia.lu//ficheiros/ingredientes/${listIngredientesCarrinho?[index]['foto'] ?? 0}',
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          placeholder: (context, url) => new CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(181, 142, 0,
                                                                                  0.9))),
                                                                          errorWidget: (context, url, error) => Image.asset(
                                                                              'assets/imagem_indisponivel.jpg',
                                                                              fit: BoxFit.fitWidth))),
                                                                  SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.04,
                                                                  ),
                                                                  SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.5,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Align(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: Text(
                                                                                '+' + ' ' + (listIngredientesCarrinho?[index]['nome'] ?? 0).toUpperCase().toString(),
                                                                                style: const TextStyle(
                                                                                  fontFamily: 'Poppins',
                                                                                  package: 'awesome_package',
                                                                                  fontWeight: FontWeight.w400,
                                                                                  color: Colors.black,
                                                                                  fontSize: 16,
                                                                                ),
                                                                              )),
                                                                          SizedBox(
                                                                            height:
                                                                                MediaQuery.of(context).size.height * 0.003,
                                                                          ),
                                                                          Align(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: Text(
                                                                                'QUANTITÉ' + ' ' + (listIngredientesCarrinho?[index]['quantidade'] ?? 0).toString(),
                                                                                style: const TextStyle(
                                                                                  fontFamily: 'Poppins',
                                                                                  package: 'awesome_package',
                                                                                  fontWeight: FontWeight.w200,
                                                                                  color: Colors.black,
                                                                                  fontSize: 13,
                                                                                ),
                                                                              )),
                                                                        ],
                                                                      )),
                                                                  SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          7.5),
                                                                  Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        "${precoIngInd.toStringAsFixed(2)} €",
                                                                        style:
                                                                            const TextStyle(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          package:
                                                                              'awesome_package',
                                                                          fontWeight:
                                                                              FontWeight.w300,
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              14,
                                                                        ),
                                                                      )),
                                                                ]),
                                                                SizedBox(
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.02),
                                                              ]);
                                                        });
                                                  });
                                            })
                                      ],
                                    ),
                                  ),
                                ]);
                              });
                        } else {
                          return Center(
                            child: Container(
                                child: Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 3.8,
                                ),
                                Text('Panier Vide',
                                    style: TextStyle(
                                      color: Color.fromRGBO(45, 61, 75, 1),
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    )),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 26,
                                ),
                                Image.asset(
                                  "assets/panier.png",
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                ),
                              ],
                            )),
                          );
                        }
                      } else {
                        return Container(
                            height: MediaQuery.of(context).size.height,
                            child: Center(
                                /*child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color.fromRGBO(181, 142, 0, 0.9)))*/
                                ));
                      }
                    }),
              ]),
          bottomNavigationBar: FutureBuilder(
              future: fetchHora(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return FutureBuilder(
                    future: fetchTotalProdIngCarrinho(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                color: Color.fromRGBO(45, 61, 75, 1),
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width: MediaQuery.of(context).size.width * 1,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${listTotalProdIngCarrinho?[0]['total'] ?? 0.toStringAsFixed(2)} €"
                                            .toString(),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      alignment: Alignment.center,
                                      child: Container(
                                          height: 20,
                                          child: VerticalDivider(
                                            thickness: 2,
                                            color: Colors.white,
                                          )),
                                    ),
                                    FutureBuilder(
                                        future: fetchProdCarrinho(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          return Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            alignment: Alignment.center,
                                            child: OutlinedButton(
                                              onPressed: () {
                                                if (token != '') {
                                                  if (listHora?[0] != "00:00") {
                                                    if (listProdutosCarrinho
                                                            ?.length !=
                                                        0) {
                                                      idEncomenda =
                                                          (listProdutosCarrinho?[
                                                                          index]
                                                                      ['id'] ??
                                                                  0)
                                                              .toString();
                                                      if (listProdutosCarrinho![
                                                                      index][
                                                                  'id_subcategoria'] ==
                                                              '100' &&
                                                          checkOpen ==
                                                              'fechado') {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              _buildPopupDialogMenuEstudanteForaDoras(
                                                                  context),
                                                        );
                                                      } else {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                CheckOut(
                                                              totalCarrinho:
                                                                  "${listTotalProdIngCarrinho?[0]['total'] ?? 0.toStringAsFixed(2)}"
                                                                      .toString(),
                                                              idEncomenda:
                                                                  idEncomenda
                                                                      .toString(),
                                                              idLocalidade:
                                                                  parts2?[0][
                                                                          'localidade'] ??
                                                                      0,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    } else {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            _buildPopupDialogCarroVazio(
                                                                context),
                                                      );
                                                    }
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          _buildPopupDialogSemHoras(
                                                              context),
                                                    );
                                                  }
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        _buildPopupDialogNotLogIn(
                                                            context),
                                                  );
                                                }
                                              },
                                              child: const Text('CONTINUER',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      package:
                                                          'awesome_package',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white,
                                                      fontSize: 16)),
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                )),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        const Color.fromRGBO(
                                                            181, 142, 0, 0.9)),
                                              ),
                                            ),
                                          );
                                        })
                                  ],
                                ));
                          });
                    });
              }),
        ));
  }

  Widget _buildPopupDialogNotLogIn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: new AlertDialog(
        actions: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height / 8,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Column(
                    children: [
                      Text('Compte non démarré',
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(
                                      plugin: plugin,
                                    )),
                          );
                        },
                        child: const Text("Connexion",
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

  Widget _buildPopupDialogSemHoras(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: new AlertDialog(
        actions: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Column(
                    children: [
                      Text("Nous sommes actuellement fermés, revenez demain.",
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Menu()),
                          );
                        },
                        child: const Text("Retourner",
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

  Widget _buildPopupDialogCarroVazio(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: new AlertDialog(
        actions: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height / 8,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Column(
                    children: [
                      Text('Le panier est vide',
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Menu()),
                          );
                        },
                        child: const Text("Ajouter des produits",
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

  Widget _buildPopupDialogMenuEstudanteForaDoras(BuildContext context) {
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
                          'Le menu étudiant dans le panier ne peut être commandé que de 00h00 à 13h30.',
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Cart()),
                          );
                        },
                        child: const Text("Changer de panier",
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
