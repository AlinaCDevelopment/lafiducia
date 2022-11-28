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
import 'dart:async';

class CheckOut extends StatefulWidget {
  final String totalCarrinho;
  final String idEncomenda;
  final String idLocalidade;

  const CheckOut({
    Key? key,
    required this.totalCarrinho,
    required this.idEncomenda,
    required this.idLocalidade,
  }) : super(key: key);
  @override
  _CheckOutState createState() => _CheckOutState();
}

String? _myCity;

class _CheckOutState extends State<CheckOut> {
  @override
  void initState() {
    fetchLocalidade();
    _getCitiesList();
    getToken();
    fetchIdLocalidadeID();
    fetchHora();
    fetchHoraEstudante();
    _deviceDetails();
    fetchVerifica3();
    super.initState();
  }

  List hourlist = ['1:00', '2:00', '3:00', '4:00'];
  String? _myHour;
  String? _myHourEstudante;
  String? houra;
  List pagamentolist = ['Espécies', 'Carte Bancaire'];
  String? _mypagamento;
  List citiesList = [];

  late int val = 1;
  var i = 0;
  String identifier = '';
  String token = '';
  String localidadii = '';
  String tipoEntrega = '';
  var parts2;
  var statusVerifica3;
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

  List? listVerifica3;
  Future<List<dynamic>> fetchVerifica3() async {
    final response = await http
        .get(Uri.parse('${ApiDevLafiducia}/verifica-produto3/${identifier}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      statusVerifica3 = 200;

      return listVerifica3 = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      statusVerifica3 = 400;
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

  List? listNomelocalidadeSelecionada;

  Future getToken() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      token = (prefs.getString("token") ?? "");
    });
  }

