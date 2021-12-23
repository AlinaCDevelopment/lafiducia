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
import 'package:flutter/gestures.dart';

class Infromations extends StatefulWidget {
  @override
  _InfromationsState createState() => _InfromationsState();
}

class _InfromationsState extends State<Infromations> {
  @override
  void initState() {
    _getCitiesList();
    getToken();
    super.initState();
  }

  bool _passwordVisible = false;
  var parts2;
  String token = '';
  List citiesList = [];
  String? _myCity;
  String? nomez;
  String? moradaz;
  String? codpostalz;
  String? localidadez;
  String? telefonex;
  String? passwordx;
  var i = 0;
  bool agree = false;
  Future getToken() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      token = (prefs.getString("token") ?? "");
    });
  }

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

  Future deleteToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  List? listIDlocalidadeID;
  Future<List<dynamic>> fetchIdLocalidadeID() async {
    final response = await http.get(
        Uri.parse('${ApiDevLafiducia}/localidade/${parts2[0]['localidade']}'));

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

  final TextEditingController nomController = new TextEditingController();
  final TextEditingController telefoneController = new TextEditingController();

  final TextEditingController moradaController = new TextEditingController();
  final TextEditingController codigoPostalController =
      new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Widget build(BuildContext context) {
    for (i = 0; i < 1;) {
      getToken();
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
          title: Text('INFORMATIONS PERSONNELLES',
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
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                  child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Text(
                        "NOM*",
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
                      height: MediaQuery.of(context).size.height / 120,
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
                        padding: const EdgeInsets.only(bottom: 4, left: 8),
                        child: TextField(
                          controller: nomController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "${parts2[0]['nome']}",
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(112, 112, 112, 1),
                                fontFamily: 'Poppins',
                                package: 'awesome_package',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              suffixIcon: nomController.text.isEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        const IconData(0xeaed,
                                            fontFamily: 'MaterialIcons'),
                                        color: Color.fromRGBO(181, 142, 0, 1),
                                      ),
                                      onPressed: nomController.clear,
                                    )
                                  : Container(width: 0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 60,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
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
                      height: MediaQuery.of(context).size.height / 120,
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
                        padding: const EdgeInsets.only(bottom: 4, left: 8),
                        child: TextFormField(
                            controller: telefoneController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "${parts2[0]['telefone']}",
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(112, 112, 112, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                suffixIcon: telefoneController.text.isEmpty
                                    ? IconButton(
                                        icon: Icon(
                                          const IconData(0xeaed,
                                              fontFamily: 'MaterialIcons'),
                                          color: Color.fromRGBO(181, 142, 0, 1),
                                        ),
                                        onPressed: moradaController.clear,
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 60,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Text(
                        "LOCALITÉ*",
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
                      height: MediaQuery.of(context).size.height / 120,
                    ),
                    FutureBuilder(
                        future: fetchIdLocalidadeID(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color.fromRGBO(181, 142, 0, 1),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: DropdownButtonHideUnderline(
                                            child: ButtonTheme(
                                              alignedDropdown: true,
                                              child: DropdownButton<String>(
                                                iconSize: 30,
                                                icon: (null),
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 16,
                                                ),
                                                hint: Text(
                                                  '${listIDlocalidadeID![0]['localidade']}',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        112, 112, 112, 1),
                                                    fontFamily: 'Poppins',
                                                    package: 'awesome_package',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _myCity =
                                                        newValue.toString();
                                                  });
                                                },
                                                items: citiesList.map((item) {
                                                  return new DropdownMenuItem(
                                                    child: new Text(
                                                      item['localidade'],
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        package:
                                                            'awesome_package',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 14,
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          );
                        }),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 60,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
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
                      height: MediaQuery.of(context).size.height / 120,
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
                        padding: const EdgeInsets.only(bottom: 4, left: 8),
                        child: TextFormField(
                          controller: moradaController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "${parts2[0]['morada']}",
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(112, 112, 112, 1),
                                fontFamily: 'Poppins',
                                package: 'awesome_package',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              suffixIcon: moradaController.text.isEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        const IconData(0xeaed,
                                            fontFamily: 'MaterialIcons'),
                                        color: Color.fromRGBO(181, 142, 0, 1),
                                      ),
                                      onPressed: moradaController.clear,
                                    )
                                  : Container(width: 0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 60,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
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
                      height: MediaQuery.of(context).size.height / 120,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 200,
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
                        padding: const EdgeInsets.only(bottom: 4, left: 8),
                        child: TextFormField(
                            controller: codigoPostalController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "${parts2[0]['cod_postal']}",
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(112, 112, 112, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                suffixIcon: moradaController.text.isEmpty
                                    ? IconButton(
                                        icon: Icon(
                                          const IconData(0xeaed,
                                              fontFamily: 'MaterialIcons'),
                                          color: Color.fromRGBO(181, 142, 0, 1),
                                        ),
                                        onPressed: moradaController.clear,
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 30,
                    ),
                    Column(
                      children: [
                        /*Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                                'RÉGLEMENTATION GÉNÉRALE DE LA PROTECTION DES DONNÉES.',
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 61, 75, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Material(
                                color: Colors.white,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor:
                                        Color.fromRGBO(181, 142, 0, 1),
                                  ),
                                  child: Checkbox(
                                    activeColor: Color.fromRGBO(181, 142, 0, 1),
                                    value: agree,
                                    onChanged: (value) {
                                      setState(() {
                                        agree = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text("J'ACCEPTE",
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      color: Color.fromRGBO(181, 142, 0, 1),
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    )),
                              )
                            ],
                          ),
                        ),*/
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 120,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text('CHANGER LE MOT DE PASSE',
                              style: TextStyle(
                                color: Color.fromRGBO(45, 61, 75, 1),
                                fontFamily: 'Poppins',
                                package: 'awesome_package',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 60,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            "PASSWORD*",
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
                          height: MediaQuery.of(context).size.height / 120,
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
                            padding: const EdgeInsets.only(bottom: 4, left: 8),
                            child: TextFormField(
                                obscureText: !_passwordVisible,
                                controller: passwordController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Nouveau mot de passe",
                                    hintStyle: TextStyle(
                                      color: Color.fromRGBO(112, 112, 112, 1),
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    suffixIcon:
                                        passwordController.text.isNotEmpty
                                            ? IconButton(
                                                icon: Icon(
                                                  _passwordVisible
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: Color.fromRGBO(
                                                      181, 142, 0, 1),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _passwordVisible =
                                                        !_passwordVisible;
                                                  });
                                                },
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 60,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          alignment: Alignment.center,
                          child: OutlinedButton(
                            onPressed: () {
                              var phone = telefoneController.text;
                              bool phoneValid =
                                  RegExp(r'[0-9]{6,13}$').hasMatch(phone);

                              var certo = 0;

                              if (telefoneController.text != '' &&
                                  phoneValid == false) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialogTelefone(context),
                                );
                              } else {
                                if (nomController.text == '')
                                  setState(() {
                                    nomez = "${parts2[0]['nome']}";
                                  });
                                if (nomController.text != '')
                                  setState(() {
                                    nomez = nomController.text;
                                  });
                                if (moradaController.text == '')
                                  setState(() {
                                    moradaz = "${parts2[0]['morada']}";
                                  });
                                if (moradaController.text != '')
                                  setState(() {
                                    moradaz = moradaController.text;
                                  });
                                if (codigoPostalController.text == '')
                                  setState(() {
                                    codpostalz = "${parts2[0]['cod_postal']}";
                                  });
                                if (codigoPostalController.text != '')
                                  setState(() {
                                    codpostalz = codigoPostalController.text;
                                  });
                                if (_myCity == null)
                                  setState(() {
                                    localidadez = "${parts2[0]['localidade']}";
                                  });
                                if (_myCity != null)
                                  setState(() {
                                    localidadez = _myCity;
                                  });
                                if (telefoneController.text == '')
                                  setState(() {
                                    telefonex = "${parts2[0]['telefone']}";
                                  });
                                if (telefoneController.text != '')
                                  setState(() {
                                    telefonex = telefoneController.text;
                                  });
                                if (certo == 0) {
                                  if (passwordController.text == '') {
                                    deleteToken();
                                    Register(
                                      "${parts2[0]['email']}",
                                      nomez,
                                      moradaz,
                                      codpostalz,
                                      localidadez,
                                      telefonex,
                                    );
                                  } else if (passwordController.text != '') {
                                    deleteToken();

                                    Register2(
                                      "${parts2[0]['email']}",
                                      nomez,
                                      moradaz,
                                      codpostalz,
                                      localidadez,
                                      telefonex,
                                      passwordController.text,
                                    );
                                  }

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialogSucessoEnvio(context),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialogjacepte(context),
                                  );
                                }
                                ;
                              }
                            },
                            child: const Text('ENRESGISTRER',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    package: 'awesome_package',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 16)),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromRGBO(181, 142, 0, 0.9)),
                                side: MaterialStateProperty.all(BorderSide(
                                    color: Color.fromRGBO(181, 142, 0, 0.9),
                                    width: 0.0,
                                    style: BorderStyle.solid))),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 20,
                        ),
                        Text(
                            "Attention: Une fois votre compte supprimé, vous ne pourrez plus le réactiver et vous perdrez l'accès à toutes vos données.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              overflow: TextOverflow.clip,
                              color: Color.fromRGBO(45, 61, 75, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            )),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 100,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                            ),
                            children: [
                              TextSpan(
                                  text: 'REMOVE ACCOUNT',
                                  style: TextStyle(
                                    color: const Color(0xFFB58E00),
                                    fontFamily: 'Poppins',
                                    package: 'awesome_package',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      Widget _buildPopupDialogcertezaRemover(
                                          BuildContext context) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child: new AlertDialog(
                                            actions: <Widget>[
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      5,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            60,
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text('ATTENTION!',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        181,
                                                                        142,
                                                                        0,
                                                                        1),
                                                                fontFamily:
                                                                    'Poppins',
                                                                package:
                                                                    'awesome_package',
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              )),
                                                          Text(
                                                              'Êtes-vous sûr de vouloir supprimer complètement votre compte?',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        45,
                                                                        61,
                                                                        75,
                                                                        1),
                                                                fontFamily:
                                                                    'Poppins',
                                                                package:
                                                                    'awesome_package',
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              )),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            50,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          OutlinedButton(
                                                            onPressed: () {
                                                              deleteToken();
                                                              deleteAccount(
                                                                "${parts2[0]['email']}",
                                                              );
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    _buildPopupDialogContaRemovidaSucesso(
                                                                        context),
                                                              );
                                                            },
                                                            child: const Text(
                                                                "OUI",
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
                                                                        16)),
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<Color>(
                                                                        const Color.fromRGBO(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            1)),
                                                                side: MaterialStateProperty.all(BorderSide(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            181,
                                                                            142,
                                                                            0,
                                                                            0.9),
                                                                    width: 1.0,
                                                                    style: BorderStyle
                                                                        .solid))),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                10,
                                                          ),
                                                          OutlinedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "NON",
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
                                                                        16)),
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<Color>(
                                                                        const Color.fromRGBO(
                                                                            181,
                                                                            142,
                                                                            0,
                                                                            0.9)),
                                                                side: MaterialStateProperty.all(BorderSide(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            181,
                                                                            142,
                                                                            0,
                                                                            0.9),
                                                                    width: 0.0,
                                                                    style: BorderStyle
                                                                        .solid))),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        );
                                      }

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildPopupDialogcertezaRemover(
                                                context),
                                      );
                                    }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )),
            ),
          ],
        ));
  }

  Register(String mail, nome, morada, codpostal, localidade, tlefone) async {
    Map data = {
      "email": mail,
      'nome': nome,
      "morada": morada,
      "cod_postal": codpostal,
      "localidade": localidade,
      "telefone": tlefone,
    };

    var jsonResponse = null;

    var response = await http.put(
        Uri.parse('${ApiDevLafiducia}/utilizadores-editar'),
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
  }

  Register2(
      String mail, nome, morada, codpostal, localidade, tlefone, pass) async {
    Map data = {
      "email": mail,
      'nome': nome,
      "morada": morada,
      "cod_postal": codpostal,
      "localidade": localidade,
      "telefone": tlefone,
      "password": pass,
    };

    var jsonResponse = null;

    var response = await http.put(
        Uri.parse('${ApiDevLafiducia}/utilizadores-editar-pw'),
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

  deleteAccount(String mail) async {
    var jsonResponse = null;

    var response = await http
        .delete(Uri.parse('${ApiDevLafiducia}/apagar-conta/${mail}'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((result) {
      print(result.statusCode);
      print(result.body);
    });

    jsonResponse = json.decode(response.body);
    print('é istooooooo!!!' + jsonResponse.toString());
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
                      Text("Le téléphone a été mal inséré",
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

  Widget _buildPopupDialogjacepte(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: new AlertDialog(
        actions: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height / 7,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Column(
                    children: [
                      Text(
                          "N'a pas accepté la politique de protection des données",
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

  Widget _buildPopupDialogSucessoEnvio(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: new AlertDialog(
        actions: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height / 7,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Column(
                    children: [
                      Text("Vos informations ont été mises à jour avec succès",
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
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Menu()),
                              (Route<dynamic> route) => false);
                        },
                        child: const Text("Ok",
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

  Widget _buildPopupDialogContaRemovidaSucesso(BuildContext context) {
    return new AlertDialog(
      actions: <Widget>[
        SizedBox(
            height: MediaQuery.of(context).size.height / 5,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 100,
                ),
                Column(
                  children: [
                    Text("SUCCÈS!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(181, 142, 0, 1),
                          fontFamily: 'Poppins',
                          package: 'awesome_package',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 50,
                    ),
                    Text("COMPTE SUPPRIMÉ AVEC SUCCÈS",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(181, 142, 0, 1),
                          fontFamily: 'Poppins',
                          package: 'awesome_package',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        )),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) => Menu()),
                            (Route<dynamic> route) => false);
                      },
                      child: const Text("J'ACCEPTE",
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
    );
  }
}
