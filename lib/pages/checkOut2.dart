import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:la_fiducia/services/encomendas.dart';
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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:la_fiducia/pages/checkOut.dart';
import 'package:la_fiducia/pages/checkOut3.dart';
import 'dart:async';

class CheckOut2 extends StatefulWidget {
  final String totalCarrinho;
  final String idEncomenda;
  final String mypagamento;
  final String idLocalidade;
  final String tipoLevantamento;
  final String localite;
  final String adresse2;
  final String codePostal2;
  final String telefone2;
  final hora;
  final String comentarios;

  const CheckOut2({
    Key? key,
    required this.totalCarrinho,
    required this.idEncomenda,
    required this.mypagamento,
    required this.idLocalidade,
    required this.tipoLevantamento,
    required this.localite,
    required this.adresse2,
    required this.codePostal2,
    required this.telefone2,
    required this.hora,
    required this.comentarios,
  }) : super(key: key);
  @override
  _CheckOut2State createState() => _CheckOut2State();
}

class _CheckOut2State extends State<CheckOut2> {
  @override
  void initState() {
    fetchLocalidade();
    _getCitiesList();
    getToken();
    fetchIdLocalidadeID();
    super.initState();
  }

  var teste = 0;
  List hourlist = ['1:00', '2:00', '3:00', '4:00'];

  String? _myHour;
  List pagamentolist = ['Espécies', 'Carte Bancaire'];
  String? _mypagamento;
  List citiesList = [];
  String? _myCity;
  late int val = 1;
  var i = 0;
  String identifier = '';
  String token = '';
  String adrex2 = '';
  String codexpostalex2 = '';
  String telefonex2 = '';
  var parts2;
  String idEncomenda = '';
  var portes;
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