  List? listHora;
  Future<List<dynamic>> fetchHora() async {
    final response =
        await http.get(Uri.parse('${ApiDevLafiducia}/horas-encomendas/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listHora = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return listHora = json.decode(response.body);
    }
  }

  List? listHoraEstudante;
  Future<List<dynamic>> fetchHoraEstudante() async {
    final response =
        await http.get(Uri.parse('${ApiDevLafiducia}/horas-estudante/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listHoraEstudante = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return listHoraEstudante = json.decode(response.body);
    }
  }

  String? _myCity;

  Widget build(BuildContext context) {
    String testeeee = '${listIDlocalidadeID?[0]['localidade']}';
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

    for (i = 0; i < 1;) {
      fetchIdLocalidadeID();
      fetchLocalidade();
      fetchVerifica3;
      fetchHora();
      fetchHoraEstudante();
      i++;
    }
    if (_myCity == null) {
      testeeee = '${listIDlocalidadeID?[0]['localidade']}';
    } else {
      testeeee = _myCity.toString();
    }

    Future<List<dynamic>> fetchNomeLocalidadeSelecionada() async {
      final response = await http
          .get(Uri.parse('${ApiDevLafiducia}/localidade-nome/${testeeee}'));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return listNomelocalidadeSelecionada = json.decode(response.body);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    }

    fetchNomeLocalidadeSelecionada();

    final TextEditingController moradaController = new TextEditingController();
    final TextEditingController codigoPostalController =
        new TextEditingController();
    final TextEditingController telefoneController =
        new TextEditingController();
    return Scaffold(
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
              var tetas = listIDlocalidadeID?[0]['valor'] ?? 0;
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
                                '${widget.totalCarrinho} €',
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
                                  var phone = telefoneController.text;

                                  bool phoneValid =
                                      RegExp(r'[0-9]{6,13}$').hasMatch(phone);

                                  if (val == 1) {
                                    tipoEntrega = "LIVRAISON À DOMICILE";
                                  } else if (val == 2) {
                                    tipoEntrega = "RAMASSER AU RESTAURANT";
                                  }
                                  if (statusVerifica3 == 200) {
                                    houra = _myHour;
                                  } else {
                                    houra = _myHourEstudante;
                                  }

                                  if (houra == null) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildPopupDialogHoraLevantamento(
                                              context),
                                    );
                                  } else if (_mypagamento == null) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildPopupDialogMetodoPagamento(
                                              context),
                                    );
                                  } else if (telefoneController.text != '' &&
                                      phoneValid == false) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildPopupDialogTelefone(context),
                                    );
                                  } else {
                                    if (val == 1) {
                                      if (_myCity == null) {
                                        if (double.parse(
                                                widget.totalCarrinho) >=
                                            tetas) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => CheckOut2(
                                                totalCarrinho:
                                                    widget.totalCarrinho,
                                                idEncomenda: widget.idEncomenda,
                                                mypagamento:
                                                    _mypagamento.toString(),
                                                idLocalidade:
                                                    widget.idLocalidade,
                                                tipoLevantamento: tipoEntrega,
                                                localite: listIDlocalidadeID?[0]
                                                        ['localidade'] ??
                                                    0,
                                                adresse2: moradaController.text,
                                                codePostal2:
                                                    codigoPostalController.text,
                                                telefone2:
                                                    telefoneController.text,
                                                hora: houra,
                                              ),
                                            ),
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                _buildPopupDialoglocalidadePortes(
                                                    context),
                                          );
                                        }
                                      } else if (_myCity != null) {
                                        if (double.parse(
                                                widget.totalCarrinho) >=
                                            listNomelocalidadeSelecionada?[0]
                                                ['valor']) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => CheckOut2(
                                                totalCarrinho:
                                                    widget.totalCarrinho,
                                                idEncomenda: widget.idEncomenda,
                                                mypagamento:
                                                    _mypagamento.toString(),
                                                idLocalidade:
                                                    widget.idLocalidade,
                                                tipoLevantamento: tipoEntrega,
                                                localite: _myCity.toString(),
                                                adresse2: moradaController.text,
                                                codePostal2:
                                                    codigoPostalController.text,
                                                telefone2:
                                                    telefoneController.text,
                                                hora: houra,
                                              ),
                                            ),
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                _buildPopupDialoglocalidadePortesESCOLHIDOS(
                                                    context),
                                          );
                                        }
                                      }
                                    } else if (val == 2) {
                                      if (_myCity == null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => CheckOut2(
                                              totalCarrinho:
                                                  widget.totalCarrinho,
                                              idEncomenda: widget.idEncomenda,
                                              mypagamento:
                                                  _mypagamento.toString(),
                                              idLocalidade: widget.idLocalidade,
                                              tipoLevantamento: tipoEntrega,
                                              localite: listIDlocalidadeID?[0]
                                                      ['localidade'] ??
                                                  0,
                                              adresse2: moradaController.text,
                                              codePostal2:
                                                  codigoPostalController.text,
                                              telefone2:
                                                  telefoneController.text,
                                              hora: houra,
                                            ),
                                          ),
                                        );
                                      } else if (_myCity != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => CheckOut2(
                                              totalCarrinho:
                                                  widget.totalCarrinho,
                                              idEncomenda: widget.idEncomenda,
                                              mypagamento:
                                                  _mypagamento.toString(),
                                              idLocalidade: widget.idLocalidade,
                                              tipoLevantamento: tipoEntrega,
                                              localite: _myCity.toString(),
                                              adresse2: moradaController.text,
                                              codePostal2:
                                                  codigoPostalController.text,
                                              telefone2:
                                                  telefoneController.text,
                                              hora: houra,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }
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
        body: Container(
            child: FutureBuilder<List<dynamic>>(
                future: fetchLocalidade(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return ListView(
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
                                                  color: Color.fromRGBO(
                                                      181, 142, 0, 1))),
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          border: Border.all(
                                              color: Color.fromRGBO(
                                                  181, 142, 0, 1)),
                                        )),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
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
                                              color: Color.fromRGBO(
                                                  181, 142, 0, 1)),
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
                                                        45, 61, 75, 1))),
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            border: Border.all(
                                                color: Color.fromRGBO(
                                                    45, 61, 75, 1)),
                                          )),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
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
                                                color: Color.fromRGBO(
                                                    45, 61, 75, 1)),
                                          ),
                                        ),
                                      ),
                                    ])),
                              ],
                            ),
                          ),
                          FutureBuilder<List<dynamic>>(
                              future: fetchVerifica3(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (statusVerifica3 == 400) {
                                  val = 2;
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Card(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12.0)),
                                      child: Container(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  50,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      13,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.2,
                                                  child: Text(
                                                    "OÙ VOULEZ-VOULEZ-VOU RECEVOIR VOTRE COMMANDE?",
                                                    textAlign: TextAlign.left,
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          181, 142, 0, 1),
                                                      fontFamily: 'Poppins',
                                                      package:
                                                          'awesome_package',
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  80,
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  160,
                                            ),
                                            if (statusVerifica3 == 200)
                                              Divider(
                                                color: Color.fromRGBO(
                                                    190, 190, 190, 1),
                                              ),
                                            if (statusVerifica3 == 200)
                                              FutureBuilder(
                                                  future:
                                                      fetchNomeLocalidadeSelecionada(),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot snapshot) {
                                                    List?
                                                        listNomelocalidadeSelecionada2;
                                                    var portex;
                                                    if (_myCity == null) {
                                                      portex =
                                                          listIDlocalidadeID?[0]
                                                              ['localidade'];
                                                    } else {
                                                      portex = _myCity;
                                                    }
                                                    Future<List<dynamic>>
                                                        fetchNomeLocalidadeSelecionada2() async {
                                                      final response = await http
                                                          .get(Uri.parse(
                                                              '${ApiDevLafiducia}/localidade-nome/${portex}'));

                                                      if (response.statusCode ==
                                                          200) {
                                                        // If the server did return a 200 OK response,
                                                        // then parse the JSON.
                                                        return listNomelocalidadeSelecionada2 =
                                                            json.decode(
                                                                response.body);
                                                      } else {
                                                        // If the server did not return a 200 OK response,
                                                        // then throw an exception.
                                                        throw Exception(
                                                            'Failed to load album');
                                                      }
                                                    }

                                                    fetchNomeLocalidadeSelecionada2();
                                                    return FutureBuilder(
                                                        future:
                                                            fetchNomeLocalidadeSelecionada2(),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot
                                                                snapshot) {
                                                          return OutlinedButton(
                                                            style:
                                                                OutlinedButton
                                                                    .styleFrom(
                                                              side: BorderSide(
                                                                style:
                                                                    BorderStyle
                                                                        .none,
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                val = 1;
                                                              });
                                                            },
                                                            child: Theme(
                                                              data: ThemeData(
                                                                  unselectedWidgetColor:
                                                                      Color.fromRGBO(
                                                                          181,
                                                                          142,
                                                                          0,
                                                                          1)),
                                                              child: ListTile(
                                                                title: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "LIVRAISON À DOMICILE",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            45,
                                                                            61,
                                                                            75,
                                                                            1),
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        package:
                                                                            'awesome_package',
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height /
                                                                          160,
                                                                    ),
                                                                    Text(
                                                                      "${listNomelocalidadeSelecionada2?[0]['mensagem'] ?? 'Loading...'}",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            100,
                                                                            100,
                                                                            100,
                                                                            1),
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        package:
                                                                            'awesome_package',
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    /*SizedBox(
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height /
                                                                          160,
                                                                    ),
                                                                    Text(
                                                                      "JUSQU'À 21H30",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            190,
                                                                            190,
                                                                            190,
                                                                            1),
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        package:
                                                                            'awesome_package',
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),*/
                                                                  ],
                                                                ),
                                                                leading: Radio(
                                                                  value: 1,
                                                                  groupValue:
                                                                      val,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      val = 1;
                                                                    });
                                                                  },
                                                                  activeColor: Color
                                                                      .fromRGBO(
                                                                          181,
                                                                          142,
                                                                          0,
                                                                          1),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  }),
                                            Divider(
                                              color: Color.fromRGBO(
                                                  190, 190, 190, 1),
                                            ),
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                side: BorderSide(
                                                  style: BorderStyle.none,
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  val = 2;
                                                });
                                              },
                                              child: Theme(
                                                data: ThemeData(
                                                    unselectedWidgetColor:
                                                        Color.fromRGBO(
                                                            181, 142, 0, 1)),
                                                child: ListTile(
                                                  title: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "RAMASSER AU RESTAURANT",
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              45, 61, 75, 1),
                                                          fontFamily: 'Poppins',
                                                          package:
                                                              'awesome_package',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            160,
                                                      ),
                                                      /*Text(
                                                        "JUSQU'À 22H00",
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              190, 190, 190, 1),
                                                          fontFamily: 'Poppins',
                                                          package:
                                                              'awesome_package',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),*/
                                                    ],
                                                  ),
                                                  leading: Radio(
                                                    value: 2,
                                                    groupValue: val,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        val = 2;
                                                      });
                                                    },
                                                    activeColor: Color.fromRGBO(
                                                        181, 142, 0, 1),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 40,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.15,
                                child: Text(
                                  "QUAND VOULEZ-VOUS VOTRE COMMANDE?",
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    color: Color.fromRGBO(181, 142, 0, 1),
                                    fontFamily: 'Poppins',
                                    package: 'awesome_package',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(181, 142, 0, 1),
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        if (statusVerifica3 == 200)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0.0, left: 50),
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(right: 40),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1,
                                              child: DropdownButton(
                                                icon: Image.asset(
                                                  "assets/right-arrow.png",
                                                  color: Colors.black,
                                                  width: 40,
                                                ),
                                                iconEnabledColor: Colors.white,
                                                iconDisabledColor: Colors.white,
                                                isExpanded: true,
                                                underline: SizedBox(),
                                                hint: Text(
                                                  'Sélectionner',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Poppins',
                                                    package: 'awesome_package',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16.0,
                                                  ),
                                                ), // Not necessary for Option 1

                                                value: _myHour,

                                                dropdownColor: Colors.white,

                                                onChanged: (listHora) {
                                                  setState(() {
                                                    _myHour =
                                                        listHora.toString();
                                                  });
                                                },

                                                items: listHora?.map((_myhour) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        new Text(
                                                          _myhour,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Poppins',
                                                            package:
                                                                'awesome_package',
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    value: _myhour,
                                                  );
                                                }).toList(),

                                                style: new TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (statusVerifica3 == 400)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0.0, left: 50),
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(right: 40),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1,
                                              child: DropdownButton(
                                                icon: Image.asset(
                                                  "assets/right-arrow.png",
                                                  color: Colors.black,
                                                  width: 40,
                                                ),
                                                iconEnabledColor: Colors.white,
                                                iconDisabledColor: Colors.white,
                                                isExpanded: true,
                                                underline: SizedBox(),
                                                hint: Text(
                                                  'Sélectionner',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Poppins',
                                                    package: 'awesome_package',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16.0,
                                                  ),
                                                ), // Not necessary for Option 1

                                                value: _myHourEstudante,

                                                dropdownColor: Colors.white,

                                                onChanged: (listHoraEstudante) {
                                                  setState(() {
                                                    _myHourEstudante =
                                                        listHoraEstudante
                                                            .toString();
                                                  });
                                                },

                                                items: listHoraEstudante
                                                    ?.map((_myHourEstudante) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        new Text(
                                                          _myHourEstudante,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Poppins',
                                                            package:
                                                                'awesome_package',
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    value: _myHourEstudante,
                                                  );
                                                }).toList(),

                                                style: new TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                color: Color.fromRGBO(190, 190, 190, 1),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 60,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.15,
                                child: Text(
                                  "COMMENT ALLEZ-VOUS PAYER POUR VOTRE COMANDE?",
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    color: Color.fromRGBO(181, 142, 0, 1),
                                    fontFamily: 'Poppins',
                                    package: 'awesome_package',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(181, 142, 0, 1),
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0.0, left: 50),
                                          child: Container(
                                            padding: EdgeInsets.only(right: 40),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1,
                                            child: DropdownButton(
                                              icon: Image.asset(
                                                "assets/right-arrow.png",
                                                color: Colors.black,
                                                width: 40,
                                              ),
                                              iconEnabledColor: Colors.white,
                                              iconDisabledColor: Colors.white,
                                              isExpanded: true,
                                              underline: SizedBox(),
                                              hint: Text(
                                                'Sélectionner',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins',
                                                  package: 'awesome_package',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.0,
                                                ),
                                              ), // Not necessary for Option 1

                                              value: _mypagamento,

                                              dropdownColor: Colors.white,

                                              onChanged: (pagamentolist) {
                                                setState(() {
                                                  _mypagamento =
                                                      pagamentolist.toString();
                                                });
                                              },

                                              items: pagamentolist
                                                  .map((_mypagamento) {
                                                return DropdownMenuItem<String>(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      new Text(
                                                        _mypagamento,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Poppins',
                                                          package:
                                                              'awesome_package',
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  value: _mypagamento,
                                                );
                                              }).toList(),

                                              style: new TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                color: Color.fromRGBO(190, 190, 190, 1),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 60,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.15,
                                child: Text(
                                  "QUELLE EST VOTRE POSITION ?",
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    color: Color.fromRGBO(181, 142, 0, 1),
                                    fontFamily: 'Poppins',
                                    package: 'awesome_package',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(181, 142, 0, 1),
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0.0, left: 50),
                                          child: Container(
                                            padding: EdgeInsets.only(right: 40),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1,
                                            child: DropdownButton<String>(
                                              icon: Image.asset(
                                                "assets/right-arrow.png",
                                                width: 40,
                                                color: Colors.black,
                                              ),
                                              iconEnabledColor: Colors.white,
                                              iconDisabledColor: Colors.white,
                                              isExpanded: true,
                                              underline: SizedBox(),
                                              hint: Text(
                                                '${listIDlocalidadeID?[0]['localidade'] ?? 0}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins',
                                                  package: 'awesome_package',
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _myCity = newValue.toString();
                                                });
                                              },
                                              items: citiesList.map((item) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    item?['localidade'] ?? 0,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins',
                                                      package:
                                                          'awesome_package',
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  value: item['localidade']
                                                      .toString(),
                                                );
                                              }).toList(),
                                              value: _myCity,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Card(
                                child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    child: Text(
                                      "ADRESSE*",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        color: Color.fromRGBO(181, 142, 0, 1),
                                        fontFamily: 'Poppins',
                                        package: 'awesome_package',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        120,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        200,
                                  ),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color.fromRGBO(181, 142, 0, 1),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 4, left: 8),
                                      child: TextFormField(
                                        controller: moradaController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                "${parts2?[0]['morada'] ?? 0}",
                                            hintStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  112, 112, 112, 1),
                                              fontFamily: 'Poppins',
                                              package: 'awesome_package',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            suffixIcon: moradaController
                                                    .text.isEmpty
                                                ? IconButton(
                                                    icon: Icon(
                                                      const IconData(0xeaed,
                                                          fontFamily:
                                                              'MaterialIcons'),
                                                      color: Color.fromRGBO(
                                                          181, 142, 0, 1),
                                                    ),
                                                    onPressed:
                                                        moradaController.clear,
                                                  )
                                                : Container(width: 0)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        200,
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    child: Text(
                                      "CODE POSTAL*",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        color: Color.fromRGBO(181, 142, 0, 1),
                                        fontFamily: 'Poppins',
                                        package: 'awesome_package',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        120,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        200,
                                  ),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color.fromRGBO(181, 142, 0, 1),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 4, left: 8),
                                      child: TextFormField(
                                          controller: codigoPostalController,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  "${parts2?[0]['cod_postal'] ?? 0}",
                                              hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    112, 112, 112, 1),
                                                fontFamily: 'Poppins',
                                                package: 'awesome_package',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              suffixIcon: moradaController
                                                      .text.isEmpty
                                                  ? IconButton(
                                                      icon: Icon(
                                                        const IconData(0xeaed,
                                                            fontFamily:
                                                                'MaterialIcons'),
                                                        color: Color.fromRGBO(
                                                            181, 142, 0, 1),
                                                      ),
                                                      onPressed:
                                                          moradaController
                                                              .clear,
                                                    )
                                                  : Container(width: 0)),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Poppins',
                                            package: 'awesome_package',
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ),
                                  ),

                                  /* SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    child: Text(
                                      "${parts2[0]['morada']}",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        color: Color.fromRGBO(112, 112, 112, 1),
                                        fontFamily: 'Poppins',
                                        package: 'awesome_package',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),*/

                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    child: Text(
                                      "TELÉPHONE*",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        color: Color.fromRGBO(181, 142, 0, 1),
                                        fontFamily: 'Poppins',
                                        package: 'awesome_package',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        120,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        200,
                                  ),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color.fromRGBO(181, 142, 0, 1),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 4, left: 8),
                                      child: TextFormField(
                                          controller: telefoneController,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  "${parts2[0]['telefone']}",
                                              hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    112, 112, 112, 1),
                                                fontFamily: 'Poppins',
                                                package: 'awesome_package',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              suffixIcon: telefoneController
                                                      .text.isEmpty
                                                  ? IconButton(
                                                      icon: Icon(
                                                        const IconData(0xeaed,
                                                            fontFamily:
                                                                'MaterialIcons'),
                                                        color: Color.fromRGBO(
                                                            181, 142, 0, 1),
                                                      ),
                                                      onPressed:
                                                          moradaController
                                                              .clear,
                                                    )
                                                  : Container(width: 0)),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Poppins',
                                            package: 'awesome_package',
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 30,
                          ),
                        ],
                      ),
                    ],
                  );
                })));
  }

  Widget _buildPopupDialogTelefone(BuildContext context) {
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
                      Text('Le téléphone a été mal inséré',
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

  Widget _buildPopupDialogMetodoPagamento(BuildContext context) {
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
                      Text("Le mode de paiement n'a pas été sélectionné",
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
                    height: MediaQuery.of(context).size.height / 50,
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

  Widget _buildPopupDialogHoraLevantamento(BuildContext context) {
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
                      Text(" L'heure de la commande n'a pas été sélectionnée",
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
                    height: MediaQuery.of(context).size.height / 50,
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

  Widget _buildPopupDialoglocalidadePortes(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: new AlertDialog(
        actions: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Column(
                    children: [
                      Text(
                          'Votre emplacement n est pas compatible avec votre valeur finale',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(181, 142, 0, 1),
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                      Text(
                          'Votre commande doit avoir une valeur supérieure ${listIDlocalidadeID?[0]['valor'].toString()}€',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontSize: 14,
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

  Widget _buildPopupDialoglocalidadePortesESCOLHIDOS(BuildContext context) {
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
                          'A sua localidade não é compativel com o seu valor final',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(181, 142, 0, 1),
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                      Text(
                          'A sua encomenda deve ter um valor acima de ${listNomelocalidadeSelecionada![0]['valor'].toString()}€',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontSize: 14,
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
