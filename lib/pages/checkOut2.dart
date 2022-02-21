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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:la_fiducia/pages/checkOut.dart';
import 'package:la_fiducia/pages/checkOut3.dart';

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
    comentariosController.addListener(onListen);
  }

  @override
  void dispose() {
    comentariosController.removeListener(onListen);
    super.dispose();
  }

  void onListen() => setState(() {});

  final TextEditingController comentariosController =
      new TextEditingController();

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
    } on PlatformException {
      print('Failed to get platform version');
    }
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

  late List listTotalProdIngCarrinho;
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

  late List listProdutos;
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

  Widget build(BuildContext context) {
    for (i = 0; i < 1;) {
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

    print('ID ENCOMENDAAAAAAAA' + '' + widget.idEncomenda);

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
                                child: OutlinedButton(
                                  onPressed: () {
                                    /*------------------EPDATE PRODUTOS TABELA INGREDIENTESSSS ---------------------- */

                                    EmcomendasProdutos(String idEquip) async {
                                      Map data = {
                                        "id_equipamento": idEquip,
                                      };

                                      var jsonResponse = null;

                                      var response = await http.post(
                                          Uri.parse(
                                              '${ApiDevLafiducia}/encomendas-produtos/'),
                                          body: data,
                                          headers: {
                                            'Accept': 'application/json',
                                            'Authorization': 'Bearer $token',
                                          }).then((result) {
                                        print(result.statusCode);
                                        print(result.body);
                                      });
                                      ;

                                      jsonResponse = json.decode(response.body);
                                      print('é istooooooo!!!' +
                                          jsonResponse.toString());
                                    }

                                    EmcomendasProdutos(
                                      identifier.toString(),
                                    );

                                    EmcomendarIngredientes(
                                        String idEquip) async {
                                      Map data = {
                                        "id_equipamento": idEquip,
                                      };

                                      var jsonResponse = null;

                                      var response = await http.post(
                                          Uri.parse(
                                              '${ApiDevLafiducia}/encomendas-ingredientes/'),
                                          body: data,
                                          headers: {
                                            'Accept': 'application/json',
                                            'Authorization': 'Bearer $token',
                                          }).then((result) {
                                        print(result.statusCode);
                                        print(result.body);
                                      });
                                      ;

                                      jsonResponse = json.decode(response.body);
                                      print('é istooooooo!!!' +
                                          jsonResponse.toString());
                                    }

                                    EmcomendarIngredientes(
                                      identifier.toString(),
                                    );

                                    /*-------------------------------------------------------------------------- */
                                    /*------------------EPDATE PRODUTOS TABELA ENCOMANEDA ---------------------- */

                                    ApagaEncomendasTemp() async {
                                      var jsonResponse = null;

                                      var response = await http.delete(
                                          Uri.parse(
                                              '${ApiDevLafiducia}/apagar-encomendas-temp/${identifier.toString()}'),
                                          headers: {
                                            'Accept': 'application/json',
                                            'Authorization': 'Bearer $token',
                                          }).then((result) {
                                        print(result.statusCode);
                                        print(result.body);
                                      });
                                      ;

                                      jsonResponse = json.decode(response.body);
                                      print('é istooooooo!!!' +
                                          jsonResponse.toString());
                                    }

                                    ApagaIngredientesTemp() async {
                                      var jsonResponse = null;

                                      var response = await http.delete(
                                          Uri.parse(
                                              '${ApiDevLafiducia}/apagar-ingredientes-temp/${identifier.toString()}'),
                                          headers: {
                                            'Accept': 'application/json',
                                            'Authorization': 'Bearer $token',
                                          }).then((result) {
                                        print(result.statusCode);
                                        print(result.body);
                                      });
                                      ;

                                      jsonResponse = json.decode(response.body);
                                      print('é istooooooo!!!' +
                                          jsonResponse.toString());
                                    }

                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      ApagaEncomendasTemp();
                                      ApagaIngredientesTemp();
                                    });

                                    EnvioEncomenda(
                                        String user,
                                        session,
                                        preco,
                                        portez,
                                        morada,
                                        codpostal,
                                        localidade,
                                        tlefone,
                                        email,
                                        nome,
                                        envio,
                                        hora_levantamento,
                                        comentarios,
                                        pagamento) async {
                                      Map data = {
                                        "id_user": user,
                                        "id_session": session,
                                        "preco": preco,
                                        "portes": portez,
                                        "morada": morada,
                                        "cod_postal": codpostal,
                                        "localidade": localidade,
                                        "telefone": tlefone,
                                        "email": email,
                                        "nome": nome,
                                        "envio": envio,
                                        "hora_levantamento": hora_levantamento,
                                        "comentarios": comentarios,
                                        "pagamento": pagamento,
                                      };

                                      var jsonResponse = null;

                                      var response = await http.post(
                                          Uri.parse(
                                              '${ApiDevLafiducia}/encomendas/'),
                                          body: data,
                                          headers: {
                                            'Accept': 'application/json',
                                            'Authorization': 'Bearer $token',
                                          }).then((result) {
                                        print(result.statusCode);
                                        Map<String, dynamic> idDaRespostaBody =
                                            new Map<String, dynamic>.from(
                                                json.decode(result.body));

                                        setState(() {
                                          idEncomenda =
                                              idDaRespostaBody['id'].toString();
                                        });
                                      });

                                      AtualizaIdencomedaProd(
                                          String idEquip, idEncomenda) async {
                                        Map data = {
                                          "id_equipamento": idEquip,
                                          'id_encomenda': idEncomenda,
                                        };
                                        print('ESTE È O ID ENCOMENDAAAAA' +
                                            '' +
                                            idEncomenda);

                                        var jsonResponse = null;

                                        var response = await http.put(
                                            Uri.parse(
                                                '${ApiDevLafiducia}/atualiza-id_encomenda-produtos/'),
                                            body: data,
                                            headers: {
                                              'Accept': 'application/json',
                                              'Authorization': 'Bearer $token',
                                            }).then((result) {
                                          print(result.statusCode);
                                          print(result.body);
                                        });

                                        jsonResponse =
                                            json.decode(response.body);
                                        print('é istooooooo!!!' +
                                            jsonResponse.toString());
                                      }

                                      AtualizaIdencomedaProd(
                                          identifier.toString(), idEncomenda);

                                      AtualizaIdencomedaIngredientes(
                                          String idEquip, idEncomenda) async {
                                        Map data = {
                                          "id_equipamento": idEquip,
                                          'id_encomenda': idEncomenda,
                                        };

                                        var jsonResponse = null;

                                        var response = await http.put(
                                            Uri.parse(
                                                '${ApiDevLafiducia}/atualiza-id_encomenda-ingredientes/'),
                                            body: data,
                                            headers: {
                                              'Accept': 'application/json',
                                              'Authorization': 'Bearer $token',
                                            }).then((result) {
                                          print(result.statusCode);
                                          print(result.body);
                                        });

                                        jsonResponse =
                                            json.decode(response.body);
                                        print('é istooooooo!!!' +
                                            jsonResponse.toString());
                                      }

                                      AtualizaIdencomedaIngredientes(
                                          identifier.toString(), idEncomenda);

                                      EnvioEmail(String idEncomenda) async {
                                        Map data = {
                                          "id_encomenda": idEncomenda,
                                        };

                                        var jsonResponse = null;

                                        var response = await http.post(
                                            Uri.parse(
                                                '${ApiDevLafiducia}/enviar-encomenda/'),
                                            body: data,
                                            headers: {
                                              'Accept': 'application/json',
                                              'Authorization': 'Bearer $token',
                                            }).then((result) {
                                          print(result.statusCode);
                                          print(result.body);
                                        });
                                        ;

                                        jsonResponse =
                                            json.decode(response.body);
                                        print('é istooooooo!!!' +
                                            jsonResponse.toString());
                                      }

                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        ApagaEncomendasTemp();
                                        ApagaIngredientesTemp();

                                        EnvioEmail(
                                          idEncomenda,
                                        );
                                      });
                                    }

                                    EnvioEncomenda(
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
                                      widget.tipoLevantamento.toString(),
                                      widget.hora.toString(),
                                      comentariosController.text.toString(),
                                      widget.mypagamento.toString(),
                                    );

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CheckOut3(),
                                      ),
                                    );

                                    /*-------------------------------------------------------------------------- */
                                  },
                                  child: const Text('TERMINER',
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
                                    backgroundColor: MaterialStateProperty.all<
                                            Color>(
                                        const Color.fromRGBO(181, 142, 0, 0.9)),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "COMMENTAIRES:",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(181, 142, 0, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Color.fromRGBO(181, 142, 0, 1),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.0, bottom: 0),
                                child: TextFormField(
                                  maxLines: null,
                                  controller: comentariosController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        "insérez ici une note concernant votre commande",
                                    hintStyle: TextStyle(
                                      color: Color.fromRGBO(190, 190, 190, 1),
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  EmcomendasProdutos(String idEquip) async {
    Map data = {
      "id_equipamento": idEquip,
    };

    var jsonResponse = null;

    var response = await http.post(
        Uri.parse('${ApiDevLafiducia}/encomendas-produtos/'),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }).then((result) {
      print(result.statusCode);
      print(result.body);
    });
    ;

    jsonResponse = json.decode(response.body);
    print('é istooooooo!!!' + jsonResponse.toString());
  }
}