  String cityInfoUrl =
      'http://cleanions.bestweb.my/api/location/get_city_by_state_id';
  Future<String> _getCitiesList() async {
    final response =
        await http.get(Uri.parse('${ApiDevLafiducia}/localidades/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return citiesList = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  List? listTotalProdIngCarrinho;
  Future<List<dynamic>> fetchTotalProdIngCarrinho() async {
    final response = await http
        .get(Uri.parse('${ApiDevLafiducia}/total-carrinho/${identifier}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listTotalProdIngCarrinho = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  List? listLocalidade;
  Future<List<dynamic>> fetchLocalidade() async {
    final response =
        await http.get(Uri.parse('${ApiDevLafiducia}/localidades/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listLocalidade = json.decode(response.body);
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

  List? listProdutos;
  Future<List<dynamic>> fetchProdutos() async {
    final response = await http.get(Uri.parse('${ApiDevLafiducia}/produtos/'));

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

  List listIngredientes = [];
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

  List? listIngredientesCarrinho;
  Future<List<dynamic>> fetchIngCarrinho() async {
    final response = await http.get(Uri.parse(
        '${ApiDevLafiducia}/ingrediente-carrinho/${widget.idEncomenda}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listIngredientesCarrinho = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  List? listIDlocalidadeID;
  Future<List<dynamic>> fetchIdLocalidadeID() async {
    final response = await http
        .get(Uri.parse('${ApiDevLafiducia}/localidade/${widget.idLocalidade}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listIDlocalidadeID = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future getToken() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      token = (prefs.getString("token") ?? "");
    });
  }

  String? idUser;
  bool _isLoading = false;
  bool _isLoading2 = false;
  bool _isLoading3 = false;
  bool _isVisibleButton = true;
  Widget build(BuildContext context) {
    if (i == 0) {
      fetchLocalidade;
      _getCitiesList();
      fetchIdLocalidadeID();
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

    if (widget.adresse2 == '') {
      setState(() {
        adrex2 = parts2?[0]['morada'];
      });
    } else {
      adrex2 = widget.adresse2;
    }
    if (widget.codePostal2 == '') {
      setState(() {
        codexpostalex2 = parts2?[0]['cod_postal'];
      });
    } else {
      setState(() {
        codexpostalex2 = widget.codePostal2;
      });
    }
    if (widget.telefone2 == '') {
      setState(() {
        telefonex2 = parts2?[0]['telefone'];
      });
    } else {
      setState(() {
        telefonex2 = widget.telefone2;
      });
    }

    if (parts2[0]['id'] != null) {
      idUser = parts2[0]['id'].toString();
    } else {
      idUser = parts2[1].toString();
    }

    if (widget.tipoLevantamento == 'LIVRAISON À DOMICILE') {
      if (double.parse(widget.totalCarrinho) < 20) {
        portes = 3.00;
      } else {
        portes = 0;
      }
    } else {
      portes = 0;
    }
    return WillPopScope(
        onWillPop: () async {
          telefonex2 = '';
          codexpostalex2 = '';
          adrex2 = '';
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckOut(
                            totalCarrinho: widget.totalCarrinho,
                            idEncomenda: widget.idEncomenda,
                            idLocalidade: widget.idLocalidade,
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
            title: Text('CHECK-OUT',
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
          bottomNavigationBar: FutureBuilder(
              future: fetchTotalProdIngCarrinho(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          color: Color.fromRGBO(45, 61, 75, 1),
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 1,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                alignment: Alignment.center,
                                child: Text(
                                  '${double.parse(widget.totalCarrinho) + portes} €',
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
                                width: MediaQuery.of(context).size.width * 0.1,
                                alignment: Alignment.center,
                                child: Container(
                                    height: 20,
                                    child: VerticalDivider(
                                      thickness: 2,
                                      color: Colors.white,
                                    )),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                alignment: Alignment.center,
                                child: Visibility(
                                  visible: _isVisibleButton,
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      try {
                                        Utils(context).startLoading();

                                        String idEquip = identifier.toString();

                                        setState(() {
                                          _isVisibleButton = false;
                                          _isLoading2 = true;
                                        });

                                        await Encomendas.encomendarProdutos(
                                            idEquip: idEquip, token: token);

                                        await Encomendas.encomendarIngredientes(
                                            idEquip: idEquip, token: token);

                                        //Receber id da encomenda

                                        final respostaEnvio =
                                            await Encomendas.envioEncomenda(
                                                idUser.toString(),
                                                identifier.toString(),
                                                widget.totalCarrinho.toString(),
                                                portes.toString(),
                                                adrex2.toString(),
                                                codexpostalex2.toString(),
                                                widget.localite.toString(),
                                                telefonex2.toString(),
                                                parts2[0]['email'],
                                                parts2[0]['nome'].toString(),
                                                widget.tipoLevantamento
                                                    .toString(),
                                                widget.hora.toString(),
                                                widget.comentarios,
                                                widget.mypagamento.toString(),
                                                token: token);

                                        print("RESPOSTA: $respostaEnvio");

                                        Map<String, dynamic> idDaRespostaBody =
                                            new Map<String, dynamic>.from(json
                                                .decode(respostaEnvio.body));

                                        final idResposta =
                                            idDaRespostaBody['id'].toString();

                                        //Substituir os IDs dos dispositivos pelos das encomendas

                                        await Encomendas.atualizaIdencomedaProd(
                                            idEncomenda: idResposta,
                                            idEquip: idEquip,
                                            token: token);

                                        await Encomendas
                                            .atualizaIdencomedaIngredientes(
                                                idEncomenda: idResposta,
                                                idEquip: idEquip,
                                                token: token);

                                        //Apagar os o carrinho
                                        await Encomendas.apagaEncomendasTemp(
                                            idEquip: idEquip, token: token);
                                        await Encomendas.apagaIngredientesTemp(
                                            idEquip: idEquip, token: token);
                                        await Encomendas.envioEmail(
                                            idEncomenda: idResposta,
                                            token: token);

                                        setState(() {
                                          idEncomenda = idResposta.toString();
                                          _isLoading2 = false;
                                          _isVisibleButton = true;
                                        });
                                        Utils(context).stopLoading();
                                        await Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        CheckOut3()));
                                      } catch (e) {
                                        print("ERRO $e");

                                        setState(() {
                                          _isLoading2 = false;
                                          _isVisibleButton = true;
                                        });
                                      }

                                      /*-------------------------------------------------------------------------- */
                                    },
                                    child: _isLoading2
                                        ? SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        Color.fromRGBO(
                                                            255, 255, 255, 1))),
                                          )
                                        : Text('TERMINER',
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
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromRGBO(
                                                  181, 142, 0, 0.9)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ));
                    });
              }),
          body: ListView(
            children: <Widget>[
              Column(
                children: [
                  Container(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(children: [
                            Container(
                                width: 30,
                                height: 30,
                                child: Center(
                                  child: Text('1',
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          package: 'awesome_package',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color:
                                              Color.fromRGBO(45, 61, 75, 1))),
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  border: Border.all(
                                      color: Color.fromRGBO(45, 61, 75, 1)),
                                )),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: SizedBox(
                                width: 80,
                                child: Text(
                                  "INFORMATIONS DE LIVRAISON",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: Color.fromRGBO(45, 61, 75, 1)),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 35),
                          child: Container(
                              width: 40,
                              child: Divider(
                                color: Colors.black,
                                thickness: 1,
                                height: 36,
                              )),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(children: [
                              Container(
                                  width: 30,
                                  height: 30,
                                  child: Center(
                                    child: Text('2',
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            package: 'awesome_package',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                            color: Color.fromRGBO(
                                                181, 142, 0, 1))),
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    border: Border.all(
                                        color: Color.fromRGBO(181, 142, 0, 1)),
                                  )),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: SizedBox(
                                  width: 80,
                                  child: Text(
                                    "TERMINER",
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        package: 'awesome_package',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11,
                                        color: Color.fromRGBO(181, 142, 0, 1)),
                                  ),
                                ),
                              ),
                            ])),
                      ],
                    ),
                  ),
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "OÙ VOULEZ-VOULEZ-VOU RECEVOIR VOTRE COMMANDE?",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(45, 61, 75, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 200,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "${widget.tipoLevantamento}",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(190, 190, 190, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 11.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 60,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "COMMENT ALLEZ-VOUS PAYER POUR VOTRE COMANDE?",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(45, 61, 75, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 200,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "${widget.mypagamento}",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(190, 190, 190, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 11.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 60,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "QUAND VOULEZ-VOUS VOTRE COMMANDE?",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(45, 61, 75, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 200,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "${widget.hora}",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(190, 190, 190, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 11.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "INFORMATIONS PERSONNELLES",
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 100,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "NOM",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(181, 142, 0, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 200,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "${parts2[0]['nome']}",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(112, 112, 112, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 60,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "CODE POSTAL",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(181, 142, 0, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 200,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "${codexpostalex2}",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(112, 112, 112, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 60,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "TELÉPHONE",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(181, 142, 0, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 200,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "${telefonex2}",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(112, 112, 112, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 60,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "ADRESSE",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(181, 142, 0, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 200,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "${adrex2}",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(112, 112, 112, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 60,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "LOCALITÉ",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(181, 142, 0, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 200,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            '${widget.localite}',
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(112, 112, 112, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 60,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "E-MAIL",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(181, 142, 0, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 200,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "${parts2[0]['email']}",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(112, 112, 112, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  Column(children: [
                    FutureBuilder(
                        future: fetchProdCarrinho(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
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
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
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
                                    height:
                                        MediaQuery.of(context).size.height / 80,
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          listProdutosCarrinho?.length ?? 0,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            Divider(
                                              color: Color.fromRGBO(
                                                  190, 190, 190, 1),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  60,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: Row(children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  child: Text(
                                                    "${listProdutosCarrinho?[index]['nome'].toUpperCase()}",
                                                    textAlign: TextAlign.left,
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          45, 61, 75, 1),
                                                      fontFamily: 'Poppins',
                                                      package:
                                                          'awesome_package',
                                                      fontSize: 12.5,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            5.5),
                                                Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                      "${listProdutosCarrinho?[index]['preco'] ?? 0} €",
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        package:
                                                            'awesome_package',
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                    )),
                                              ]),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  40,
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 16),
                                                child: FutureBuilder(
                                                    future: fetchProdCarrinho(),
                                                    builder:
                                                        (BuildContext context,
                                                            AsyncSnapshot
                                                                snapshot) {
                                                      if (snapshot.hasData) {
                                                        var idEncomenda =
                                                            (listProdutosCarrinho?[
                                                                        index]
                                                                    ['id'] ??
                                                                0);
                                                        List?
                                                            listIngredientesCarrinho;
                                                        Future<List<dynamic>>
                                                            fetchIngCarrinho() async {
                                                          final response =
                                                              await http.get(
                                                                  Uri.parse(
                                                                      '${ApiDevLafiducia}/ingrediente-carrinho/${idEncomenda}'));

                                                          if (response
                                                                  .statusCode ==
                                                              200) {
                                                            // If the server did return a 200 OK response,
                                                            // then parse the JSON.
                                                            return listIngredientesCarrinho =
                                                                json.decode(
                                                                    response
                                                                        .body);
                                                          } else {
                                                            // If the server did not return a 200 OK response,
                                                            // then throw an exception.
                                                            throw Exception(
                                                                'Failed to load album');
                                                          }
                                                        }

                                                        return FutureBuilder(
                                                            future:
                                                                fetchIngCarrinho(),
                                                            builder: (BuildContext
                                                                    context,
                                                                AsyncSnapshot
                                                                    snapshot) {
                                                              if (snapshot
                                                                  .hasData) {
                                                                return new ListView
                                                                        .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                    itemCount:
                                                                        listIngredientesCarrinho?.length ??
                                                                            0,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      var precoIngInd = double.parse(listIngredientesCarrinho?[index]['preco'] ??
                                                                              0) *
                                                                          double.parse(listIngredientesCarrinho?[index]['quantidade'] ??
                                                                              0);
                                                                      return Column(
                                                                          children: <
                                                                              Widget>[
                                                                            Row(children: [
                                                                              SizedBox(
                                                                                  width: MediaQuery.of(context).size.width * 0.5,
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Align(
                                                                                          alignment: Alignment.centerLeft,
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
                                                                                        height: MediaQuery.of(context).size.height * 0.003,
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
                                                                                              fontSize: 11,
                                                                                            ),
                                                                                          )),
                                                                                    ],
                                                                                  )),
                                                                              SizedBox(width: MediaQuery.of(context).size.width / 5),
                                                                              Align(
                                                                                  alignment: Alignment.centerRight,
                                                                                  child: Text(
                                                                                    "${precoIngInd.toStringAsFixed(2)} €",
                                                                                    style: const TextStyle(
                                                                                      fontFamily: 'Poppins',
                                                                                      package: 'awesome_package',
                                                                                      fontWeight: FontWeight.w300,
                                                                                      color: Colors.black,
                                                                                      fontSize: 14,
                                                                                    ),
                                                                                  )),
                                                                            ]),
                                                                            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                                                                          ]);
                                                                    });
                                                              } else {
                                                                return Container(
                                                                    height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height,
                                                                    child: Center(
                                                                        child: CircularProgressIndicator(
                                                                            valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(
                                                                                181,
                                                                                142,
                                                                                0,
                                                                                0.9)))));
                                                              }
                                                            });
                                                      } else {
                                                        return Container(
                                                            color: Color.fromRGBO(
                                                                235,
                                                                235,
                                                                235,
                                                                1),
                                                            height:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                            child: Center(
                                                                child: CircularProgressIndicator(
                                                                    valueColor: AlwaysStoppedAnimation<
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
                                  SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Text(
                                            "EXPÉDITION",
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(45, 61, 75, 1),
                                              fontFamily: 'Poppins',
                                              package: 'awesome_package',
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5.5),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "${portes}€",
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
                                  ),
                                  Divider(
                                    color: Color.fromRGBO(190, 190, 190, 1),
                                  ),
                                  SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Text(
                                            "TOTAL",
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(45, 61, 75, 1),
                                              fontFamily: 'Poppins',
                                              package: 'awesome_package',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5.5),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "${double.parse(widget.totalCarrinho) + portes}€",
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                package: 'awesome_package',
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            )),
                                      ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ]),
                ],
              ),
            ],
          ),
        ));
  }
}

class Utils {
  late BuildContext context;

  Utils(this.context);

  // this is where you would do your fullscreen loading
  Future<void> startLoading() async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const SimpleDialog(
          elevation: 0.0,
          backgroundColor:
              Colors.transparent, // can change this to your prefered color
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        );
      },
    );
  }

  Future<void> stopLoading() async {
    Navigator.of(context).pop();
  }

  Future<void> showError(Object? error) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        backgroundColor: Colors.red,
        content: Text("testeeeeee"),
      ),
    );
  }
}
