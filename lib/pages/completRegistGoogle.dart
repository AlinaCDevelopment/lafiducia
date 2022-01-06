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
import 'dart:math';
import 'package:email_auth/email_auth.dart';
import 'package:la_fiducia/login/auth.dart';
import 'dart:math';
import 'dart:async';

class Confirm extends StatefulWidget {
  final String mail;
  final String nome;
  final String tipoRegisto;
  final String registoGoogleFace;

  const Confirm({
    Key? key,
    required this.mail,
    required this.nome,
    required this.tipoRegisto,
    required this.registoGoogleFace,
  }) : super(key: key);
  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  @override
  void initState() {
    nomController.text = "${widget.nome}";
    mailcontroller.text = "${widget.mail}";
    _getCitiesList();
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
  String uniquecode = '';
  String mailxyz = '';
  String identifier = '';
  String tipooo = '';

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

  Future<void> _deviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;

        setState(() {
          identifier = build.androidId;
          tipooo = 'Android';
        });
        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        setState(() {
          identifier = data.identifierForVendor;
          tipooo = 'iOS';
        }); //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  TextEditingController nomController = new TextEditingController();
  final TextEditingController telefoneController = new TextEditingController();
  TextEditingController mailcontroller = new TextEditingController();
  final TextEditingController moradaController = new TextEditingController();
  final TextEditingController codigoPostalController =
      new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Widget build(BuildContext context) {
    if (i == 0) {
      _deviceDetails();
      i++;
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
          title: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text('ENREGISTREMENT COMPLET',
                style: TextStyle(
                  color: Color.fromRGBO(45, 61, 75, 1),
                  fontFamily: 'Poppins',
                  package: 'awesome_package',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                )),
          ),
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
                      height: MediaQuery.of(context).size.height / 40,
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
                        padding: const EdgeInsets.only(bottom: 0, left: 8),
                        child: TextField(
                          controller: nomController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "${widget.nome}",
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                package: 'awesome_package',
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  const IconData(0xeaed,
                                      fontFamily: 'MaterialIcons'),
                                  color: Color.fromRGBO(181, 142, 0, 1),
                                ),
                                onPressed: nomController.clear,
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    if (widget.tipoRegisto == '2')
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: Text(
                          "E-mail*",
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
                    if (widget.tipoRegisto == '2')
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 120,
                      ),
                    if (widget.tipoRegisto == '2')
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
                              controller: mailcontroller,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "${widget.mail}",
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(112, 112, 112, 1),
                                    fontFamily: 'Poppins',
                                    package: 'awesome_package',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      const IconData(0xeaed,
                                          fontFamily: 'MaterialIcons'),
                                      color: Color.fromRGBO(181, 142, 0, 1),
                                    ),
                                    onPressed: mailcontroller.clear,
                                  )),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                package: 'awesome_package',
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      ),
                    if (widget.tipoRegisto == '2')
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
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
                                hintText: "Insérer le téléphone",
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
                      height: MediaQuery.of(context).size.height / 40,
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
                    Container(
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
                                            'Sélectionnez une ville',
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
                                              _myCity = newValue.toString();
                                            });
                                          },
                                          items: citiesList.map((item) {
                                            return new DropdownMenuItem(
                                              child: new Text(
                                                item['localidade'],
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  package: 'awesome_package',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              value: item['id'].toString(),
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
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
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
                                hintText: "Entrer l'adresse",
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
                      height: MediaQuery.of(context).size.height / 40,
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
                                hintText: "Entrer le code postal",
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
                      height: MediaQuery.of(context).size.height / 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            alignment: Alignment.center,
                            child: OutlinedButton(
                              onPressed: () {
                                var phone = telefoneController.text;
                                bool phoneValid =
                                    RegExp(r'[0-9]{6,13}$').hasMatch(phone);

                                const _chars =
                                    'abcdefghijklmnopqrstuvwxyz1234567890';
                                Random _rnd = Random();

                                String getRandomString(int length) =>
                                    String.fromCharCodes(Iterable.generate(
                                        length,
                                        (_) => _chars.codeUnitAt(
                                            _rnd.nextInt(_chars.length))));
                                uniquecode = getRandomString(12);

                                String nomeGoogle = widget.nome;

                                String plataforma = widget.registoGoogleFace;

                                if (widget.mail == "Entrez l'e-mail") {
                                  setState(() {
                                    mailxyz = mailcontroller.text.toString();
                                  });
                                } else {
                                  setState(() {
                                    mailxyz = widget.mail.toString();
                                  });
                                }

                                if (nomController.text != '') {
                                  setState(() {
                                    nomeGoogle = nomController.text;
                                  });
                                }
                                if (telefoneController.text == '' ||
                                    phoneValid == false) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialogTelefone(context),
                                  );
                                } else if (mailxyz == "") {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialogMail(context),
                                  );
                                } else if (_myCity == null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialogLocalidade(context),
                                  );
                                } else if (moradaController.text == '') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialogMorada(context),
                                  );
                                } else if (codigoPostalController.text == '') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialogCodigoPostal(context),
                                  );
                                } else {
                                  Register(
                                    nomeGoogle,
                                    mailxyz,
                                    moradaController.text,
                                    codigoPostalController.text,
                                    _myCity,
                                    telefoneController.text,
                                    uniquecode,
                                    plataforma,
                                    tipooo,
                                  );
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
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      const Color.fromRGBO(181, 142, 0, 0.9)),
                                  side: MaterialStateProperty.all(BorderSide(
                                      color: Color.fromRGBO(181, 142, 0, 0.9),
                                      width: 0.0,
                                      style: BorderStyle.solid))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ),
          ],
        ));
  }

  Register(
    String nome,
    email,
    morada,
    codigoPostal,
    _myCity,
    telefone,
    uniquecode,
    String plataforma,
    tipo,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'nome': nome,
      'email': email,
      'morada': morada,
      'cod_postal': codigoPostal,
      'localidade': _myCity,
      'telefone': telefone,
      'uniqueCode': uniquecode,
      'plataforma_registo': plataforma,
      'sistema_registo': tipo,
    };
    var jsonResponse = null;
    var response = await http
        .post(Uri.parse('${ApiDevLafiducia}/utilizadores-google'), body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      if (jsonResponse != null) {
        /*sharedPreferences.setString("token", jsonResponse['token']);*/
        print('ESTA ÈEEEEE A RESPOOSSTTTTTTAAAAA' + jsonResponse['token']);

        save('token', jsonResponse['token']);

        var prefs = await SharedPreferences.getInstance();
        prefs.setString('token', jsonResponse['token']);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Menu()),
            (Route<dynamic> route) => false);
      }
    } else if (response.statusCode == 400) {
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(context),
      );
    }
  }

  Widget _buildPopupDialogMail(BuildContext context) {
    return new AlertDialog(
      actions: <Widget>[
        SizedBox(
            height: MediaQuery.of(context).size.height / 6.8,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 60,
                ),
                Column(
                  children: [
                    Text("Entrez l'e-mail",
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
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      actions: <Widget>[
        SizedBox(
            height: MediaQuery.of(context).size.height / 6.8,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 60,
                ),
                Column(
                  children: [
                    Text("Il y a eu une erreur dans le registre",
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
    );
  }

  Widget _buildPopupDialogTelefone(BuildContext context) {
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
                      Text('Téléphone mal inséré',
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

  Widget _buildPopupDialogLocalidade(BuildContext context) {
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
                      Text('Emplacement non renseigné',
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

  Widget _buildPopupDialogMorada(BuildContext context) {
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
                      Text('Adresse non renseignée',
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

  Widget _buildPopupDialogCodigoPostal(BuildContext context) {
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
                      Text('Code postal non saisi',
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
